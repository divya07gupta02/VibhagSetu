import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import util.PasswordUtil;
import javax.servlet.annotation.WebServlet;

@WebServlet("/ChangeCRPasswordServlet")
public class ChangeCRPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(request.getContextPath() + "/changePassword.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // ❌ No session or CR not logged in
        if (session == null || session.getAttribute("crUser") == null) {
            response.sendRedirect("CrLogin.html");
            return;
        }

        String username = session.getAttribute("crUser").toString();
        String newPass = request.getParameter("new_password");
        String confirmPass = request.getParameter("confirm_password");

        // ❌ Password mismatch
        if (!newPass.equals(confirmPass)) {
            response.sendRedirect(request.getContextPath() + "/changePassword.jsp?error=mismatch");
            return;
        }

        // 
                String hashedPassword = PasswordUtil.hashPassword(newPass);

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");

            Connection con = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/vibhag_setu",
                "vibhagSetu", "vibhagSetu"
            );

            PreparedStatement ps = con.prepareStatement(
                "UPDATE VIBHAGSETU.CR " +
                "SET PASSWORD=?, FIRST_LOGIN=0 " +
                "WHERE USER_NAME=?"
            );

            ps.setString(1, hashedPassword);
            ps.setString(2, username);

            int rows = ps.executeUpdate();
            con.close();

            if (rows == 1) {
                response.sendRedirect("crDash.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/changePassword.jsp?error=update");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/changePassword.jsp?error=server");
        }
    }
}
