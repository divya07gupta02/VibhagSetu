import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

public class AIService {
    
    private static final String API_KEY = System.getenv("OPENAI_API_KEY");

    public static String askAI(String userMsg){
        
        System.setProperty("https.protocols", "TLSv1.2");
        try{
            URL url = new URL("https://api.openai.com/v1/chat/completions");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Bearer " + API_KEY);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            // ✅ SAFE message
            String safeMsg = userMsg.replace("\"", "\\\"");

            String jsonInput = "{"
                    + "\"model\":\"gpt-4o-mini\","
                    + "\"messages\":["
                    + "{\"role\":\"system\",\"content\":\"You are admin assistant\"},"
                    + "{\"role\":\"user\",\"content\":\"" + safeMsg + "\"}"
                    + "]}";

            OutputStream os = conn.getOutputStream();
            os.write(jsonInput.getBytes());
            os.flush();
            os.close();

            BufferedReader br;

            // ✅ HANDLE BOTH SUCCESS + ERROR
            if(conn.getResponseCode() == 200){
                br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            } else {
                br = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
            }

            String line, response = "";
            while((line = br.readLine()) != null){
                response += line;
            }

            br.close();

            System.out.println("AI RAW RESPONSE: " + response); // debug

            // ✅ SAFE PARSE
            if(response.contains("\"content\":\"")){
                String temp = response.split("\"content\":\"")[1];
                return temp.split("\"")[0];
            }

            return "AI response parse error";

        }catch(Exception e){
            e.printStackTrace();
            return "ERROR: " + e.getMessage();
        }
    }
}