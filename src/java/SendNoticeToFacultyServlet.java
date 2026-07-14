import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*; 
import java.sql.*;
@WebServlet("/SendNoticeToFacultyServlet")
public class SendNoticeToFacultyServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {

//        String[] facultyIds = request.getParameterValues("facultyIds");
       String facultyId = request.getParameter("facultyId");

//        false added
        HttpSession session = request.getSession();
        
        // ✅ VALIDATION added
        if(facultyId == null || facultyId.trim().equals("")){
          response.sendRedirect("selectFaculty.jsp?error=1");
          return;
        }

        String heading = (String) session.getAttribute("noticeHeading");
        String description = (String) session.getAttribute("noticeDescription");
        String image = (String) session.getAttribute("noticeImage");

//        added
        if(heading == null || description == null){
        response.sendRedirect("postNotice.jsp");
        return;
        }   
//        added
        if(image == null){
            image="";
        }
        Connection con = null;
        PreparedStatement ps = null;

//        int count = 0;  // ✅ FIXED (moved here)

        try{
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            con = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/vibhag_setu",
                "vibhagSetu",
                "vibhagSetu"
            );

//            FLAG CHECK (VERY IMPORTANT)
            PreparedStatement checkPs = con.prepareStatement("SELECT FLAG FROM FACULTY WHERE F_ID=?");

            checkPs.setInt(1, Integer.parseInt(facultyId));
            ResultSet  rs = checkPs.executeQuery();

            if(rs.next()){
                int flag = rs.getInt("FLAG");

                if(flag == 0){
                    rs.close();
                    checkPs.close();
                    con.close();
                    response.sendRedirect("selectFaculty.jsp?error=notexist");
                 return;
                }
                }else{
                  response.sendRedirect("selectFaculty.jsp?error=notexist");
                 return;
                }

                rs.close();
                checkPs.close();
//              ----------------

//          INSERT NOTICES
            ps = con.prepareStatement(
                "insert into notices(heading,description,image,audience) values(?,?,?,?)"
            );

//            if(facultyId != null){
                    ps.setString(1, heading);
                    ps.setString(2, description);
                    ps.setString(3, image);
                    ps.setString(4, facultyId);
                    ps.executeUpdate();

                    
//                    ✅ CLEAN SESSION
                session.removeAttribute("noticeHeading");
                session.removeAttribute("noticeDescription");
                session.removeAttribute("noticeImage");
                session.removeAttribute("deptId");
//                    count++;
//            }

            // ✅ success redirect
//            response.sendRedirect("selectFaculty.jsp?sent=1&count=" + count);
//             ✅ redirect back to admin dashboard
          ps.close();          
        con.close();
        
       response.sendRedirect("selectFaculty.jsp?sent=1");

        } catch(Exception e){
            e.printStackTrace();

            // ❌ FIXED (error redirect)
            response.sendRedirect("selectFaculty.jsp?error=1");

//        } finally{
//            try { if(ps != null) ps.close(); } catch(Exception e){}
//            try { if(con != null) con.close(); } catch(Exception e){}
//        }
        }
}
}