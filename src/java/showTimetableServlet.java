import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;

@WebServlet("/showTimetableServlet")
public class showTimetableServlet extends HttpServlet {

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

            // Use the actual column name of timetable in your table
            PreparedStatement ps = con.prepareStatement(
                "SELECT TIMETABLE FROM " + table + " WHERE " + idColumn + " = ?"
            );
            ps.setString(1, fid);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Blob blob = rs.getBlob("TIMETABLE"); // Make sure column name matches exactly
                if (blob != null) {
                    // PDF or image? If PDF, use application/pdf
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
                    response.getWriter().println("No timetable found for ID: " + fid);
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