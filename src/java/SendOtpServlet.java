
import java.io.IOException;
import java.util.Properties;
import java.util.Random;
import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/SendOtpServlet")
public class SendOtpServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");

        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            response.getWriter().write("{\"status\":\"EMAIL_REQUIRED\"}");
            return;
        }

        // Generate OTP
        String otp = String.valueOf(100000 + new Random().nextInt(900000));

        // Store in session
        HttpSession session = request.getSession();
      
          String role = request.getParameter("role");
          if (role == null || role.trim().isEmpty()) {
    role = "admin"; // default safety
}

session.setAttribute("otp", otp);
session.setAttribute("otpEmail", email);
session.setAttribute("otpRole", role);   // ⭐ VERY IMPORTANT
session.setAttribute("otpTime", System.currentTimeMillis());

        
        
      


        // Sender credentials
        final String senderEmail = "vibhagsetu@gmail.com";
        final String senderPassword = "aqir dxkw mafj bfgw"; // app password

        // Mail properties
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session mailSession = Session.getInstance(props,
            new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(senderEmail, senderPassword);
                }
            });

        try {
            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(senderEmail));
            message.setRecipients(
                Message.RecipientType.TO,
                InternetAddress.parse(email)
            );
            message.setSubject("Vibhag Setu - OTP Verification");
            message.setText(
                "Your OTP is: " + otp +
                "\nThis OTP is valid for 2 minutes."
            );

            Transport.send(message);

            // SUCCESS RESPONSE
            response.getWriter().write("{\"status\":\"OTP_SENT\"}");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"status\":\"EMAIL_ERROR\"}");
        }
    }
}
