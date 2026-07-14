/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.net.URLEncoder;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author manas
 */
@WebServlet("/CheckEmailServlet")
public class CheckEmailServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("text/plain");

        String email = request.getParameter("email");
        String role = request.getParameter("role");

        boolean exists = false;
        String table = "ADMIN";

if ("faculty".equals(role)) {
    table = "FACULTY";
} else if ("cr".equals(role)) {
    table = "CR";
}


        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection(
    "jdbc:derby://localhost:1527/vibhag_setu",
    "vibhagSetu",
    "vibhagSetu"
);


            PreparedStatement ps =
    con.prepareStatement("SELECT * FROM " + table + " WHERE EMAIL=?");


            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            exists = rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }

       if (!exists) {
    response.getWriter().write("NOT_REGISTERED");
} else {
    response.getWriter().write("OK");
}

    }
}
