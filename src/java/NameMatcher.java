import java.sql.*;

public class NameMatcher {

    public static int getFacultyIdByName(String inputName){

        int id = -1;

        try{
            Class.forName("org.apache.derby.jdbc.ClientDriver");

            Connection con = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/vibhag_setu",
                "vibhagSetu","vibhagSetu"
            );

            // LIKE for fuzzy search
            String sql = "SELECT F_ID, FIRST_NAME FROM FACULTY WHERE LOWER(FIRST_NAME) LIKE ? AND FLAG=1";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, "%"+inputName.toLowerCase()+"%");

            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                id = rs.getInt("F_ID");
            }

            con.close();

        }catch(Exception e){
            e.printStackTrace();
        }

        return id;
    }
}