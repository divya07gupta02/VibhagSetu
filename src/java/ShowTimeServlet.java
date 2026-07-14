import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;

@WebServlet("/ShowTimeServlet")
public class ShowTimeServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fidStr = request.getParameter("fid");
        String type = request.getParameter("type"); // optional, in case you serve CR too

        if(fidStr == null || fidStr.trim().isEmpty()){
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Faculty ID missing");
            return;
        }

        int fid = Integer.parseInt(fidStr);

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/vibhag_setu",
                "vibhagSetu",
                "vibhagSetu"
            );

            String sql = "SELECT TIMETABLE FROM FACULTY WHERE F_ID = ? AND FLAG = 1";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, fid);
            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                Blob blob = rs.getBlob("TIMETABLE");
                if(blob != null){
                    response.setContentType("image/png"); // or "image/jpeg" depending on your image
                    InputStream is = blob.getBinaryStream();
                    OutputStream os = response.getOutputStream();

                    byte[] buffer = new byte[4096];
                    int bytesRead = -1;
                    while((bytesRead = is.read(buffer)) != -1){
                        os.write(buffer, 0, bytesRead);
                    }

                    os.flush();
                    os.close();
                    is.close();
                } else {
                    response.getWriter().println("No timetable uploaded.");
                }
            } else {
                response.getWriter().println("Faculty not found.");
            }

            rs.close();
            ps.close();
            con.close();

        } catch(Exception e){
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}