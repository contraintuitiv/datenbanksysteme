import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;
import java.util.concurrent.ThreadLocalRandom;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.*;
import java.time.Duration;
import java.time.LocalDateTime;

public class CClient {

    Scanner reader;

    String url = "jdbc:postgresql://localhost/krankenhaus?user=postgres&password=postgres";
    Connection conn;

    public CClient() {
        this.reader = new Scanner(System.in);
        try {
            this.conn = DriverManager.getConnection(url);

        } catch (SQLException e) {
            System.out.println("Failed creating DB connection: " + e.getMessage());
        }
    }


    void customQuery() {

        System.out.println("Enter your query: ");
        StringBuilder fullQuery = new StringBuilder();
        System.out.println("Enter your query (type 'SEND' on a new line to finish):");

        while (reader.hasNextLine()) {
            String line = reader.nextLine();
            if (line.equalsIgnoreCase("SEND")) {
                break;
            }
            fullQuery.append(line).append("\n");
        }

        String query = fullQuery.toString().trim();

        executeQuery(query);
    }

    void executeQuery(String query) {
        executeQuery(query, true);
    }

    void executeQuery(String query, Boolean restartprompt) {
        LocalDateTime start = LocalDateTime.now();

        System.out.println(query);

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

        LocalDateTime end = LocalDateTime.now();

        System.out.println("Ausführungszeit: " + Duration.between(start, end));

        if (restartprompt) {
            startprompt();
        }
    }

    void startprompt() {

        System.out.println("Hello, Database!");
        System.out.println("What do you want to do?");

        customQuery();
    }

    public static void main(String[] args) throws Exception {

        CClient cli = new CClient();
        cli.startprompt();
    }

}