import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ChatbotServlet")
public class ChatbotServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        String msg = request.getParameter("message");

        // Process message from ChatbotEngine
        String result = ChatbotEngine.process(msg);

        try {

            // ================= DELETE =================

            if (result.startsWith("DELETE_FACULTY")) {

                String id = result.split(":")[1];

                response.sendRedirect("DeleteRecordServlet?type=faculty&id=" + id);
                return;
            }

            if (result.startsWith("DELETE_CR")) {

                String id = result.split(":")[1];

                response.sendRedirect("DeleteRecordServlet?type=cr&id=" + id);
                return;
            }

            // ================= VIEW =================

            if (result.startsWith("VIEW_FACULTY")) {

                String id = result.split(":")[1];

                response.sendRedirect("ViewRecordServlet?type=faculty&id=" + id);
                return;
            }

            if (result.startsWith("VIEW_CR")) {

                String id = result.split(":")[1];

                response.sendRedirect("ViewRecordServlet?type=cr&id=" + id);
                return;
            }

            // ================= QUICK UPDATE =================

            if (result.startsWith("QUICK_UPDATE")) {

                String[] parts = result.split(":");

                String type = parts[1];
                String id = parts[2];
                String field = parts[3];
                String value = parts[4];

                response.sendRedirect(
                        "QuickUpdateServlet?type=" + type +
                        "&id=" + id +
                        "&field=" + field +
                        "&value=" + value
                );

                return;
            }

            
               if(result.startsWith("ADV_SEARCH")){

    String[] parts = result.split(":");

    String type = parts[1];
    String field = parts[2];
    String operator = parts[3];
    String value = parts[4];

    response.sendRedirect(
        "SearchServlet?type=" + type +
        "&field=" + field +
        "&operator=" + operator +
        "&value=" + value
    );

    return;
}
            // ================= DEFAULT / AI RESPONSE =================

            out.print(result);

        } catch (Exception e) {
            e.printStackTrace();
            out.print("Error executing command");
        }
    }
}