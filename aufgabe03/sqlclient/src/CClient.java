import java.util.Scanner;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.*;

public class CClient {

    Scanner reader;

    String url = "jdbc:postgresql://localhost/world?user=postgres&password=postgres";
    Connection conn;
    String lastquery = "";

    public CClient() {
        this.reader = new Scanner(System.in);
        try {
            this.conn = DriverManager.getConnection(url);
        } catch (SQLException e) {
            System.out.println("Failed creating DB connection: " + e.getMessage());
        }
    }

    void customQuery() {
        if (!lastquery.equals("")) {
            System.out.printf("Your last custom query was:\n%s\n\n", lastquery);
        }
        System.out.println("Enter your query: ");

        String query = reader.nextLine();
        lastquery = query;
        executeQuery(query);
    }

    void fileQuery() {
        System.out.println("Enter path to sql file (relative):");
        String filepath = reader.nextLine();

        fileQuery(filepath);
    }

    void fileQuery(String filepath) {

        if (!filepath.startsWith("/")) {
            filepath = System.getProperty("user.dir") + "/" + filepath;
        }

        try (BufferedReader br = new BufferedReader(new FileReader(filepath))) {
            StringBuilder sb = new StringBuilder();
            String line = br.readLine();

            while (line != null) {
                sb.append(line);
                sb.append(System.lineSeparator());
                line = br.readLine();
            }
            String sql_file = sb.toString();

            executeQuery(sql_file);

        } catch (FileNotFoundException e) {
            System.out.println("File not found");

        } catch (IOException e) {
            System.out.println("I/O error" + e.toString());

        }

    }

    void executeQuery(String query) {
        executeQuery(query, true);
    }

    void executeQuery(String query, Boolean restartprompt) {

        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(query);

            int num = rs.getMetaData().getColumnCount();

            System.out.println("num" + num);

            int counter = 0;

            while (rs.next()) {
                String result = "| ";
                for (int i = 1; i <= num; i++) {
                    result += rs.getString(i) + "\t\t| ";
                }

                counter++;

                System.out.println(result);

            }

            System.out.println(counter + " lines\n\n");
            rs.close();
            st.close();

        } catch (SQLException e) {
            System.out.println("SQL:" + e.getMessage());

        }

        if (restartprompt) {
            startprompt();

        }
    }

    void startprompt() {

        System.out.println("Hello, Database!");
        System.out.println("What do you want to do?");
        System.out.println("1: enter custom query");
        System.out.println("2: load and execute sql-file");
        System.out.println("3: create hackernews tables");
        System.out.println("4: populate hackernews tables");
        System.out.println("5: drop hackernews tables");
        System.out.println("0: exit");

        String input = reader.nextLine();

        try {
            int option = Integer.parseInt(input);

            switch (option) {
                case 1:
                    customQuery();
                    break;

                case 2:
                    fileQuery();
                    break;

                case 3:
                    fileQuery("create_hackernews.sql");
                    break;

                case 5: 
                    executeQuery("DROP TABLE users", false);
                    executeQuery("DROP TABLE jobs", false);
                    executeQuery("DROP TABLE stories", false);
                    executeQuery("DROP TABLE comments");
                    break;
                    
                case 0:
                    System.exit(0);
            }

        } catch (NumberFormatException e) {
            startprompt();

        }

        reader.close();
    }

    public static void main(String[] args) throws Exception {

        CClient cli = new CClient();
        cli.startprompt();

    }
}