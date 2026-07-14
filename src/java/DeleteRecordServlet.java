import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;

@WebServlet("/DeleteRecordServlet")
public class DeleteRecordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

       

        String type = request.getParameter("type"); // faculty or cr
        String idStr = request.getParameter("id");  // F_ID or CR_STUDENT_ID

        if (type == null || type.trim().isEmpty() || idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect("deleteField.jsp?error=1");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect("deleteField.jsp?error=1");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            con = DriverManager.getConnection(
                    "jdbc:derby://localhost:1527/vibhag_setu",
                    "vibhagSetu",
                    "vibhagSetu");

            String sql = "";

            if ("faculty".equalsIgnoreCase(type)) {

                sql = "UPDATE FACULTY SET FLAG = 0 WHERE F_ID = ?";
                ps = con.prepareStatement(sql);
                ps.setInt(1, id);

            } else if ("cr".equalsIgnoreCase(type)) {

                sql = "UPDATE CR SET FLAG = 0 WHERE CR_STUDENT_ID = ?";
                ps = con.prepareStatement(sql);
                ps.setInt(1, id);

            } else {
               response.sendRedirect("deleteField.jsp?error=1");
                return;
            }

            int rows = ps.executeUpdate();

            if (rows > 0) {

    if(type.equalsIgnoreCase("faculty")){
        response.sendRedirect("deleteField.jsp?deleted=1");
    }
    else{
        response.sendRedirect("deleteCrField.jsp?deleted=1");
    }

} else {

    if(type.equalsIgnoreCase("faculty")){
        response.sendRedirect("deleteField.jsp?deleted=0");
    }
    else{
        response.sendRedirect("deleteCrField.jsp?deleted=0");
    }

}

        } catch (SQLException sqle) {
            response.sendRedirect("deleteField.jsp?error=1");
            sqle.printStackTrace();
        } catch (Exception e) {
            response.sendRedirect("deleteField.jsp?error=1");
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}
