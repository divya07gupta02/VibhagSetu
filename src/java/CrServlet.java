import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import util.PasswordUtil;
import javax.servlet.annotation.WebServlet;


@WebServlet("/CrServlet")
public class CrServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String user = request.getParameter("username");
        String pass = request.getParameter("password");
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
                "SELECT * FROM VIBHAGSETU.CR WHERE USER_NAME=? AND PASSWORD=?"
            );

            ps.setString(1, user);
           ps.setString(2, hashedPass);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Correct login
                String crName = rs.getString("NAME");   // change column name if different
    String crEmail = rs.getString("EMAIL");
      int firstLogin = rs.getInt("FIRST_LOGIN");
       int crId = rs.getInt("CR_STUDENT_ID");  
              HttpSession session = request.getSession();
                session.setAttribute("crUser", user);
                session.setAttribute("crName", crName);
    session.setAttribute("crEmail", crEmail);
            session.setAttribute("crId", crId);

              

                if (firstLogin == 1) {
                    response.sendRedirect("changePassword.jsp");
                } else {
                    response.sendRedirect("crDash.jsp");
                }

            } else {
                response.sendRedirect("CrLogin.html?error=invalid");
            }

            con.close();

        } catch (Exception e) {
            out.println(e);
        }
    }
}