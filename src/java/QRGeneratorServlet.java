import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.OutputStream;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.client.j2se.MatrixToImageWriter;

@WebServlet("/qr")
public class QRGeneratorServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        
        String smartIdStr = request.getParameter("id"); // now pass SMARTCARD_ID
        if (smartIdStr == null) {
            response.getWriter().println("SMARTCARD_ID missing");
            return;
        }

        try {
            // Generate QR linking to ViewRecordServlet with numeric SMARTCARD_ID
            String data = "http://10.15.66.141:8080/Vibhag_Setu/ViewRecordServlet?type=faculty&id=" + smartIdStr+ "&mode=public";
            QRCodeWriter qrCodeWriter = new QRCodeWriter();
            BitMatrix matrix = qrCodeWriter.encode(data, BarcodeFormat.QR_CODE, 200, 200);

            response.setContentType("image/png");
            OutputStream os = response.getOutputStream();
            MatrixToImageWriter.writeToStream(matrix, "PNG", os);
            os.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/plain");
            response.getWriter().println("QR Generation Failed: " + e.getMessage());
        }
    }
}