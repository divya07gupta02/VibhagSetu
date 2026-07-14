import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;

@WebServlet("/showPhotoServlet")
public class showPhotoServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fid = request.getParameter("fid"); // ID
        String type = request.getParameter("type"); // "faculty" or "cr"

        if (fid == null || type == null) {
            response.getWriter().println("ID or type missing!");
            return;
        }

        String table = type.equalsIgnoreCase("cr") ? "CR" : "FACULTY";
        String idColumn = type.equalsIgnoreCase("cr") ? "CR_STUDENT_ID" : "F_ID";

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/vibhag_setu", "vibhagSetu", "vibhagSetu"
            );

            // Use PHOTOGRAPH instead of PHOTO
            PreparedStatement ps = con.prepareStatement(
                "SELECT PHOTOGRAPH FROM " + table + " WHERE " + idColumn + " = ?"
            );
            ps.setString(1, fid);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Blob blob = rs.getBlob("PHOTOGRAPH");
                if (blob != null) {
                    response.setContentType("image/jpeg");
                    response.setContentLength((int) blob.length());

                    InputStream in = blob.getBinaryStream();
                    OutputStream out = response.getOutputStream();
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = in.read(buffer)) != -1) {
                        out.write(buffer, 0, bytesRead);
                    }
                    in.close();
                    out.flush();
                } else {
                    response.getWriter().println("No photo found for ID: " + fid);
                }
            } else {
                response.getWriter().println("Record not found for ID: " + fid);
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}