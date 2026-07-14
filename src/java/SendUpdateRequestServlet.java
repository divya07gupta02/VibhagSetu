import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;
import java.util.Date;
import java.text.SimpleDateFormat;

@WebServlet("/SendUpdateRequestServlet")
public class SendUpdateRequestServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String fid = request.getParameter("fid");

            // Array of field names and their new values from the form
            String[][] fields = {
                {"FIRST_NAME", request.getParameter("first_name")},
                {"MIDDLE_NAME", request.getParameter("middle_name")},
                {"LAST_NAME", request.getParameter("last_name")},
                {"EMAIL", request.getParameter("email")},
                {"CONTACT_NO", request.getParameter("contact")},
                {"TITLE", request.getParameter("title")},
                {"MOTHER_NAME", request.getParameter("mother_name")},
                {"FATHER_NAME", request.getParameter("father_name")},
                {"CITY", request.getParameter("city")},
                {"STATE", request.getParameter("state")},
                {"ADDRESS", request.getParameter("address")},
                {"ZIPCODE", request.getParameter("zipcode")},
                {"DOB", request.getParameter("dob")},
                {"MARITAL_STATUS", request.getParameter("marital_status")},
                {"GENDER", request.getParameter("gender")},
                {"CATEGORY", request.getParameter("category")},
                {"MOTHER_TONGUE", request.getParameter("mother_tongue")},
                {"DISABILITY", request.getParameter("disability")},
                {"QUALIFICATION", request.getParameter("qualification")},
                {"EXPERIENCE", request.getParameter("experience")},
                {"DESIGNATION", request.getParameter("designation")},
                {"NATIONALITY", request.getParameter("nationality")},
                {"AADHAR_NO", request.getParameter("aadhar")}
            };

            // ===== DATABASE CONNECTION =====
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection(
                    "jdbc:derby://localhost:1527/vibhag_setu",
                    "vibhagSetu", "vibhagSetu");

            // ===== CURRENT DATE =====
            Date now = new Date();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String requestDate = sdf.format(now);

            // ===== INSERT EACH FIELD INTO UPDATE_REQUESTS =====
            String sql = "INSERT INTO UPDATE_REQUESTS "
                       + "(F_ID, FIELD_NAME, OLD_VALUE, NEW_VALUE, STATUS, REQUEST_DATE) "
                       + "VALUES (?, ?, ?, ?, 'PENDING', ?)";

            PreparedStatement ps = con.prepareStatement(sql);

            for (int i = 0; i < fields.length; i++) {
                String fieldName = fields[i][0];
                String newValue = fields[i][1];

                if (newValue != null && !newValue.trim().isEmpty()) {
                    // Get old value from FACULTY table
                    String oldVal = "";
                    PreparedStatement oldPs = con.prepareStatement(
                        "SELECT " + fieldName + " FROM FACULTY WHERE F_ID=?"
                    );
                    oldPs.setInt(1, Integer.parseInt(fid));
                    ResultSet rs = oldPs.executeQuery();
                    if (rs.next()) {
                        oldVal = rs.getString(1);
                    }
                    rs.close();
                    oldPs.close();

                    // Insert into UPDATE_REQUESTS
                    ps.setInt(1, Integer.parseInt(fid));
                    ps.setString(2, fieldName);
                    ps.setString(3, oldVal);
                    ps.setString(4, newValue);
                    ps.setString(5, requestDate);

                    ps.executeUpdate();
                }
            }

            ps.close();
            con.close();

            // ===== SUCCESS MESSAGE =====
           
            response.sendRedirect("UpdateRequestsServlet?id=" + fid + "&success=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}