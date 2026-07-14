import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("otpEmail") == null) {
            res.sendRedirect("adminLogin.html");
            return;
        }

        String email = (String) session.getAttribute("otpEmail");
        String role = (String) session.getAttribute("otpRole");
        if (role == null) {
    role = "admin"; // fallback safety
}

String table = "ADMIN";
if ("faculty".equals(role)) {
    table = "FACULTY";
} else if ("cr".equals(role)) {
    table = "CR";
}

        String pass = req.getParameter("password");

        try {
            // Load Derby driver
            Class.forName("org.apache.derby.jdbc.ClientDriver");

            // Create DB connection
            Connection con = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/vibhag_setu",
                "vibhagSetu",
                "vibhagSetu"
            );

            PreparedStatement ps =
                con.prepareStatement(
                   "UPDATE " + table + " SET PASSWORD=? WHERE EMAIL=?"
                );

            ps.setString(1, pass);
            ps.setString(2, email);

            ps.executeUpdate();
            con.close();

            // clear session after reset
            session.invalidate();

           if ("faculty".equals(role)) {
    res.sendRedirect("facLogin.html?reset=success");
} 
else if ("cr".equals(role)) {
    res.sendRedirect("CrLogin.html?reset=success");
} 
else {
    res.sendRedirect("adminLogin.html?reset=success");
}


        } catch (Exception e) {
            e.printStackTrace();
            if ("faculty".equals(role)) {
        res.sendRedirect("facLogin.html?reset=error");
    } 
    else if ("cr".equals(role)) {
        res.sendRedirect("CrLogin.html?reset=error");
    } 
    else {
        res.sendRedirect("adminLogin.html?reset=error");
    }
}
    }
}
