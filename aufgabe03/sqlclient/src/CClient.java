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

    String url = "jdbc:postgresql://localhost/world?user=postgres&password=postgres";
    Connection conn;
    String lastquery = "";

    int laststory_id;
    int lastcomment_id;

    ArrayList<String> stories = new ArrayList<>();
    ArrayList<String> users = new ArrayList<>();
    ArrayList<String> jobs = new ArrayList<>();
    ArrayList<String> comments = new ArrayList<>();
    ArrayList<String> users_ids = new ArrayList<>();
    ArrayList<Integer> stories_and_comments_ids = new ArrayList<>();

    public CClient() {
        this.reader = new Scanner(System.in);
        try {
            this.conn = DriverManager.getConnection(url);

            this.laststory_id = Integer.parseInt(saveQuery("SELECT MAX(id) FROM stories"));
            this.lastcomment_id = Integer.parseInt(saveQuery("SELECT MAX(id) FROM comments"));

            System.out.println(laststory_id);
            System.out.println(lastcomment_id);

        } catch (SQLException e) {
            System.out.println("Failed creating DB connection: " + e.getMessage());
        }
    }

    public static <T> T getRandomElement(List<T> list) {
        if (list == null || list.isEmpty()) {
            return null; // Oder wirf eine Exception
        }
        return list.get(ThreadLocalRandom.current().nextInt(list.size()));
    }

    void createUser() {
        String randomName = "Testuser" + Math.round(Math.random() * 1000000000);
        users.add("('" + randomName + "', '" + LocalDateTime.now() + "')");
        users_ids.add(randomName);
    }

    void createStory() {
        String randomTitle = "Teststory " + Math.round(Math.random() * 1000000000);
        stories.add("('" + randomTitle + "', '" + LocalDateTime.now() + "', '"+ getRandomElement(users_ids)+"')");
        laststory_id++;
        stories_and_comments_ids.add(laststory_id);
    }

    void createJob() {
        String randomTitle = "Testjob " + Math.round(Math.random() * 1000000000);
        jobs.add("('" + randomTitle + "', '" + LocalDateTime.now() + "', '"+ getRandomElement(users_ids)+"')");
    }

    void createComment() {
        String randomTitle = "TestComment " + Math.round(Math.random() * 1000000000);
        comments.add("('" + randomTitle + "', "+ getRandomElement(stories_and_comments_ids)+", '" + LocalDateTime.now() + "', '"+ getRandomElement(users_ids)+"')");

        lastcomment_id++;
        stories_and_comments_ids.add(lastcomment_id);
    }

    void populateDb() {
        stories = new ArrayList<>();
        users = new ArrayList<>();
        comments = new ArrayList<>();
        jobs = new ArrayList<>();
        populateDb(10, 10, 10, 10);
    }

    public void populateDb(int users_num, int stories_num, int comments_num, int jobs_num) {
        LocalDateTime start = LocalDateTime.now();

        for (int i = 0; i < users_num; i++) {
            createUser();
        }

        for (int i = 0; i < stories_num; i++) {
            createStory();
        }

        for (int i = 0; i < jobs_num; i++) {
            createJob();
        }

        for (int i = 0; i < comments_num; i++) {
            createComment();
        }

        LocalDateTime time_created = LocalDateTime.now();

        executeUpdate("INSERT INTO users (id, created) VALUES " + String.join(",",
                users));
        executeUpdate("INSERT INTO stories (title, created, by) VALUES " +
                String.join(",", stories));
        executeUpdate("INSERT INTO jobs (title, created, by) VALUES " + String.join(",",
                jobs));

        executeUpdate("INSERT INTO comments (title, parent, created, by) VALUES " +
                String.join(",", comments));

        LocalDateTime end = LocalDateTime.now();

        System.out.println("start: " + start);
        System.out.println("generiert in: " + Duration.between(start, time_created));
        System.out.println("in Datenbank geschrieben in: " + Duration.between(start, end));

        startprompt();

    }

    void customQuery() {
        if (!lastquery.equals("")) {
            System.out.printf("Your last custom query was:\n%s\n\n", lastquery);
        }
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

        System.out.println("SELECTED file: " + filepath);

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

    void executeUpdate(String query) {
        try {
            Statement st = conn.createStatement();
            st.executeUpdate(query);
        } catch (SQLException e) {
            System.out.println("SQL:" + e.getMessage());
        }
    }

    String saveQuery(String query) {
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(query);
            rs.next();

            return rs.getString(1);
        } catch (SQLException e) {
            System.out.println("SQL:" + e.getMessage());
        }

        return null;

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
                    startprompt();
                    break;

                case 3:
                    fileQuery("create_hackernews.sql");
                    break;

                case 4:
                    populateDb();
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

        int stories_num = 0;
        int comments_num = 0;
        int users_num = 0;
        int jobs_num = 0;

        CClient cli = new CClient();

        String stories_arg = Arrays.stream(args).filter(arg -> arg.startsWith("stories:")).findFirst().orElse(null);
        if (stories_arg != null) {
            stories_num = Integer.parseInt(stories_arg.split(":")[1]);
        }

        String jobs_arg = Arrays.stream(args).filter(arg -> arg.startsWith("jobs:")).findFirst().orElse(null);
        if (jobs_arg != null) {
            jobs_num = Integer.parseInt(jobs_arg.split(":")[1]);
        }

        String comments_arg = Arrays.stream(args).filter(arg -> arg.startsWith("comments:")).findFirst().orElse(null);
        if (comments_arg != null) {
            comments_num = Integer.parseInt(comments_arg.split(":")[1]);
        }

        String users_arg = Arrays.stream(args).filter(arg -> arg.startsWith("users:")).findFirst().orElse(null);
        if (users_arg != null) {
            users_num = Integer.parseInt(users_arg.split(":")[1]);
        }

        if (stories_num > 0 && users_num > 0 && comments_num > 0 && jobs_num > 0) {
            cli.populateDb(users_num, stories_num, comments_num, jobs_num);
        } else {
            cli.startprompt();

        }

    }
}