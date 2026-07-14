import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;

@WebServlet("/ProcessRequestServlet")
public class ProcessRequestServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String requestId = request.getParameter("requestId");
        String fid = request.getParameter("fid");
        String action = request.getParameter("action");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            con = DriverManager.getConnection(
                    "jdbc:derby://localhost:1527/vibhag_setu",
                    "vibhagSetu", "vibhagSetu");

            if ("approve".equals(action)) {

                String sql = "UPDATE UPDATE_REQUESTS SET STATUS='APPROVED' WHERE REQUEST_ID=?";
                ps = con.prepareStatement(sql);
                ps.setString(1, requestId);
                ps.executeUpdate();
                ps.close();

                response.sendRedirect("editFaculty.jsp?fid=" + fid + "&requestId=" + requestId);

            } else if ("reject".equals(action)) {

                String sql = "UPDATE UPDATE_REQUESTS SET STATUS='REJECTED' WHERE REQUEST_ID=?";
                ps = con.prepareStatement(sql);
                ps.setString(1, requestId);
                ps.executeUpdate();
                ps.close();

                response.sendRedirect("ViewUpdateRequestsServlet?success=1&actionDone=reject");
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}