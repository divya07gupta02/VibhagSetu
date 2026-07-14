import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;
import java.util.*;

@WebServlet("/ViewRecordServlet")
public class ViewRecordServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String type = request.getParameter("type");
        String name = request.getParameter("name");
        String idStr = request.getParameter("id");   // rename for clarity
        String mode = request.getParameter("mode");

        // Validate type
        if (type == null || type.trim().isEmpty()) {
            response.getWriter().println("Type missing!");
            return;
        }

        // Validate id if present
        Integer id = null;
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                id = Integer.parseInt(idStr.trim());
            } catch (NumberFormatException e) {
                response.getWriter().println("Invalid ID format!");
                return;
            }
        }

        ArrayList<ArrayList<String>> records = new ArrayList<>();

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");

            Connection con = DriverManager.getConnection(
                    "jdbc:derby://localhost:1527/vibhag_setu",
                    "vibhagSetu",
                    "vibhagSetu"
            );

            PreparedStatement ps = null;

            /* ================= FACULTY ================= */
            if ("faculty".equalsIgnoreCase(type)) {

                if (id != null) { // Fetch by ID
                    ps = con.prepareStatement(
                        "SELECT F.F_ID, F.FIRST_NAME, F.MIDDLE_NAME, F.LAST_NAME, " +
                        "F.EMAIL, F.CONTACT_NO, F.USER_NAME, F.PASSWORD, F.TITLE, " +
                        "F.MOTHER_NAME, F.FATHER_NAME, F.CITY, F.STATE, F.ADDRESS, F.ZIPCODE, F.DOB, " +
                        "F.MARITAL_STATUS, F.GENDER, F.CATEGORY, F.MOTHER_TONGUE, F.DISABILITY, " +
                        "F.QUALIFICATION, F.SALARY, F.EXPERIENCE, F.DESIGNATION, F.NATIONALITY, " +
                        "F.AADHAR_NO, F.PHOTOGRAPH, F.TIMETABLE, " +
                        "D.NAME AS DEPARTMENT, " +
                        "W.DOJ, W.DATE_OF_INCREMENT, W.CONTRACT_END_DATE " +
                        "FROM FACULTY F " +
                        "LEFT JOIN WORKS W ON F.F_ID = W.F_ID " +
                        "LEFT JOIN DEPARTMENT D ON W.D_ID = D.D_ID " +
                        "WHERE F.F_ID = ? AND F.FLAG = 1"
                    );
                    ps.setInt(1, id);

                } else if (name != null && !name.trim().isEmpty()) { // Fetch by Name
                    ps = con.prepareStatement(
                        "SELECT F.F_ID, F.FIRST_NAME, F.MIDDLE_NAME, F.LAST_NAME, " +
                        "F.EMAIL, F.CONTACT_NO, F.USER_NAME, F.PASSWORD, F.TITLE, " +
                        "F.MOTHER_NAME, F.FATHER_NAME, F.CITY, F.STATE, F.ADDRESS, F.ZIPCODE, F.DOB, " +
                        "F.MARITAL_STATUS, F.GENDER, F.CATEGORY, F.MOTHER_TONGUE, F.DISABILITY, " +
                        "F.QUALIFICATION, F.SALARY, F.EXPERIENCE, F.DESIGNATION, F.NATIONALITY, " +
                        "F.AADHAR_NO, F.PHOTOGRAPH, F.TIMETABLE, " +
                        "D.NAME AS DEPARTMENT, " +
                        "W.DOJ, W.DATE_OF_INCREMENT, W.CONTRACT_END_DATE " +
                        "FROM FACULTY F " +
                        "LEFT JOIN WORKS W ON F.F_ID = W.F_ID " +
                        "LEFT JOIN DEPARTMENT D ON W.D_ID = D.D_ID " +
                        "WHERE (F.FIRST_NAME = ? OR F.LAST_NAME = ?) AND F.FLAG = 1"
                    );

                    String[] parts = name.trim().split("\\s+");
                    String first = parts.length > 0 ? parts[0] : "";
                    String last = parts.length > 1 ? parts[parts.length - 1] : "";
                    ps.setString(1, first);
                    ps.setString(2, last);

                } else { // Fetch all faculty
                    ps = con.prepareStatement(
                        "SELECT F.F_ID, F.FIRST_NAME, F.MIDDLE_NAME, F.LAST_NAME, " +
                        "F.EMAIL, F.CONTACT_NO, F.USER_NAME, F.PASSWORD, F.TITLE, " +
                        "F.MOTHER_NAME, F.FATHER_NAME, F.CITY, F.STATE, F.ADDRESS, F.ZIPCODE, F.DOB, " +
                        "F.MARITAL_STATUS, F.GENDER, F.CATEGORY, F.MOTHER_TONGUE, F.DISABILITY, " +
                        "F.QUALIFICATION, F.SALARY, F.EXPERIENCE, F.DESIGNATION, F.NATIONALITY, " +
                        "F.AADHAR_NO, F.PHOTOGRAPH, F.TIMETABLE, " +
                        "D.NAME AS DEPARTMENT, " +
                        "W.DOJ, W.DATE_OF_INCREMENT, W.CONTRACT_END_DATE " +
                        "FROM FACULTY F " +
                        "LEFT JOIN WORKS W ON F.F_ID = W.F_ID " +
                        "LEFT JOIN DEPARTMENT D ON W.D_ID = D.D_ID " +
                        "WHERE F.FLAG = 1"
                    );
                }

            }
            /* ================= CR ================= */
            else if ("cr".equalsIgnoreCase(type)) {

                if (id != null) { // Fetch by ID
                    ps = con.prepareStatement(
                        "SELECT CR.CR_STUDENT_ID, CR.NAME, CR.USER_NAME, CR.PASSWORD, CR.EMAIL, CR.CONTACT_NO, " +
                        "CL.BRANCH, CL.C_YEAR, CL.SECTION, CO.NAME AS COURSE " +
                        "FROM CR CR " +
                        "LEFT JOIN CLASS CL ON CR.CR_STUDENT_ID = CL.CR_STUDENT_ID " +
                        "LEFT JOIN COURSE CO ON CL.C_ID = CO.C_ID " +
                        "WHERE CR.CR_STUDENT_ID = ? AND CR.FLAG = 1"
                    );
                    ps.setInt(1, id);

                } else { // Fetch all CRs
                    ps = con.prepareStatement(
                        "SELECT CR.CR_STUDENT_ID, CR.NAME, CR.USER_NAME, CR.PASSWORD, CR.EMAIL, CR.CONTACT_NO, " +
                        "CL.BRANCH, CL.C_YEAR, CL.SECTION, CO.NAME AS COURSE " +
                        "FROM CR CR " +
                        "LEFT JOIN CLASS CL ON CR.CR_STUDENT_ID = CL.CR_STUDENT_ID " +
                        "LEFT JOIN COURSE CO ON CL.C_ID = CO.C_ID " +
                        "WHERE CR.FLAG = 1"
                    );
                }

            } else {
                response.getWriter().println("Invalid type!");
                return;
            }

            // Execute query and collect results
            ResultSet rs = ps.executeQuery();
            ResultSetMetaData rsmd = rs.getMetaData();
            int colCount = rsmd.getColumnCount();

            while (rs.next()) {
                ArrayList<String> row = new ArrayList<>();
                for (int i = 1; i <= colCount; i++) {
                    row.add(rs.getString(i));
                }
                records.add(row);
            }

            rs.close();
            ps.close();
            con.close();

            request.setAttribute("records", records);
            request.setAttribute("type", type);
            request.setAttribute("mode", mode);
            request.getRequestDispatcher("viewDetails.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}