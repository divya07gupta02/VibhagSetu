import java.io.*;
import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.Connection;
import java.sql.DriverManager;
import javax.servlet.annotation.MultipartConfig; // Zaroori
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.http.Part;
import util.PasswordUtil;
import java.net.URLEncoder;
@WebServlet("/RegisterFacultyServlet")
@MultipartConfig(maxFileSize = 16177215) // Files handle karne ke liye (16MB)

public class RegisterFacultyServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Password generate
        String generatedPassword = "VS" + (10000 + new Random().nextInt(90000));

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection(
                    "jdbc:derby://localhost:1527/vibhag_setu",
                    "vibhagSetu",
                    "vibhagSetu"
            );
            con.setAutoCommit(false);
//            // ===== FRONTEND VALUES =====
//            int fId = Integer.parseInt(request.getParameter("f_id"));
//            String fName = request.getParameter("first_name");
//            String finalUname = fName + "_" + fId;

            // ===== DUPLICATE CHECK =====
           PreparedStatement psCheck = con.prepareStatement(
    "SELECT COUNT(*) FROM VIBHAGSETU.FACULTY WHERE (CONTACT_NO=? OR EMAIL=?) AND FLAG=1"
);
//            psCheck.setInt(1, fId);
            psCheck.setLong(1, Long.parseLong(request.getParameter("contact_no")));
            psCheck.setString(2, request.getParameter("email"));

            ResultSet rsCheck = psCheck.executeQuery();
            boolean emailExists = false;
boolean contactExists = false;

if (rsCheck.next() && rsCheck.getInt(1) > 0) {

    // Check individually
    PreparedStatement psEmail = con.prepareStatement(
        "SELECT COUNT(*) FROM VIBHAGSETU.FACULTY WHERE EMAIL=? AND FLAG=1"
    );
    psEmail.setString(1, request.getParameter("email"));
    ResultSet rsEmail = psEmail.executeQuery();
    rsEmail.next();

    if(rsEmail.getInt(1) > 0){
        emailExists = true;
    }

    PreparedStatement psContact = con.prepareStatement(
        "SELECT COUNT(*) FROM VIBHAGSETU.FACULTY WHERE CONTACT_NO=? AND FLAG=1"
);
psContact.setLong(1, Long.parseLong(request.getParameter("contact_no")));
ResultSet rsContact = psContact.executeQuery();
rsContact.next();

if(rsContact.getInt(1) > 0){
    contactExists = true;
}

    String redirectURL = "registerFaculty.jsp?"
+ "emailError=" + (emailExists ? "1" : "0")
+ "&contactError=" + (contactExists ? "1" : "0")

+ "&first_name=" + URLEncoder.encode(request.getParameter("first_name"), "UTF-8")
+ "&middle_name=" + URLEncoder.encode(request.getParameter("middle_name"), "UTF-8")
+ "&last_name=" + URLEncoder.encode(request.getParameter("last_name"), "UTF-8")

+ "&email=" + URLEncoder.encode(request.getParameter("email"), "UTF-8")
+ "&contact=" + request.getParameter("contact_no")
            + "&aadhar_no=" + request.getParameter("aadhar_no")
+ "&father_name=" + URLEncoder.encode(request.getParameter("father_name"), "UTF-8")
+ "&mother_name=" + URLEncoder.encode(request.getParameter("mother_name"), "UTF-8")
+ "&department_id=" + request.getParameter("department_id")
+ "&address=" + URLEncoder.encode(request.getParameter("address"), "UTF-8")
+ "&city=" + URLEncoder.encode(request.getParameter("city"), "UTF-8")
+ "&state=" + URLEncoder.encode(request.getParameter("state"), "UTF-8")
+ "&zipcode=" + URLEncoder.encode(request.getParameter("zipcode"), "UTF-8")
+ "&mother_tongue=" + URLEncoder.encode(request.getParameter("mother_tongue"), "UTF-8")
+ "&designation=" + URLEncoder.encode(request.getParameter("designation"), "UTF-8")
+ "&qualification=" + URLEncoder.encode(request.getParameter("qualification"), "UTF-8")
+ "&experience=" + request.getParameter("experience")
+ "&salary=" + request.getParameter("salary")

+ "&dob=" + request.getParameter("dob")
+ "&doj=" + request.getParameter("doj")
+ "&increment=" + request.getParameter("date_of_increment")
+ "&contract=" + request.getParameter("contract_end_date");

response.sendRedirect(redirectURL);
return;
}

            // ===== INSERT QUERY =====
            String sql =
                "INSERT INTO VIBHAGSETU.FACULTY " +
                "(AADHAR_NO, ADDRESS, CATEGORY, CITY, CONTACT_NO, DESIGNATION, DISABILITY, DOB, EMAIL, EXPERIENCE, " +
                "FATHER_NAME, FIRST_NAME, GENDER, LAST_NAME, MARITAL_STATUS, MIDDLE_NAME, MOTHER_NAME, MOTHER_TONGUE, " +
                "NATIONALITY, PASSWORD, QUALIFICATION, SALARY, STATE, TITLE, ZIPCODE, PHOTOGRAPH, TIMETABLE,USER_NAME, FIRST_LOGIN) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)";

