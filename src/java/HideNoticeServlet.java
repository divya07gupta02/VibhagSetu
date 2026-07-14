import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.sql.*;

@WebServlet("/HideNoticeServlet")
public class HideNoticeServlet extends HttpServlet{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        String noticeid = request.getParameter("noticeId");
        
        HttpSession session = request.getSession();
        String facultyid = (String)session.getAttribute("facultyId");
        System.out.println("Facultyid="+facultyid);
        System.out.println("Noticeid="+noticeid);
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection(
                    "jdbc:derby://localhost:1527/vibhag_setu",
                    "vibhagSetu",
                    "vibhagSetu");
            
            PreparedStatement ps = con.prepareStatement("INSERT INTO HIDDEN_NOTICES(FACULTY_ID, NOTICE_ID) VALUES(?,?)");
            ps.setString(1,facultyid);
            ps.setInt(2,Integer.parseInt(noticeid));
            
            ps.executeUpdate();
            
            con.close();
            
            response.getWriter().print("success");
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
    }
}