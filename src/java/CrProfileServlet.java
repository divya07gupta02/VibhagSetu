import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/CrProfileServlet")
public class CrProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");

            Connection con = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/vibhag_setu",
                "vibhagSetu", "vibhagSetu"
            );

            HttpSession session = request.getSession();
            int crId = (int) session.getAttribute("crId");

            // ✅ UPDATED QUERY (JOIN ADDED)
            PreparedStatement ps = con.prepareStatement(
    "SELECT CR.NAME, CR.USER_NAME, CR.EMAIL, CR.CONTACT_NO, " +
    "C.BRANCH, C.C_YEAR, C.SECTION, CO.NAME AS COURSE " +
    "FROM VIBHAGSETU.CR CR " +
    "LEFT JOIN VIBHAGSETU.CLASS C ON CR.CR_STUDENT_ID = C.CR_STUDENT_ID " +
    "LEFT JOIN VIBHAGSETU.COURSE CO ON C.C_ID = CO.C_ID " +
    "WHERE CR.CR_STUDENT_ID=?"
);

            ps.setInt(1, crId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                request.setAttribute("name", rs.getString("NAME"));
                request.setAttribute("username", rs.getString("USER_NAME"));
                request.setAttribute("email", rs.getString("EMAIL"));
                request.setAttribute("contact", rs.getString("CONTACT_NO"));

                // ✅ NEW FIELDS
                request.setAttribute("branch", rs.getString("BRANCH"));
                request.setAttribute("year", rs.getString("C_YEAR"));
                request.setAttribute("section", rs.getString("SECTION"));
                request.setAttribute("course", rs.getString("COURSE"));
            }

            rs.close();
            ps.close();
            con.close();

            request.getRequestDispatcher("crProfile.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}