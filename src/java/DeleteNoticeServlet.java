import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.sql.*;

@WebServlet("/DeleteNoticeServlet")
public class DeleteNoticeServlet extends HttpServlet{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        String noticeid = request.getParameter("noticeId");
        

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection(
                    "jdbc:derby://localhost:1527/vibhag_setu",
                    "vibhagSetu",
                    "vibhagSetu");
            
            PreparedStatement ps = con.prepareStatement("DELETE FROM notices WHERE ID=?");
            ps.setInt(1,Integer.parseInt(noticeid));
            int rows = ps.executeUpdate();

            ps.close();
            con.close();

            if(rows > 0){
                 response.getWriter().print("success");
            }else{
                 response.getWriter().print("fail");
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
    }
}