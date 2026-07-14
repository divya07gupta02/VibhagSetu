import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;
import java.util.*;

@WebServlet("/ViewUpdateRequestsServlet")
public class ViewUpdateRequestsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection(
                    "jdbc:derby://localhost:1527/vibhag_setu",
                    "vibhagSetu", "vibhagSetu");

            String sql = "SELECT REQUEST_ID, F_ID, FIELD_NAME, OLD_VALUE, NEW_VALUE, REQUEST_DATE " +
                         "FROM UPDATE_REQUESTS WHERE STATUS='PENDING' ORDER BY REQUEST_DATE DESC";

            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            // Java 1.5 compatible: no diamond operator
            ArrayList<HashMap<String, String>> requests = new ArrayList<HashMap<String, String>>();
            
            while (rs.next()) {
                HashMap<String, String> map = new HashMap<String, String>();
                map.put("requestId", rs.getString("REQUEST_ID"));
                map.put("fid", rs.getString("F_ID"));
                map.put("field", rs.getString("FIELD_NAME"));
                map.put("oldVal", rs.getString("OLD_VALUE"));
                map.put("newVal", rs.getString("NEW_VALUE"));
                map.put("date", rs.getString("REQUEST_DATE"));
                requests.add(map);
            }

            request.setAttribute("requests", requests);
            rs.close();
            ps.close();
            con.close();

            request.getRequestDispatcher("updateRequests.jsp").forward(request, response);

        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}