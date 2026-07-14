import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;
import java.util.*;

@WebServlet("/UpdateRequestsServlet")
public class UpdateRequestsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
String success = request.getParameter("success");
request.setAttribute("success", success);
        String id = request.getParameter("id");

        if (id == null || id.trim().isEmpty()) {
            response.getWriter().println("Faculty ID missing");
            return;
        }

        ArrayList<String> record = new ArrayList<>();

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection(
                    "jdbc:derby://localhost:1527/vibhag_setu",
                    "vibhagSetu",
                    "vibhagSetu"
            );

            PreparedStatement ps = con.prepareStatement(
    "SELECT F.F_ID, F.FIRST_NAME, F.MIDDLE_NAME, F.LAST_NAME, F.EMAIL, F.CONTACT_NO, " +
    "F.TITLE, F.MOTHER_NAME, F.FATHER_NAME, F.CITY, F.STATE, F.ADDRESS, F.ZIPCODE, F.DOB, " +
    "F.MARITAL_STATUS, F.GENDER, F.CATEGORY, F.MOTHER_TONGUE, F.DISABILITY, F.QUALIFICATION, " +
    "F.EXPERIENCE, F.DESIGNATION, F.NATIONALITY, F.AADHAR_NO, D.NAME AS DEPARTMENT " +
    "FROM FACULTY F " +
    "LEFT JOIN WORKS W ON F.F_ID = W.F_ID " +
    "LEFT JOIN DEPARTMENT D ON W.D_ID = D.D_ID " +
    "WHERE F.F_ID = ? AND F.FLAG = 1"
);

            ps.setInt(1, Integer.parseInt(id));

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                for (int i = 1; i <= 25; i++) { // 25th column = department
                    record.add(rs.getString(i));
                }
            }

            rs.close();
            ps.close();
            con.close();

            request.setAttribute("record", record);
            request.setAttribute("fid", id);

            request.getRequestDispatcher("updateRequest.jsp").forward(request, response);
response.sendRedirect("UpdateRequestsServlet?id=" + id + "&success=1");
        } catch (Exception e) {
            response.getWriter().println(e);
        }
    }
}