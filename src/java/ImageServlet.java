import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
@WebServlet("/ImageServlet")
public class ImageServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fid = request.getParameter("fid");
        String type = request.getParameter("type");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");

            con = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/vibhag_setu",
                "vibhagSetu",
                "vibhagSetu"
            );

            String column = type.equals("photo") ? "PHOTOGRAPH" : "TIMETABLE";

            ps = con.prepareStatement(
                "SELECT " + column + " FROM FACULTY WHERE F_ID = ?"
            );
            ps.setInt(1, Integer.parseInt(fid));

            rs = ps.executeQuery();

            if (rs.next()) {
                byte[] imgData = rs.getBytes(1);

                response.setContentType("image/jpeg");
                response.getOutputStream().write(imgData);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs!=null) rs.close(); } catch(Exception e){}
            try { if(ps!=null) ps.close(); } catch(Exception e){}
            try { if(con!=null) con.close(); } catch(Exception e){}
        }
    }
}