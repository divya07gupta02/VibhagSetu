import java.util.HashMap;
import java.util.Map;

public class ChatbotEngine {

    public static String process(String msg){

        if(msg == null || msg.trim().equals("")){
            return "Please type a command";
        }

        msg = msg.toLowerCase().trim();

        try{
            if(msg.contains("hello") || msg.equals("hi") || msg.equals("hey")){
    return "Hello, how can I help you?";
}
       // ================= DELETE =================

            if(msg.contains("delete faculty")){
                String id = extractNumber(msg);

                if(id.equals("")){
                    String name = extractName(msg);
                    id = String.valueOf(NameMatcher.getFacultyIdByName(name));
                }

                return "DELETE_FACULTY:" + id;
            }

            if(msg.contains("delete cr")){
                String id = extractNumber(msg);
                return "DELETE_CR:" + id;
            }

            // ================= VIEW =================

            if(msg.contains("view faculty")){
                String id = extractNumber(msg);

                if(id.equals("")){
                    String name = extractName(msg);
                    id = String.valueOf(NameMatcher.getFacultyIdByName(name));
                }

                return "VIEW_FACULTY:" + id;
            }

            if(msg.contains("view cr")){
                String id = extractNumber(msg);
                return "VIEW_CR:" + id;
            }

            
            
            
            
            
            
            
            
            if(msg.contains("search") || msg.contains("find")){

    String type = msg.contains("cr") ? "cr" : "faculty";

            
              String field = "";
    String operator = "=";
    String value = "";

    if(msg.contains("salary")){
        field = "SALARY";
        value = extractNumber(msg);

        if(msg.contains(">")) operator = ">";
        else if(msg.contains("<")) operator = "<";
    }

    else if(msg.contains("city")){
        field = "CITY";
        value = extractAfterKeyword(msg, "city");
    }

    else if(msg.contains("designation")){
        field = "DESIGNATION";
        value = extractAfterKeyword(msg, "designation");
    }

    else if(msg.contains("name")){
        field = "FIRST_NAME";
        value = extractAfterKeyword(msg, "name");
    }
    if(!field.equals("") && !value.equals("")){
        return "ADV_SEARCH:" + type + ":" + field + ":" + operator + ":" + value;
    }

    // fallback normal search
    String keyword = extractLastWord(msg);
    return "SEARCH:" + type + ":" + keyword;
}
            
            
            
            
            
            
            
            
            
            // ================= UPDATE =================

            if(msg.contains("update")){

                // detect type
                String type = "";
                if(msg.contains("faculty")){
                    type = "faculty";
                } 
                else if(msg.contains("cr")){
                    type = "cr";
                }

                // extract ID (or from name)
                String id = extractNumber(msg);

                if(id.equals("") && type.equals("faculty")){
                    String name = extractName(msg);
                    id = String.valueOf(NameMatcher.getFacultyIdByName(name));
                }

                // field mapping
                Map<String,String> fieldMap = new HashMap<>();

                if(type.equals("faculty")){
                    fieldMap.put("firstname","FIRST_NAME");
                    fieldMap.put("middlename","MIDDLE_NAME");
                    fieldMap.put("lastname","LAST_NAME");
                    fieldMap.put("email","EMAIL");
                    fieldMap.put("contact","CONTACT_NO");
                    fieldMap.put("title","TITLE");
                    fieldMap.put("mother","MOTHER_NAME");
                    fieldMap.put("father","FATHER_NAME");
                    fieldMap.put("city","CITY");
                    fieldMap.put("state","STATE");
                    fieldMap.put("address","ADDRESS");
                    fieldMap.put("zipcode","ZIPCODE");
                    fieldMap.put("dob","DOB");
                    fieldMap.put("marital","MARITAL_STATUS");
                    fieldMap.put("gender","GENDER");
                    fieldMap.put("category","CATEGORY");
                    fieldMap.put("tongue","MOTHER_TONGUE");
                    fieldMap.put("disability","DISABILITY");
                    fieldMap.put("qualification","QUALIFICATION");
                    fieldMap.put("experience","EXPERIENCE");
                    fieldMap.put("salary","SALARY");
                    fieldMap.put("designation","DESIGNATION");
                    fieldMap.put("nationality","NATIONALITY");
                    fieldMap.put("aadhar","AADHAR_NO");
                }

                else if(type.equals("cr")){
                    fieldMap.put("name","NAME");
                    fieldMap.put("email","EMAIL");
                    fieldMap.put("contact","CONTACT_NO");
                    fieldMap.put("branch","BRANCH");
                    fieldMap.put("year","YEAR");
                    fieldMap.put("section","SECTION");
                }

                // detect field
                String field = "";
                for(String key : fieldMap.keySet()){
                    if(msg.contains(key)){
                        field = fieldMap.get(key);
                        break;
                    }
                }

                // extract value safely
                String value = "";

                if(msg.contains("to")){
                    String[] parts = msg.split("to");
                    if(parts.length > 1){
                        value = parts[1].trim();
                    }
                }

                // final command
                if(!field.equals("") && !value.equals("") && !type.equals("")){
                    return "QUICK_UPDATE:" + type + ":" + id + ":" + field + ":" + value;
                }

                return "Update command samajh nahi aaya";
            }

           

            // ================= AI FALLBACK =================

            return AIService.askAI(msg);

        }
        catch(Exception e){
            e.printStackTrace();
            return "Error processing command.";
        }
    }

    // ================= HELPER METHODS =================

    
    
    private static String extractAfterKeyword(String msg, String key){

    String[] parts = msg.split(key);

    if(parts.length > 1){
        return parts[1].trim();
    }

    return "";
}
    
    
    
     private static String extractLastWord(String msg){
        String[] words = msg.split(" ");
        return words[words.length - 1];
    }
    
    
    
    
    private static String extractNumber(String msg){

        String[] words = msg.split(" ");

        for(String w : words){
            if(w.matches("\\d+")){
                return w;
            }
        }

        return "";
    }

    private static String extractName(String msg){

        String[] words = msg.split(" ");

        for(String w : words){

            if(!w.equals("update") &&
               !w.equals("delete") &&
               !w.equals("view") &&
               !w.equals("faculty") &&
               !w.equals("cr") &&
               !w.equals("salary") &&
               !w.equals("email") &&
               !w.equals("contact") &&
               !w.equals("to") &&
               !w.equals("kar") &&
               !w.equals("do") &&
               !w.matches("\\d+")){

                return w;
            }
        }

        return "";
    }
}