import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/SearchDepartmentServlet")
public class SearchDepartmentServlet extends HttpServlet {

protected void doPost(HttpServletRequest request,
HttpServletResponse response)
throws ServletException, IOException {

String deptName = request.getParameter("deptName");

if(deptName == null || deptName.trim().isEmpty()){
request.setAttribute("msg","Please enter department name!");
request.getRequestDispatcher("ManageTT.jsp")
.forward(request,response);
return;
}

try{

Class.forName("org.apache.derby.jdbc.ClientDriver");

Connection con = DriverManager.getConnection(
"jdbc:derby://localhost:1527/vibhag_setu",
"vibhagSetu",
"vibhagSetu");

PreparedStatement ps = con.prepareStatement(
"SELECT D_ID, NAME FROM VIBHAGSETU.DEPARTMENT " +
"WHERE UPPER(NAME) LIKE UPPER(?)");

ps.setString(1, "%" + deptName.trim() + "%");

ResultSet rs = ps.executeQuery();

if(rs.next()){

int did = rs.getInt("D_ID");

response.sendRedirect("ShowFaculty.jsp?did=" + did);

}
else{

request.setAttribute("msg","Department not found!");
request.getRequestDispatcher("ManageTT.jsp")
.forward(request,response);

}

con.close();

}catch(Exception e){

e.printStackTrace();

request.setAttribute("msg","Database Error!");
request.getRequestDispatcher("ManageTT.jsp")
.forward(request,response);

}

}
}