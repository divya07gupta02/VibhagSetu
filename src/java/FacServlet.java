import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import util.PasswordUtil;

public class FacServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        // Hash the password
        String hashedPass = PasswordUtil.hashPassword(pass);

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");

            Connection con = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/vibhag_setu",
                "vibhagSetu", "vibhagSetu"
            );

            PreparedStatement ps = con.prepareStatement(
                "SELECT F_ID, FIRST_NAME, EMAIL, FIRST_LOGIN FROM VIBHAGSETU.FACULTY WHERE USER_NAME=? AND PASSWORD=? AND FLAG=1 "
            );

            ps.setString(1, user);
            ps.setString(2, hashedPass);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int facultyId = rs.getInt("F_ID");      // ✅ get F_ID after rs.next()
                String facultyName = rs.getString("FIRST_NAME");
                String email = rs.getString("EMAIL");
                int firstLogin = rs.getInt("FIRST_LOGIN");

                HttpSession session = request.getSession();
                session.setAttribute("facultyId", facultyId);    // store ID for FacultyProfileServlet
                session.setAttribute("facultyUser", user);
                session.setAttribute("facultyName", facultyName);
                session.setAttribute("facultyEmail", email);

                if (firstLogin == 1) {
                    response.sendRedirect("changePassword.jsp");
                } else {
                    response.sendRedirect("facdash.jsp");
                }
            } else {
                // Invalid credentials
                response.sendRedirect("facLogin.html?error=invalid");
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            out.println(e);
        }
    }
}