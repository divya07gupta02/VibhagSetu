import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // HTML form ke 'name' attribute se data fetch karna
        String name = request.getParameter("fullname");
        String username = request.getParameter("username"); // Naya field
        String email = request.getParameter("email");
        String contact = request.getParameter("contact");   // Naya field
        String pass = request.getParameter("password");
        String confirmPass = request.getParameter("confirmPassword");

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Basic validation: Passwords match hone chahiye
        if (!pass.equals(confirmPass)) {
            out.println("<script>alert('Passwords do not match!'); window.location='login.html';</script>");
            return;
        }

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/vibhag_setu",
                "vibhagSetu", "vibhagSetu"
            );

            // Naya record insert karne ke liye SQL query
            // Dhayan dein: Table columns ke naam aapke DB ke hisaab se honi chahiye
            // Matches your actual table columns: NAME, EMAIL, PASSWORD
        String sql = "INSERT INTO VIBHAGSETU.ADMIN (NAME, USERNAME, PASSWORD, CONTACT_NO, EMAIL) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(sql);

        ps.setString(1, name);
        ps.setString(2, username);
        ps.setString(3, pass);
        ps.setString(4, contact);
        ps.setString(5, email);

            int row = ps.executeUpdate();

//            if (row > 0) {
//                // Agar insert ho gaya toh vapas login page par bhej dein
//                out.println("<script>alert('Registration Successful! Please Login.'); window.location='login.html';</script>");
//            } else {
//                out.println("<script>alert('Registration Failed. Try again.'); window.location='login.html';</script>");
//            }
            if (row > 0) {
                // ✅ Registration success hote hi user ko mail bhejein
                try {
                    MailUtil.sendWelcomeMail(email, name);
                    System.out.println("Registration Mail sent successfully to: " + email);
                } catch (Exception e) {
                    System.out.println("Mail bhejane mein galti hui: " + e.getMessage());
                    // Mail fail hone par bhi registration success hi rahega
                }

                // Agar insert ho gaya toh vapas login page par bhej dein
                out.println("<script>alert('Registration Successful! Welcome Mail has been sent.'); window.location='adminLogin.html';</script>");
            } else {
                out.println("<script>alert('Registration Failed. Try again.'); window.location='adminLogin.html';</script>");
            }

            con.close();

        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    }
}
        
    
