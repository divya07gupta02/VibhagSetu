import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class MailUtil {

    public static void sendWelcomeMail(String to, String name) {

//        final String from = "kanishkamangal2005@gmail.com";
//        final String password = "huqd efzq xori vbcp"; // Gmail App Password
//        //mail hamesha yaha se jati h yaniki meri khud ki mail se as a sender
        
         final String from = "vibhagsetu@gmail.com";
        final String password = "aqir dxkw mafj bfgw";
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.starttls.required", "true");
        
        Session session = Session.getInstance(props,
            new javax.mail.Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(from, password);
                }
            });
        
        System.setProperty("https.protocols", "TLSv1,TLSv1.1,TLSv1.2");
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.setRecipients(
                Message.RecipientType.TO,
                InternetAddress.parse(to)
            );
            message.setSubject("Welcome to Vibhag Setu ");
            message.setText(
                "Hello " + name + ",\n\n" +
                "You have successfully registered via Google Login.\n\n" +
                "Regards,\nVibhag Setu Team"
            );

            Transport.send(message);
            System.out.println("Mail Sent Successfully!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public static void sendWelcomeMail(String to, String name, String userEmail, String genPassword) {
//        final String from = "kanishkamangal2005@gmail.com";
//        final String password = "huqd efzq xori vbcp"; 
         final String from = "vibhagsetu@gmail.com";
        final String password = "aqir dxkw mafj bfgw";

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject("Vibhag Setu - Login Credentials ");
            String body = "Hello " + name + ",\n\n" +
                          "Admin has registered you on the Vibhag Setu portal.\n\n" +
                          "Your Login Credentials are:\n" +
                          "Username: " + userEmail + "\n" +
                          "Password: " + genPassword + "\n\n" +
                          "Please change your password after your first login.\n\n" +
                          "Regards,\nVibhag Setu Team";

            message.setText(body);
            Transport.send(message);
            System.out.println("Admin Registration Mail Sent Successfully!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public static void sendCRWelcomeMail(String to, String name, String userName, String genPassword) {
//         final String from = "kanishkamangal2005@gmail.com";
        final String from = "vibhagsetu@gmail.com";
//         final String password = "huqd efzq xori vbcp";
        final String password = "aqir dxkw mafj bfgw";

          Properties props = new Properties();
           props.put("mail.smtp.auth", "true");
           props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        try {
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(from));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject("Vibhag Setu - CR Login Credentials ");
            // CR ke liye customized body
        String body = "Hello " + name + ",\n\n" +
                      "Congratulations! You have been registered as a Class Representative (CR) on the Vibhag Setu portal.\n\n" +
                      "Your Login Credentials are:\n" +
                      "Username: " + userName + "\n" +
                      "Password: " + genPassword + "\n\n" +
                      "You can now login to your CR Dashboard to view faculty details and timetables.\n\n" +
                      "Regards,\nVibhag Setu Team";

        message.setText(body);
        Transport.send(message);
        System.out.println("CR Registration Mail Sent Successfully!");
        } catch (Exception e) {
        e.printStackTrace();
        }
    }
    
    
}



//ALTER TABLE VIBHAGSETU.ADMIN
//ADD LOGIN_TYPE VARCHAR(20) DEFAULT 'NORMAL';