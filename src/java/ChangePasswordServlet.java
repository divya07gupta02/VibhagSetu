import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import util.PasswordUtil;
import javax.servlet.annotation.WebServlet;

@WebServlet("/ChangePasswordServlet")
public class ChangePasswordServlet extends HttpServlet {
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    response.sendRedirect(request.getContextPath() + "/changePassword.jsp");
}

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        
       // System.out.println("servlet hit");
        HttpSession session = request.getSession(false);

        // ❌ No session → force login
        if (session == null || session.getAttribute("facultyUser") == null) {
            response.sendRedirect("facLogin.html");
            return;
        }
        
//System.out.println("STEP 2: facultyUser = " + session.getAttribute("facultyUser"));

        String username = session.getAttribute("facultyUser").toString();
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
System.out.println("STEP 3: username = " + username);

           PreparedStatement ps = con.prepareStatement(
    
                "UPDATE VIBHAGSETU.FACULTY " +
                "SET PASSWORD = ?, FIRST_LOGIN = 0 " +
                "WHERE USER_NAME = ?"
);

            ps.setString(1, hashedPassword);
            ps.setString(2, username);

//            ps.executeUpdate();
//
//            // ✅ Optional: session safety
//            session.setAttribute("passwordUpdated", true);
//
//            response.sendRedirect("facDash.html");
//
//            con.close();
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.sendRedirect("changePassword.html?error=server");
//        }
//    }
//}
              int rows = ps.executeUpdate();   // ✅ DEBUG
     
            System.out.println("Rows updated = " + rows);

            con.close();

            if (rows == 1) {
                 response.sendRedirect(
                    request.getContextPath() + "/facdash.jsp"
                );
            } else {
                response.sendRedirect(
                    request.getContextPath() + "/changePassword.jsp?error=update"
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
                       response.sendRedirect(
                request.getContextPath() + "/changePassword.jsp?error=server"
            );

        }
    }
}