//            PreparedStatement ps = con.prepareStatement(sql);
             PreparedStatement ps = con.prepareStatement(
                sql, java.sql.Statement.RETURN_GENERATED_KEYS
            );

//            ps.setInt(1, fId);
            ps.setString(1, request.getParameter("aadhar_no"));
            ps.setString(2, request.getParameter("address"));
            ps.setString(3, request.getParameter("category"));
            ps.setString(4, request.getParameter("city"));
            ps.setLong(5, Long.parseLong(request.getParameter("contact_no")));
            ps.setString(6, request.getParameter("designation"));
            ps.setString(7, request.getParameter("disability"));
            String dobStr = request.getParameter("dob");
java.util.Date dob = new java.text.SimpleDateFormat("d-M-yyyy").parse(dobStr);
ps.setDate(8, new java.sql.Date(dob.getTime()));
            ps.setString(9, request.getParameter("email"));
            ps.setInt(10, Integer.parseInt(request.getParameter("experience")));
            ps.setString(11, request.getParameter("father_name"));
            ps.setString(12, request.getParameter("first_name"));
            ps.setString(13, request.getParameter("gender"));
            ps.setString(14, request.getParameter("last_name"));
            ps.setString(15, request.getParameter("marital_status"));
            ps.setString(16, request.getParameter("middle_name"));
            ps.setString(17, request.getParameter("mother_name"));
            ps.setString(18,  request.getParameter("mother_tongue"));
            ps.setString(19, request.getParameter("nationality"));
      String hashedPassword = PasswordUtil.hashPassword(generatedPassword);
ps.setString(20, hashedPassword);
 //  auto generated password

            ps.setString(21, request.getParameter("qualification"));
            ps.setDouble(22, Double.parseDouble(request.getParameter("salary")));
            ps.setString(23, request.getParameter("state"));
            ps.setString(24, request.getParameter("title"));
            ps.setString(25, request.getParameter("zipcode"));
          
                Part photoPart = request.getPart("photograph");
                if (photoPart != null && photoPart.getSize() > 0) {
                    ps.setBinaryStream(26, photoPart.getInputStream(), (int) photoPart.getSize());
                } else {
                    ps.setNull(26, java.sql.Types.BLOB);
                }

                ps.setNull(27, java.sql.Types.BLOB);
             ps.setString(28, "TEMP_USER"); //  IMPORTANT
             ps.setInt(29, 1);

            // ===== EXECUTE =====
            ps.executeUpdate();
            
            /* ---------- GET AUTO GENERATED F_ID ---------- */
            ResultSet rs = ps.getGeneratedKeys();
            int generatedFid = 0;
            if (rs.next()) {
                generatedFid = rs.getInt(1);
            }

            /* ---------- USERNAME = name_fid ---------- */
            String firstName = request.getParameter("first_name");
            String finalUsername = firstName + "_" + generatedFid;

            PreparedStatement psUser = con.prepareStatement(
                "UPDATE VIBHAGSETU.FACULTY SET USER_NAME=? WHERE F_ID=?"
            );
            psUser.setString(1, finalUsername);
            psUser.setInt(2, generatedFid);
            psUser.executeUpdate();
      
            
            
            
            
            
            /* ---------- INSERT INTO IDALLOCATOR TABLE ---------- */
