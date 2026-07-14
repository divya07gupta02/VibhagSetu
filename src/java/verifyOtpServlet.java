import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/verifyOtpServlet")
public class verifyOtpServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        HttpSession session = req.getSession(false);
        String userOtp = req.getParameter("otp");

        if (session == null) {
            res.getWriter().write("SESSION_EXPIRED");
            return;
        }

        String realOtp = (String) session.getAttribute("otp");
       Long timeObj = (Long) session.getAttribute("otpTime");

if (timeObj == null) {
    res.getWriter().write("OTP_EXPIRED");
    return;
}

long time = timeObj;


        if (System.currentTimeMillis() - time > 120000) {
            res.getWriter().write("OTP_EXPIRED");
            return;
        }

        if (realOtp.equals(userOtp)) {
            res.getWriter().write("SUCCESS");
        } else {
            res.getWriter().write("WRONG_OTP");
        }
    }
}



        
