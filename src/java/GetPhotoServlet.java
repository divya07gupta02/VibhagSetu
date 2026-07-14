import java.io.*; // InputStream aur OutputStream ke liye
import java.sql.*; // Connection, PreparedStatement, ResultSet, Blob ke liye
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/GetPhotoServlet")
public class GetPhotoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
        String fid = request.getParameter("fid");
       
        if (fid == null || fid.isEmpty()) return;

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/vibhag_setu", "vibhagSetu", "vibhagSetu");
           
            // PHOTOGRAPH column fetch kar rahe hain
            PreparedStatement ps = con.prepareStatement(
                "SELECT PHOTOGRAPH FROM VIBHAGSETU.FACULTY WHERE F_ID = ?");
           
            // Agar F_ID database mein INT hai, toh parseInt use karein
            ps.setInt(1, Integer.parseInt(fid));
           
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Blob blob = rs.getBlob("PHOTOGRAPH");
                if (blob != null && blob.length() > 0) {
                    response.setContentType("image/jpeg");
                   
                    InputStream in = blob.getBinaryStream();
                    OutputStream out = response.getOutputStream();
                   
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = in.read(buffer)) != -1) {
                        out.write(buffer, 0, bytesRead);
                    }
                    in.close();
                    out.flush();
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