String deptName = "";

PreparedStatement psDept = con.prepareStatement(
    "SELECT NAME FROM VIBHAGSETU.DEPARTMENT WHERE D_ID=?"
);

psDept.setInt(1, Integer.parseInt(request.getParameter("department_id")));

ResultSet rsDept = psDept.executeQuery();

if(rsDept.next()){
    deptName = rsDept.getString("NAME");
}

rsDept.close();
psDept.close();

PreparedStatement psAllocator = con.prepareStatement(
    "INSERT INTO VIBHAGSETU.IDALLOCATOR (SMARTCARD_ID, DOJ, DESGN, DEPT) VALUES (?, ?, ?, ?)"
);

psAllocator.setInt(1, generatedFid); // SMART_CARD_ID = Faculty ID
String dojStr = request.getParameter("doj");
java.util.Date doDate = new java.text.SimpleDateFormat("d-M-yyyy").parse(dojStr);
psAllocator.setDate(2, new java.sql.Date(doDate.getTime()));
psAllocator.setString(3, request.getParameter("designation"));
psAllocator.setString(4, deptName); 



psAllocator.executeUpdate();
  psAllocator.close();           
            
     
            
            
            
            
            
            
            
 /* ---------- INSERT INTO WORKS TABLE ---------- */

// Form se values lo
int departmentId = Integer.parseInt(request.getParameter("department_id"));
String doj = request.getParameter("doj");
String incrementDate = request.getParameter("date_of_increment");
String contractEndDate = request.getParameter("contract_end_date");

PreparedStatement psWorks = con.prepareStatement(
    "INSERT INTO VIBHAGSETU.WORKS (D_ID, F_ID, DOJ, DATE_OF_INCREMENT, CONTRACT_END_DATE) VALUES (?, ?, ?, ?, ?)"
);

psWorks.setInt(1, departmentId);
psWorks.setInt(2, generatedFid);
java.util.Date dojDate = new java.text.SimpleDateFormat("d-M-yyyy").parse(doj);
psWorks.setDate(3, new java.sql.Date(dojDate.getTime()));

if(incrementDate != null && !incrementDate.isEmpty()){
    java.util.Date incDate = new java.text.SimpleDateFormat("d-M-yyyy").parse(incrementDate);
psWorks.setDate(4, new java.sql.Date(incDate.getTime()));}
else
    psWorks.setNull(4, java.sql.Types.DATE);

if(contractEndDate != null && !contractEndDate.isEmpty()){
    java.util.Date conDate = new java.text.SimpleDateFormat("d-M-yyyy").parse(contractEndDate);
psWorks.setDate(5, new java.sql.Date(conDate.getTime()));}
else
    psWorks.setNull(5, java.sql.Types.DATE);

psWorks.executeUpdate();
con.commit();            

            // ===== SEND EMAIL =====
            MailUtil.sendWelcomeMail(
                    request.getParameter("email"),
                    firstName,
                    finalUsername,
                    generatedPassword
            );

            response.sendRedirect(
"registerFaculty.jsp?success=1&user=" 
+ URLEncoder.encode(finalUsername, "UTF-8")
);

            con.close();

        }catch (Exception e) {
    e.printStackTrace();
    out.println("<pre>");
    e.printStackTrace(out);
    out.println("</pre>");
}
    }
}