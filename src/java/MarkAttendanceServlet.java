import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/MarkAttendanceServlet")
public class MarkAttendanceServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {

            // Faculty location from browser
            double facultyLat = Double.parseDouble(request.getParameter("lat"));
            double facultyLon = Double.parseDouble(request.getParameter("lng"));

            // Department selected
            int deptId = Integer.parseInt(request.getParameter("deptId"));

            // Faculty session
            HttpSession session = request.getSession();
            String facultyUser = (String) session.getAttribute("facultyUser");

            Class.forName("org.apache.derby.jdbc.ClientDriver");

            Connection con = DriverManager.getConnection(
                    "jdbc:derby://localhost:1527/vibhag_setu",
                    "vibhagSetu",
                    "vibhagSetu"
            );

            // ===== Get faculty ID =====
            int facultyId = 0;

            PreparedStatement psFac = con.prepareStatement(
                    "SELECT F_ID FROM FACULTY WHERE USER_NAME=?"
            );

            psFac.setString(1, facultyUser);

            ResultSet rsFac = psFac.executeQuery();

            if (rsFac.next()) {
                facultyId = rsFac.getInt("F_ID");
            }

            // ===== Get department GPS =====
            PreparedStatement psDept = con.prepareStatement(
                    "SELECT D_GPS_LATITUDE, D_GPS_LONGITUDE FROM DEPARTMENT WHERE D_ID=?"
            );

            psDept.setInt(1, deptId);

            ResultSet rsDept = psDept.executeQuery();

            if (rsDept.next()) {

                double deptLat = rsDept.getDouble("D_GPS_LATITUDE");
                double deptLon = rsDept.getDouble("D_GPS_LONGITUDE");

                double distance = distance(facultyLat, facultyLon, deptLat, deptLon);

                // 100 meter radius
                if (distance <= 0.1) {

                    java.util.Date utilDate = new java.util.Date();
                    java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
                    java.sql.Time sqlTime = new java.sql.Time(utilDate.getTime());

                    // ===== Duplicate check (Faculty + Dept + Date) =====
                    PreparedStatement check = con.prepareStatement(
                            "SELECT * FROM ATTENDANCE WHERE F_ID=? AND D_ID=? AND A_DATE=?"
                    );

                    check.setInt(1, facultyId);
                    check.setInt(2, deptId);
                    check.setDate(3, sqlDate);

                    ResultSet rsCheck = check.executeQuery();

                    if (rsCheck.next()) {

                       response.sendRedirect("attendance.jsp?status=already");

                    } else {

                        // ===== Generate A_ID manually =====
                        int newId = 1;

                        PreparedStatement getId = con.prepareStatement(
                                "SELECT MAX(A_ID) FROM ATTENDANCE"
                        );

                        ResultSet rsId = getId.executeQuery();

                        if (rsId.next()) {
                            newId = rsId.getInt(1) + 1;
                        }

                        // ===== Insert attendance =====
                        PreparedStatement insert = con.prepareStatement(
                                "INSERT INTO ATTENDANCE (A_ID, F_ID, D_ID, A_DATE, A_TIME, STATUS) VALUES (?,?,?,?,?,?)"
                        );

                        insert.setInt(1, newId);
                        insert.setInt(2, facultyId);
                        insert.setInt(3, deptId);
                        insert.setDate(4, sqlDate);
                        insert.setTime(5, sqlTime);
                        insert.setString(6, "Present");

                        insert.executeUpdate();

                        response.sendRedirect("attendance.jsp?status=success");
                    }

                } else {

                    response.sendRedirect("attendance.jsp?status=locationFail");

                }

            }

            con.close();

        } catch (Exception e) {

            e.printStackTrace();

        }
    }

    // ===== Distance calculation =====
    private double distance(double lat1, double lon1, double lat2, double lon2) {

        double theta = lon1 - lon2;

        double dist = Math.sin(Math.toRadians(lat1)) * Math.sin(Math.toRadians(lat2))
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.cos(Math.toRadians(theta));

        dist = Math.acos(dist);
        dist = Math.toDegrees(dist);
        dist = dist * 60 * 1.1515;
        dist = dist * 1.609344;

        return dist;
    }
}