import java.util.Scanner;
import java.sql.*;
public class CClient {
    
    public static void main(String[] args) throws Exception {

        System.out.println("Hello, Database!");
        Scanner reader = new Scanner(System.in);
        String query = reader.nextLine();
        String url = "jdbc:postgresql://localhost/world?user=postgres&password=postgres";
        Connection conn = DriverManager.getConnection(url);

        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery(query);
        int num = rs.getMetaData().getColumnCount();
        
        int counter = 0;

        while (rs.next()) {
            String result = "| ";
            for (int i = 1; i <=num; i++){
                result += rs.getString(i)+" | ";
            }

            counter++;

            System.out.println(result);

        }

        System.out.println(counter);
        rs.close();
        st.close();
        reader.close();
    }
}