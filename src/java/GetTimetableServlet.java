import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet; // Yeh import zaroori hai
import javax.servlet.http.*;

@WebServlet("/GetTimetableServlet")
public class GetTimetableServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
        String fid = request.getParameter("fid");
       
        if (fid == null || fid.isEmpty()) {
            return; // Agar ID nahi hai toh kuch mat dikhao
        }

        try {
            // Driver load karna (Zaroori agar GlassFish version purana hai)
            Class.forName("org.apache.derby.jdbc.ClientDriver");
           
            Connection con = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/vibhag_setu", "vibhagSetu", "vibhagSetu");
           
            // TIMETABLE column fetch kar rahe hain
            PreparedStatement ps = con.prepareStatement(
                "SELECT TIMETABLE FROM VIBHAGSETU.FACULTY WHERE F_ID = ?");
            ps.setInt(1, Integer.parseInt(fid));
           
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Blob blob = rs.getBlob("TIMETABLE");
                if (blob != null && blob.length() > 0) {
                    response.setContentType("image/png"); // Default content type
                   
                    InputStream in = blob.getBinaryStream();
                    OutputStream out = response.getOutputStream();
                   
                    byte[] buffer = new byte[4096];
                    int len;
                    while ((len = in.read(buffer)) != -1) {
                        out.write(buffer, 0, len);
                    }
                    in.close();
                    out.flush();
                } else {
                    // Agar photo nahi hai toh ek default image ya error bhej sakte hain
                    response.getWriter().println("No Timetable Image Found");
                            }
            }
            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}