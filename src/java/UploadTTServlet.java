import java.io.IOException;
import java.io.InputStream;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/UploadTTServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // 5MB limit
public class UploadTTServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        int fid = Integer.parseInt(request.getParameter("fid"));
        int did = Integer.parseInt(request.getParameter("did"));
        Part filePart = request.getPart("ttFile");

        // ✅ Only Image Allowed
        String contentType = filePart.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            response.getWriter().println("Only Image File Allowed!");
            return;
        }

        try {

            Class.forName("org.apache.derby.jdbc.ClientDriver");

            Connection con = DriverManager.getConnection(
                    "jdbc:derby://localhost:1527/vibhag_setu",
                    "vibhagSetu",
                    "vibhagSetu");

            PreparedStatement ps = con.prepareStatement(
                    "UPDATE FACULTY SET TIMETABLE=? WHERE F_ID=?");

            InputStream inputStream = filePart.getInputStream();

            ps.setBinaryStream(1, inputStream);
            ps.setInt(2, fid);

            int rows = ps.executeUpdate();

            con.close();

            if (rows > 0) {

    request.setAttribute("uploadSuccess", "true");
    request.getRequestDispatcher("UploadTT.jsp?fid=" + fid + "&did=" + did)
           .forward(request, response);

} else {

    response.getWriter().println("Faculty Not Found!");

}

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Database Error!");
        }
    }
}