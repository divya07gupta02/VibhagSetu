import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import org.json.JSONObject;
import org.apache.commons.codec.binary.Base64;

@WebServlet("/GoogleLoginServlet")
public class GoogleLoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("text/plain");
        String token = request.getParameter("token");

        if (token == null || token.isEmpty()) {
            response.getWriter().write("error");
            return;
        }

        try {
            // Decode JWT (basic – production needs verification)
           /* String[] parts = token.split("\\.");
            String payload = new String(
                java.util.Base64.getUrlDecoder().decode(parts[1])
            );*/
             String[] parts = token.split("\\.");
            if (parts.length < 2) {
                response.getWriter().write("error");
                return;
            }

            byte[] decodedBytes = Base64.decodeBase64(parts[1]);
            String payload = new String(decodedBytes, "UTF-8");

            // Extract email & name
            org.json.JSONObject json = new org.json.JSONObject(payload);
            String email = json.getString("email");
            String name  = json.optString("name", "Google User");
            String username = email.split("@")[0];
//DB connection
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/vibhag_setu",
                "vibhagSetu", "vibhagSetu"
            );

            // Check if user exists
            PreparedStatement check = con.prepareStatement(
                "SELECT * FROM VIBHAGSETU.ADMIN WHERE EMAIL=?"
            );
            check.setString(1, email);
            ResultSet rs = check.executeQuery();

            if (!rs.next()) {
                // New user → insert (NO PASSWORD!)
                String sql = "INSERT INTO VIBHAGSETU.ADMIN (NAME, USERNAME, PASSWORD, CONTACT_NO, EMAIL,LOGIN_TYPE) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement insert = con.prepareStatement(sql);

                insert.setString(1, name);
                insert.setString(2, email.split("@")[0]);
                insert.setString(3, "GOOGLE_LOGIN");   // dummy password
                insert.setString(4, "9999999999");     // dummy contact
                insert.setString(5, email);
                insert.setString(6, "GOOGLE");
                insert.executeUpdate();

                // Send welcome email
                MailUtil.sendWelcomeMail(email, name);
            }

            HttpSession session = request.getSession();
            session.setAttribute("user", email);

            response.getWriter().write("success");
            con.close();

        } catch (Exception e) {
    e.printStackTrace();
    response.setStatus(500);
    response.getWriter().write("error");
}

    }
}