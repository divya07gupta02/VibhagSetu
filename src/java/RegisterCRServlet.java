import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.PasswordUtil;

@WebServlet("/RegisterCRServlet")
public class RegisterCRServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private String enc(String value) throws IOException {
        return URLEncoder.encode(value == null ? "" : value, "UTF-8");
    }

    private String buildRedirectURL(String name, String contact, String email,
                                    String course, String branch, String year, String section,
                                    String emailError, String contactError,
                                    String classError, String serverError) throws IOException {

        return "adminAddCR.jsp?"
                + "emailError=" + emailError
                + "&contactError=" + contactError
                + "&classError=" + classError
                + "&serverError=" + serverError
                + "&name=" + enc(name)
                + "&contact=" + enc(contact)
                + "&email=" + enc(email)
                + "&course=" + enc(course)
                + "&branch=" + enc(branch)
                + "&year=" + enc(year)
                + "&section=" + enc(section);
    }

    private boolean isBTechCourse(String courseName) {
        if (courseName == null) return false;
        String c = courseName.trim().toLowerCase();
        return c.contains("btech") || c.contains("b.tech");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String crFullName = request.getParameter("name");
        String crEmail = request.getParameter("email");
        String crContact = request.getParameter("contact_no");
        String courseName = request.getParameter("course");
        String branch = request.getParameter("branch");
        String year = request.getParameter("year");
        String section = request.getParameter("section");

        if (crFullName != null) crFullName = crFullName.trim();
        if (crEmail != null) crEmail = crEmail.trim();
        if (crContact != null) crContact = crContact.trim();
        if (courseName != null) courseName = courseName.trim();
        if (branch != null) branch = branch.trim();
        if (year != null) year = year.trim();
        if (section != null) section = section.trim();

        boolean isBTech = isBTechCourse(courseName);

        if (branch == null || branch.isEmpty()) {
    response.sendRedirect(buildRedirectURL(
        crFullName, crContact, crEmail, courseName, branch, year, section,
        "0", "0", "1", "0"
    ));
    return;
}

        if (branch == null || branch.isEmpty()) {
            branch = isBTech ? "" : "GENERAL";
        }

        if (crFullName == null || crFullName.isEmpty()
                || crEmail == null || crEmail.isEmpty()
                || crContact == null || crContact.isEmpty()
                || courseName == null || courseName.isEmpty()
                || year == null || year.isEmpty()
                || section == null || section.isEmpty()
                || (isBTech && (branch == null || branch.isEmpty()))) {

            response.sendRedirect(buildRedirectURL(
                    crFullName, crContact, crEmail, courseName, branch, year, section,
                    "0", "0", "1", "0"
            ));
            return;
        }

        String tempUsername = "TEMP_USER";
        String generatedPassword = "VSCR" + (100000 + new Random().nextInt(900000));
        String hashedPassword = PasswordUtil.hashPassword(generatedPassword);

        Connection con = null;
        PreparedStatement psEmailCheck = null;
        PreparedStatement psContactCheck = null;
        PreparedStatement psInsertCR = null;
        PreparedStatement psUpdateUser = null;
        PreparedStatement psCourse = null;
        PreparedStatement psCheckClass = null;
        PreparedStatement psUpdateClass = null;
        PreparedStatement psInsertClass = null;

        ResultSet rsEmail = null;
        ResultSet rsContact = null;
        ResultSet rsCR = null;
        ResultSet rsCourse = null;
        ResultSet rsClass = null;

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");

            con = DriverManager.getConnection(
                    "jdbc:derby://localhost:1527/vibhag_setu",
                    "vibhagSetu",
                    "vibhagSetu"
            );

            con.setAutoCommit(false);

            boolean emailExists = false;
            boolean contactExists = false;

            psEmailCheck = con.prepareStatement(
                    "SELECT COUNT(*) FROM VIBHAGSETU.CR WHERE EMAIL = ?"
            );
            psEmailCheck.setString(1, crEmail);
            rsEmail = psEmailCheck.executeQuery();
            if (rsEmail.next() && rsEmail.getInt(1) > 0) {
                emailExists = true;
            }

            psContactCheck = con.prepareStatement(
                    "SELECT COUNT(*) FROM VIBHAGSETU.CR WHERE CONTACT_NO = ?"
            );
            psContactCheck.setLong(1, Long.parseLong(crContact));
            rsContact = psContactCheck.executeQuery();
            if (rsContact.next() && rsContact.getInt(1) > 0) {
                contactExists = true;
            }

            if (emailExists || contactExists) {
                con.rollback();
                response.sendRedirect(buildRedirectURL(
                        crFullName, crContact, crEmail, courseName, branch, year, section,
                        emailExists ? "1" : "0",
                        contactExists ? "1" : "0",
                        "0",
                        "0"
                ));
                return;
            }

            String insertCR = "INSERT INTO VIBHAGSETU.CR (USER_NAME, NAME, PASSWORD, EMAIL, CONTACT_NO) VALUES (?, ?, ?, ?, ?)";
            psInsertCR = con.prepareStatement(insertCR, Statement.RETURN_GENERATED_KEYS);

            psInsertCR.setString(1, tempUsername);
            psInsertCR.setString(2, crFullName);
            psInsertCR.setString(3, hashedPassword);
            psInsertCR.setString(4, crEmail);
            psInsertCR.setLong(5, Long.parseLong(crContact));

            psInsertCR.executeUpdate();

            rsCR = psInsertCR.getGeneratedKeys();
            int crStudentId = 0;

            if (rsCR.next()) {
                crStudentId = rsCR.getInt(1);
            }

            if (crStudentId == 0) {
                throw new Exception("CR_STUDENT_ID not generated.");
            }

            String finalUsername = crFullName.replaceAll("\\s+", "") + "_" + crStudentId;

            psUpdateUser = con.prepareStatement(
                    "UPDATE VIBHAGSETU.CR SET USER_NAME = ? WHERE CR_STUDENT_ID = ?"
            );
            psUpdateUser.setString(1, finalUsername);
            psUpdateUser.setInt(2, crStudentId);
            psUpdateUser.executeUpdate();

            psCourse = con.prepareStatement(
                    "SELECT C_ID FROM VIBHAGSETU.COURSE WHERE NAME = ?"
            );
            psCourse.setString(1, courseName);
            rsCourse = psCourse.executeQuery();

            int cId = 0;
            if (rsCourse.next()) {
                cId = rsCourse.getInt("C_ID");
            } else {
                con.rollback();
                response.sendRedirect(buildRedirectURL(
                        crFullName, crContact, crEmail, courseName, branch, year, section,
                        "0", "0", "1", "0"
                ));
                return;
            }

            psCheckClass = con.prepareStatement(
        "SELECT CR_STUDENT_ID FROM VIBHAGSETU.CLASS WHERE C_ID = ? AND BRANCH = ? AND C_YEAR = ? AND SECTION = ?"
);
            psCheckClass.setInt(1, cId);
            psCheckClass.setString(2, branch);
            psCheckClass.setString(3, year);
            psCheckClass.setString(4, section);

            rsClass = psCheckClass.executeQuery();

            if (rsClass.next()) {
                psUpdateClass = con.prepareStatement(
                        "UPDATE VIBHAGSETU.CLASS SET CR_STUDENT_ID = ? WHERE C_ID = ? AND BRANCH = ? AND C_YEAR = ? AND SECTION = ?"
                );
                psUpdateClass.setInt(1, crStudentId);
                psUpdateClass.setInt(2, cId);
                psUpdateClass.setString(3, branch);
                psUpdateClass.setString(4, year);
                psUpdateClass.setString(5, section);
                psUpdateClass.executeUpdate();
            } else {
                String className = branch + "-" + year + section;

                psInsertClass = con.prepareStatement(
                        "INSERT INTO VIBHAGSETU.CLASS (BRANCH, CLASS_NAME, CR_STUDENT_ID, C_ID, C_YEAR, SECTION) VALUES (?, ?, ?, ?, ?, ?)"
                );
                psInsertClass.setString(1, branch);
                psInsertClass.setString(2, className);
                psInsertClass.setInt(3, crStudentId);
                psInsertClass.setInt(4, cId);
                psInsertClass.setString(5, year);
                psInsertClass.setString(6, section);

                psInsertClass.executeUpdate();
            }

            con.commit();
            con.setAutoCommit(true);

            try {
                MailUtil.sendCRWelcomeMail(crEmail, crFullName, finalUsername, generatedPassword);
            } catch (Exception mailEx) {
                mailEx.printStackTrace();
            }

            response.sendRedirect("adminAddCR.jsp?success=1&user=" + enc(finalUsername));

        } catch (Exception e) {
    e.printStackTrace();

    try {
        if (con != null) {
            con.rollback();
        }
    } catch (SQLException ex) {
        ex.printStackTrace();
    }

    response.setContentType("text/html;charset=UTF-8");
    response.getWriter().println("<h2>Servlet Error</h2>");
    response.getWriter().println("<pre>");
    e.printStackTrace(response.getWriter());
    response.getWriter().println("</pre>");
} finally {
            try { if (rsEmail != null) rsEmail.close(); } catch (Exception e) {}
            try { if (rsContact != null) rsContact.close(); } catch (Exception e) {}
            try { if (rsCR != null) rsCR.close(); } catch (Exception e) {}
            try { if (rsCourse != null) rsCourse.close(); } catch (Exception e) {}
            try { if (rsClass != null) rsClass.close(); } catch (Exception e) {}

            try { if (psEmailCheck != null) psEmailCheck.close(); } catch (Exception e) {}
            try { if (psContactCheck != null) psContactCheck.close(); } catch (Exception e) {}
            try { if (psInsertCR != null) psInsertCR.close(); } catch (Exception e) {}
            try { if (psUpdateUser != null) psUpdateUser.close(); } catch (Exception e) {}
            try { if (psCourse != null) psCourse.close(); } catch (Exception e) {}
            try { if (psCheckClass != null) psCheckClass.close(); } catch (Exception e) {}
            try { if (psUpdateClass != null) psUpdateClass.close(); } catch (Exception e) {}
            try { if (psInsertClass != null) psInsertClass.close(); } catch (Exception e) {}

            try {
                if (con != null) {
                    con.close();
                }
            } catch (Exception e) {}
        }
    }
}