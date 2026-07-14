import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/SowFileServlet")
public class SowFileServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int fid = Integer.parseInt(request.getParameter("fid"));

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            try (Connection con = DriverManager.getConnection(
                     "jdbc:derby://localhost:1527/vibhag_setu",
                     "vibhagSetu", "vibhagSetu")) {

                String sql = "SELECT TIMETABLE FROM FACULTY WHERE F_ID=?";
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, fid);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            try (InputStream is = rs.getBinaryStream("TIMETABLE");
                                 OutputStream os = response.getOutputStream()) {

                                if (is != null) {
                                    // Timetable is an image (jpeg)
                                    response.setContentType("image/jpeg");
                                    // Optional: force download
                                    response.setHeader("Content-Disposition", "inline;filename=timetable_" + fid + ".jpg");
                                    byte[] buffer = new byte[4096];
                                    int bytesRead;
                                    while ((bytesRead = is.read(buffer)) != -1) {
                                        os.write(buffer, 0, bytesRead);
                                    }
                                    os.flush();
                                } else {
                                    response.getWriter().println("No timetable uploaded");
                                }

                            }
                        } else {
                            response.getWriter().println("Faculty not found");
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace(response.getWriter());
        }
    }
}