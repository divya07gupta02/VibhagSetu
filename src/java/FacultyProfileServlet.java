import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/FacultyProfileServlet")
public class FacultyProfileServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("facultyId") == null) {
            // Not logged in → redirect to login
            response.sendRedirect("facLogin.html");
            return;
        }

        int facultyId = (Integer) session.getAttribute("facultyId");

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection(
                    "jdbc:derby://localhost:1527/vibhag_setu",
                    "vibhagSetu",
                    "vibhagSetu"
            );

            // Select all fields needed for the profile
            PreparedStatement ps = con.prepareStatement(
                    "SELECT * FROM VIBHAGSETU.FACULTY WHERE F_ID=?"
            );
            ps.setInt(1, facultyId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Store all fields in an ArrayList to send to JSP
                ArrayList<String> record = new ArrayList<>();
                record.add(String.valueOf(rs.getInt("F_ID")));      // 0
                record.add(rs.getString("FIRST_NAME"));            // 1
                record.add(rs.getString("MIDDLE_NAME"));           // 2
                record.add(rs.getString("LAST_NAME"));             // 3
                record.add(rs.getString("EMAIL"));                 // 4
                record.add(rs.getString("CONTACT_NO"));           // 5
                record.add(rs.getString("USER_NAME"));             // 6
                record.add(rs.getString("PASSWORD"));              // 7
                record.add(rs.getString("TITLE"));                 // 8
                record.add(rs.getString("MOTHER_NAME"));           // 9
                record.add(rs.getString("FATHER_NAME"));           // 10
                record.add(rs.getString("CITY"));                  // 11
                record.add(rs.getString("STATE"));                 // 12
                record.add(rs.getString("ADDRESS"));               // 13
                record.add(rs.getString("ZIPCODE"));               // 14
                record.add(rs.getString("DOB"));                   // 15
                record.add(rs.getString("MARITAL_STATUS"));        // 16
                record.add(rs.getString("GENDER"));                // 17
                record.add(rs.getString("CATEGORY"));              // 18
                record.add(rs.getString("MOTHER_TONGUE"));        // 19
                record.add(rs.getString("DISABILITY"));           // 20
                record.add(rs.getString("QUALIFICATION"));        // 21
                record.add(rs.getString("SALARY"));               // 22
                record.add(rs.getString("EXPERIENCE"));           // 23
                record.add(rs.getString("DESIGNATION"));          // 24
                record.add(rs.getString("NATIONALITY"));          // 25
                record.add(rs.getString("AADHAR_NO"));
                record.add(rs.getString("PHOTOGRAPH")); 
                record.add(rs.getString("TIMETABLE")); 
                

                request.setAttribute("record", record);

                // Forward to JSP
                RequestDispatcher rd = request.getRequestDispatcher("facultyProfile.jsp");
                rd.forward(request, response);
            } else {
                out.println("<h3 style='text-align:center;color:red;'>No record found!</h3>");
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace(out);
        }
    }
}