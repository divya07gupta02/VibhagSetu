import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;
import java.util.HashSet;
import java.util.Set;

@WebServlet("/QuickUpdateServlet")
public class QuickUpdateServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        String type = request.getParameter("type"); // faculty or cr
        String id = request.getParameter("id");
        String field = request.getParameter("field");
        String value = request.getParameter("value");

        try {
            // -----------------------------
            // Step 1: Define allowed fields
            // -----------------------------
            Set<String> allowedFacultyFields = new HashSet<>();
            allowedFacultyFields.add("FIRST_NAME");
            allowedFacultyFields.add("MIDDLE_NAME");
            allowedFacultyFields.add("LAST_NAME");
            allowedFacultyFields.add("EMAIL");
            allowedFacultyFields.add("CONTACT_NO");
            allowedFacultyFields.add("TITLE");
            allowedFacultyFields.add("MOTHER_NAME");
            allowedFacultyFields.add("FATHER_NAME");
            allowedFacultyFields.add("CITY");
            allowedFacultyFields.add("STATE");
            allowedFacultyFields.add("ADDRESS");
            allowedFacultyFields.add("ZIPCODE");
            allowedFacultyFields.add("DOB");
            allowedFacultyFields.add("MARITAL_STATUS");
            allowedFacultyFields.add("GENDER");
            allowedFacultyFields.add("CATEGORY");
            allowedFacultyFields.add("MOTHER_TONGUE");
            allowedFacultyFields.add("DISABILITY");
            allowedFacultyFields.add("QUALIFICATION");
            allowedFacultyFields.add("EXPERIENCE");
            allowedFacultyFields.add("SALARY");
            allowedFacultyFields.add("DESIGNATION");
            allowedFacultyFields.add("NATIONALITY");
            allowedFacultyFields.add("AADHAR_NO");

            Set<String> allowedCrFields = new HashSet<>();
            allowedCrFields.add("NAME");
            allowedCrFields.add("EMAIL");
            allowedCrFields.add("CONTACT_NO");
            allowedCrFields.add("BRANCH");
            allowedCrFields.add("YEAR");
            allowedCrFields.add("SECTION");

            // --------------------------------
            // Step 2: Validate type & field
            // --------------------------------
            if("faculty".equalsIgnoreCase(type) && !allowedFacultyFields.contains(field)) {
                out.print("Invalid field for faculty: " + field);
                return;
            }

            if("cr".equalsIgnoreCase(type) && !allowedCrFields.contains(field)) {
                out.print("Invalid field for CR: " + field);
                return;
            }

            // -----------------------------
            // Step 3: Connect to database
            // -----------------------------
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/vibhag_setu",
                "vibhagSetu",
                "vibhagSetu"
            );

            // -----------------------------
            // Step 4: Prepare SQL statement
            // -----------------------------
            String sql = "";
            if("faculty".equalsIgnoreCase(type)){
                sql = "UPDATE FACULTY SET " + field + "=? WHERE F_ID=?";
            } else if("cr".equalsIgnoreCase(type)){
                sql = "UPDATE CR SET " + field + "=? WHERE CR_STUDENT_ID=?";
            } else {
                out.print("Invalid type: " + type);
                return;
            }

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, value);
            ps.setInt(2, Integer.parseInt(id));

            // -----------------------------
            // Step 5: Execute update
            // -----------------------------
            int rows = ps.executeUpdate();
            if(rows > 0){
                out.print("Record updated successfully");
            } else {
                out.print("Record not found");
            }

            ps.close();
            con.close();

        } catch(Exception e) {
            e.printStackTrace(out);
            out.print("Error updating record");
        }
    }
}