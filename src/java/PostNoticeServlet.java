import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.sql.*;

@MultipartConfig(
    fileSizeThreshold=1024*1024,
    maxFileSize=1024*1024*5,
    maxRequestSize=1024*1024*10
)
@WebServlet("/PostNoticeServlet")

public class PostNoticeServlet extends HttpServlet {

protected void doPost(HttpServletRequest request, HttpServletResponse response)
throws ServletException, IOException {
    
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

String heading = request.getParameter("heading");
String description = request.getParameter("description");
String audience = request.getParameter("postType");
String deptId = request.getParameter("deptId");

// ✅ VALIDATION   added
if(heading == null || heading.trim().equals("") ||
   description == null || description.trim().equals("")){
    response.sendRedirect("postNotice.jsp?error=1");
    return;
}

/* IMAGE PART */
String fileName = null;

try {

Part filePart = request.getPart("photo");
//if(filePart != null && filePart.getSize() > 0 && filePart.getSubmittedFileName()!=null){
if(filePart != null && filePart.getSize() > 0){
      
    String originalFileName = filePart.getSubmittedFileName();
   System.out.println("Original File: " + originalFileName); // DEBUG

    if(originalFileName != null && !originalFileName.trim().isEmpty()){
            // ✅ IMPORTANT FIX
    originalFileName = new File(originalFileName).getName();  
fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
//String uploadPath = getServletContext().getRealPath("") + File.separator + "images1";
//added
String uploadPath = getServletContext().getRealPath("/images1");
File uploadDir = new File(uploadPath);

if(!uploadDir.exists()){
    uploadDir.mkdirs();
}

filePart.write(uploadPath + File.separator + fileName);
System.out.println("Image saved at: " + uploadPath + File.separator + fileName);
}
}
}catch(Exception e){
e.printStackTrace();
}

/* IF POST TO FACULTY */

if("faculty".equals(audience)){

HttpSession session = request.getSession();

session.setAttribute("noticeHeading", heading);
session.setAttribute("noticeDescription", description);
session.setAttribute("noticeImage", fileName);
session.setAttribute("deptId", deptId);

//response.sendRedirect("postNotice.jsp?facultySuccess=1");
response.sendRedirect("selectFaculty.jsp?created=1");
return;
}


///* SAVE NORMAL NOTICE */ EVERYONE FLOW

try{

Class.forName("org.apache.derby.jdbc.ClientDriver");
Connection con = DriverManager.getConnection(
"jdbc:derby://localhost:1527/vibhag_setu","vibhagSetu","vibhagSetu");

PreparedStatement ps = con.prepareStatement(
"insert into notices(heading,description,image,audience) values(?,?,?,?)");

ps.setString(1, heading);
ps.setString(2, description);
//ps.setString(3, fileName);
if(fileName != null){
    ps.setString(3,fileName);
}else{
    ps.setNull(3,java.sql.Types.VARCHAR);
}
ps.setString(4, audience);

ps.executeUpdate();
ps.close();
con.close();

response.sendRedirect("postNotice.jsp?success=1");

}catch(Exception e){
System.out.println("Database error: " + e.getMessage());
response.sendRedirect("postNotice.jsp?");
}

}
}