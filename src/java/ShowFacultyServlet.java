import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ShowFileServlet")
public class ShowFacultyServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int fid = Integer.parseInt(request.getParameter("fid"));
        String type = request.getParameter("type"); // "photo" or "timetable"

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/vibhag_setu",
                "vibhagSetu", "vibhagSetu"
            );

            String sql = "SELECT " + (type.equals("photo") ? "PHOTOGRAPH" : "TIMETABLE") +
                         " FROM FACULTY WHERE F_ID=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, fid);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                InputStream is = rs.getBinaryStream(1);
                if (is != null) {
                    if (type.equals("photo")) response.setContentType("image/jpeg");
                    else response.setContentType("application/octet-stream");

                    OutputStream os = response.getOutputStream();
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = is.read(buffer)) != -1) {
                        os.write(buffer, 0, bytesRead);
                    }
                    is.close();
                    os.close();
                }
            }
            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace(response.getWriter());
        }
    }
}