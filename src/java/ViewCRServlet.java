import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ViewCRServlet")
public class ViewCRServlet extends HttpServlet {

protected void doPost(HttpServletRequest request,
HttpServletResponse response)
throws ServletException, IOException {

String course=request.getParameter("course");
String branch=request.getParameter("branch");
String year=request.getParameter("year");
String section=request.getParameter("section");

try{

Class.forName("org.apache.derby.jdbc.ClientDriver");

Connection con=DriverManager.getConnection(
"jdbc:derby://localhost:1527/vibhag_setu",
"vibhagSetu",
"vibhagSetu"
);

PreparedStatement ps=con.prepareStatement(

"SELECT CR.NAME,CR.EMAIL,CR.CONTACT_NO " +
"FROM VIBHAGSETU.CR CR " +
"JOIN VIBHAGSETU.CLASS C ON CR.CR_STUDENT_ID=C.CR_STUDENT_ID " +
"JOIN VIBHAGSETU.COURSE CO ON C.C_ID=CO.C_ID " +
"WHERE CO.NAME=? AND C.BRANCH=? AND C.C_YEAR=? AND C.SECTION=?"

);

ps.setString(1,course);
ps.setString(2,branch);
ps.setString(3,year);
ps.setString(4,section);

ResultSet rs=ps.executeQuery();

if(rs.next()){

request.setAttribute("name", rs.getString("NAME"));
request.setAttribute("email", rs.getString("EMAIL"));
request.setAttribute("contact", rs.getString("CONTACT_NO"));

}else{
request.setAttribute("error","No CR Found");
}

rs.close();
ps.close();
con.close();

request.getRequestDispatcher("viewCRResult.jsp").forward(request, response);

}catch(Exception e){
request.setAttribute("error", e.getMessage());
request.getRequestDispatcher("viewCRResult.jsp").forward(request, response);
}
}
}