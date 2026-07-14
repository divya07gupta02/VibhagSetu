import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        try {
            // Load Derby Driver
            Class.forName("org.apache.derby.jdbc.ClientDriver");

            // DB Connection
            Connection con = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/vibhag_setu",
                "vibhagSetu",
                "vibhagSetu"
            );

            // Admin Login Query
//            PreparedStatement ps = con.prepareStatement(
//                "SELECT * FROM VIBHAGSETU.ADMIN WHERE USERNAME=? AND PASSWORD=?"
//            );
             PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM VIBHAGSETU.ADMIN " +
                "WHERE USERNAME=? AND PASSWORD=? AND LOGIN_TYPE='NORMAL'"
            );
            ps.setString(1, user);
            ps.setString(2, pass);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                 String adminName = rs.getString("NAME");  // Admin NAME column
                String adminEmail = rs.getString("EMAIL"); // Admin EMAIL column

                HttpSession session = request.getSession(true);
                session.setAttribute("role", "admin");
                session.setAttribute("username", user);
                 session.setAttribute("adminName", adminName);
                session.setAttribute("adminEmail", adminEmail);


                response.sendRedirect(
                    request.getContextPath() + "/adminDash.jsp"
                );
            } else {
                response.sendRedirect(
                    request.getContextPath() + "/adminLogin.html?error=invalid"
                );
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
