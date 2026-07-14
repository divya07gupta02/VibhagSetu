import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/UpdateFacultyServlet")
@MultipartConfig(maxFileSize = 16177215) // 16 MB
public class UpdateFacultyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // ===== BASIC DATA =====
            int f_id = Integer.parseInt(request.getParameter("f_id"));

            String firstName = request.getParameter("first_name");
            String middleName = request.getParameter("middle_name");
            String lastName = request.getParameter("last_name");
            String email = request.getParameter("email");
            String contactNo = request.getParameter("contact_no");
//            String userName = request.getParameter("user_name");
//            String password = request.getParameter("password");
            String title = request.getParameter("title");
            String motherName = request.getParameter("mother_name");
            String fatherName = request.getParameter("father_name");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            String address = request.getParameter("address");
            String ZIPcode = request.getParameter("zipcode");
            String dob = request.getParameter("dob");
            String maritalStatus = request.getParameter("marital_status");
            String gender = request.getParameter("gender");
            String category = request.getParameter("category");
            String motherTongue = request.getParameter("mother_tongue");
            String disability = request.getParameter("disability");
            String qualification = request.getParameter("qualification");
            String experience = request.getParameter("experience");
            String salary = request.getParameter("salary");
            String designation = request.getParameter("designation");
            String nationality = request.getParameter("nationality");
            String aadharNo = request.getParameter("aadhar_no");

            // ===== FILE UPLOAD PATH =====
            String uploadPath = getServletContext().getRealPath("") 
                                + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            // ===== PHOTOGRAPH =====
           Part photoPart = request.getPart("photograph");
InputStream photoStream = null;
if (photoPart != null && photoPart.getSize() > 0) {
    photoStream = photoPart.getInputStream();
}

Part timetablePart = request.getPart("timetable");
InputStream timetableStream = null;
if (timetablePart != null && timetablePart.getSize() > 0) {
    timetableStream = timetablePart.getInputStream();
}


            // ===== DATABASE UPDATE =====
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/vibhag_setu",
                "vibhagSetu", "vibhagSetu"
            );
            con.setAutoCommit(true);
// ===== DATABASE UPDATE =====


String sql = "UPDATE FACULTY SET FIRST_NAME=?, MIDDLE_NAME=?, LAST_NAME=?, EMAIL=?, " +
             "CONTACT_NO=?,TITLE=?, MOTHER_NAME=?, " +
             "FATHER_NAME=?, CITY=?, STATE=?, ADDRESS=?, ZIPCODE=?, DOB=?, " +
             "MARITAL_STATUS=?, GENDER=?, CATEGORY=?, MOTHER_TONGUE=?, DISABILITY=?, " +
             "QUALIFICATION=?, EXPERIENCE=?, SALARY=?, DESIGNATION=?, " +
             "NATIONALITY=?, AADHAR_NO=?";

if (photoStream != null) sql += ", PHOTOGRAPH=?";
if (timetableStream != null) sql += ", TIMETABLE=?";
sql += " WHERE F_ID=?";

PreparedStatement ps = con.prepareStatement(sql);

int paramIndex = 1;
ps.setString(paramIndex++, firstName);
ps.setString(paramIndex++, middleName);
ps.setString(paramIndex++, lastName);
ps.setString(paramIndex++, email);
ps.setString(paramIndex++, contactNo);
//ps.setString(paramIndex++, userName);
//ps.setString(paramIndex++, password);
ps.setString(paramIndex++, title);
ps.setString(paramIndex++, motherName);
ps.setString(paramIndex++, fatherName);
ps.setString(paramIndex++, city);
ps.setString(paramIndex++, state);
ps.setString(paramIndex++, address);
ps.setString(paramIndex++, ZIPcode);
ps.setString(paramIndex++, dob);
ps.setString(paramIndex++, maritalStatus);
ps.setString(paramIndex++, gender);
ps.setString(paramIndex++, category);
ps.setString(paramIndex++, motherTongue);
ps.setString(paramIndex++, disability);
ps.setString(paramIndex++, qualification);
ps.setString(paramIndex++, experience);
ps.setString(paramIndex++, salary);
ps.setString(paramIndex++, designation);
ps.setString(paramIndex++, nationality);
ps.setString(paramIndex++, aadharNo);

// Only set BLOBs if user uploaded new file
if (photoStream != null) ps.setBinaryStream(paramIndex++, photoStream, photoPart.getSize());
if (timetableStream != null) ps.setBinaryStream(paramIndex++, timetableStream, timetablePart.getSize());

// F_ID is always last
ps.setInt(paramIndex, f_id);


            ps.executeUpdate();
            // ===== UPDATE WORKS TABLE =====

int departmentId = Integer.parseInt(request.getParameter("department_id"));

String doj = request.getParameter("doj");
String incrementDate = request.getParameter("date_of_increment");
String contractEndDate = request.getParameter("contract_end_date");

PreparedStatement psWorks =
con.prepareStatement(
"UPDATE VIBHAGSETU.WORKS SET D_ID=?, DOJ=?, DATE_OF_INCREMENT=?, CONTRACT_END_DATE=? WHERE F_ID=?"
);

psWorks.setInt(1, departmentId);

java.util.Date dojDate =
new java.text.SimpleDateFormat("d-M-yyyy").parse(doj);

psWorks.setDate(2,new java.sql.Date(dojDate.getTime()));

if(incrementDate!=null && !incrementDate.isEmpty()){

java.util.Date incDate =
new java.text.SimpleDateFormat("d-M-yyyy").parse(incrementDate);

psWorks.setDate(3,new java.sql.Date(incDate.getTime()));

}else{
psWorks.setNull(3,java.sql.Types.DATE);
}

if(contractEndDate!=null && !contractEndDate.isEmpty()){

java.util.Date conDate =
new java.text.SimpleDateFormat("d-M-yyyy").parse(contractEndDate);

psWorks.setDate(4,new java.sql.Date(conDate.getTime()));

}else{
psWorks.setNull(4,java.sql.Types.DATE);
}

psWorks.setInt(5,f_id);

psWorks.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("editFaculty.jsp?success=1&fid=" + f_id);

        } catch (Exception e) {
            e.printStackTrace(response.getWriter());
        }
    }
}