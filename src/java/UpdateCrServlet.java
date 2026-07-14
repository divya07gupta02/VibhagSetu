import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UpdateCrServlet")
public class UpdateCrServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;
        PreparedStatement psUpdateCr = null;
        PreparedStatement psFindClass = null;
        PreparedStatement psClearOld = null;
        PreparedStatement psAssignNew = null;
        ResultSet rsFindClass = null;

        try {
            int crId = Integer.parseInt(request.getParameter("cr_student_id"));

            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String contact = request.getParameter("contact_no");

            String courseParam = request.getParameter("course");

System.out.println("COURSE VALUE = " + courseParam); // DEBUG

if (courseParam == null || courseParam.trim().isEmpty()) {
    response.sendRedirect("editCR.jsp?crid=" + crId + "&classError=1");
    return;
}

int courseId = Integer.parseInt(courseParam);

            String branch = request.getParameter("branch");
            if (branch == null) {
                branch = "";
            }
            branch = branch.trim();

            String year = request.getParameter("year");
            String section = request.getParameter("section");

            if (year == null) year = "";
            if (section == null) section = "";

            year = year.trim();
            section = section.trim();
            if (year.isEmpty()) {
    response.sendRedirect("editCR.jsp?crid=" + crId + "&classError=1");
    return;
}

            Class.forName("org.apache.derby.jdbc.ClientDriver");
            con = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/vibhag_setu",
                "vibhagSetu",
                "vibhagSetu"
            );

            con.setAutoCommit(false);

            psUpdateCr = con.prepareStatement(
                "UPDATE VIBHAGSETU.CR SET NAME=?, EMAIL=?, CONTACT_NO=? WHERE CR_STUDENT_ID=?"
            );
            psUpdateCr.setString(1, name);
            psUpdateCr.setString(2, email);
            psUpdateCr.setString(3, contact);
            psUpdateCr.setInt(4, crId);
            psUpdateCr.executeUpdate();

           psFindClass = con.prepareStatement(
    "SELECT C_ID, BRANCH, C_YEAR, SECTION " +
    "FROM VIBHAGSETU.CLASS " +
    "WHERE C_ID=? AND BRANCH=? AND C_YEAR=? AND SECTION=?"
);
            psFindClass.setInt(1, courseId);
            psFindClass.setString(2, branch);
           psFindClass.setInt(3, Integer.parseInt(year));
            psFindClass.setString(4, section);

            rsFindClass = psFindClass.executeQuery();

            int foundCourseId = 0;
            String foundBranch = "";
            String foundYear = "";
            String foundSection = "";

            if (rsFindClass.next()) {

    // EXISTING CLASS → assign
    foundCourseId = rsFindClass.getInt("C_ID");
    foundBranch = rsFindClass.getString("BRANCH");
    foundYear = rsFindClass.getString("C_YEAR");
    foundSection = rsFindClass.getString("SECTION");

} else {

    // CLASS NOT EXIST → INSERT
    String className = branch + "-" + year + section;

    PreparedStatement psInsertClass = con.prepareStatement(
        "INSERT INTO VIBHAGSETU.CLASS (BRANCH, CLASS_NAME, CR_STUDENT_ID, C_ID, C_YEAR, SECTION) VALUES (?, ?, ?, ?, ?, ?)"
    );

    psInsertClass.setString(1, branch);
    psInsertClass.setString(2, className);
    psInsertClass.setInt(3, crId);
    psInsertClass.setInt(4, courseId);
   psInsertClass.setInt(5, Integer.parseInt(year));
    psInsertClass.setString(6, section);

    psInsertClass.executeUpdate();

    // NEW VALUES SET KARO
    foundCourseId = courseId;
    foundBranch = branch;
    foundYear = year;
    foundSection = section;
}

            psClearOld = con.prepareStatement(
                "UPDATE VIBHAGSETU.CLASS SET CR_STUDENT_ID=NULL WHERE CR_STUDENT_ID=?"
            );
            psClearOld.setInt(1, crId);
            psClearOld.executeUpdate();

           psAssignNew = con.prepareStatement(
    "UPDATE VIBHAGSETU.CLASS " +
    "SET CR_STUDENT_ID=? " +
    "WHERE C_ID=? AND BRANCH=? AND C_YEAR=? AND SECTION=?"
);
            psAssignNew.setInt(1, crId);
            psAssignNew.setInt(2, foundCourseId);
            psAssignNew.setString(3, foundBranch);
           psAssignNew.setInt(4, Integer.parseInt(foundYear));
            psAssignNew.setString(5, foundSection);

            int updatedRows = psAssignNew.executeUpdate();

            if (updatedRows == 0) {
                con.rollback();
                response.sendRedirect("editCR.jsp?crid=" + crId + "&classError=1");
                return;
            }

            con.commit();
            response.sendRedirect("editCR.jsp?crid=" + crId + "&success=1");

        } catch (Exception e) {
            try {
                if (con != null) con.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }

            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        } finally {
            try { if (rsFindClass != null) rsFindClass.close(); } catch (Exception e) {}
            try { if (psUpdateCr != null) psUpdateCr.close(); } catch (Exception e) {}
            try { if (psFindClass != null) psFindClass.close(); } catch (Exception e) {}
            try { if (psClearOld != null) psClearOld.close(); } catch (Exception e) {}
            try { if (psAssignNew != null) psAssignNew.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}