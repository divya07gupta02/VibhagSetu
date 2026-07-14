import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;

@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String type = request.getParameter("type");
        String keyword = request.getParameter("keyword");

         String field = request.getParameter("field");
        String operator = request.getParameter("operator");
        String value = request.getParameter("value");

        if(type == null){
            out.println("<h3>Type missing!</h3>");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try{
            Class.forName("org.apache.derby.jdbc.ClientDriver");

            con = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/vibhag_setu",
                "vibhagSetu",
                "vibhagSetu"
            );

            String sql = "";

            // ================= FACULTY =================
            if(type.equalsIgnoreCase("faculty")){
 if(field != null && value != null){

                    // NUMERIC FIELD (salary)
                    if(field.equals("SALARY")){

                        sql = "SELECT F_ID, FIRST_NAME, LAST_NAME, EMAIL, SALARY " +
                              "FROM FACULTY WHERE SALARY " + operator + " ?";

                        ps = con.prepareStatement(sql);
                        ps.setInt(1, Integer.parseInt(value));
                    }

                    // STRING FIELD
                    else{

                        sql = "SELECT F_ID, FIRST_NAME, LAST_NAME, EMAIL, " + field +
                              " FROM FACULTY WHERE LOWER(" + field + ") LIKE ?";

                        ps = con.prepareStatement(sql);
                        ps.setString(1, "%" + value.toLowerCase() + "%");
                    }
                }
    else{

                    sql = "SELECT F_ID, FIRST_NAME, LAST_NAME, EMAIL, DESIGNATION " +
                          "FROM FACULTY WHERE LOWER(FIRST_NAME) LIKE ? OR LOWER(LAST_NAME) LIKE ?";

                    ps = con.prepareStatement(sql);
                    ps.setString(1, "%" + keyword.toLowerCase() + "%");
                    ps.setString(2, "%" + keyword.toLowerCase() + "%");
                }
            }

            // ================= CR =================
            else if(type.equalsIgnoreCase("cr")){

                sql = "SELECT CR_STUDENT_ID, NAME, EMAIL, BRANCH, YEAR " +
                      "FROM CR WHERE LOWER(NAME) LIKE ?";

                ps = con.prepareStatement(sql);
                ps.setString(1, "%" + keyword.toLowerCase() + "%");
            }

            else{
                out.println("<h3>Invalid type</h3>");
                return;
            }

            rs = ps.executeQuery();

            // ================= OUTPUT =================
            out.println("<h2>Search Results</h2>");

            boolean found = false;

            while(rs.next()){
                found = true;

                if(type.equals("faculty")){
                    out.println("<div style='border:1px solid #ccc;padding:10px;margin:10px'>");
                    out.println("<b>ID:</b> " + rs.getInt("F_ID") + "<br>");
                    out.println("<b>Name:</b> " + rs.getString("FIRST_NAME") + " " + rs.getString("LAST_NAME") + "<br>");
                    out.println("<b>Email:</b> " + rs.getString("EMAIL") + "<br>");

                    // salary ya designation jo available ho
                    try{
                        out.println("<b>Extra:</b> " + rs.getString("SALARY") + "<br>");
                    }catch(Exception e){
                        try{
                            out.println("<b>Extra:</b> " + rs.getString("DESIGNATION") + "<br>");
                        }catch(Exception ex){}
                    }

                    out.println("</div>");
                }

                else if(type.equals("cr")){
                    out.println("<div style='border:1px solid #ccc;padding:10px;margin:10px'>");
                    out.println("<b>ID:</b> " + rs.getInt("CR_STUDENT_ID") + "<br>");
                    out.println("<b>Name:</b> " + rs.getString("NAME") + "<br>");
                    out.println("<b>Email:</b> " + rs.getString("EMAIL") + "<br>");
                    out.println("<b>Branch:</b> " + rs.getString("BRANCH") + "<br>");
                    out.println("<b>Year:</b> " + rs.getString("YEAR"));
                    out.println("</div>");
                }
            }

            if(!found){
                out.println("<h3>No records found</h3>");
            }

        }catch(Exception e){
            e.printStackTrace(out);
        }
        finally{
            try{ if(rs != null) rs.close(); } catch(Exception e){}
            try{ if(ps != null) ps.close(); } catch(Exception e){}
            try{ if(con != null) con.close(); } catch(Exception e){}
        }
    }
}