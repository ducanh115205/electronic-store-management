package dao;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DAO implements AutoCloseable {
    protected Connection con;

    public DAO() throws SQLException {
        Properties properties = new Properties();

        Path configPath = Paths.get(
                System.getProperty("user.home"),
                "electronic-store-db.properties"
        );

        try (InputStream input = Files.newInputStream(configPath)) {
            properties.load(input);
        } catch (IOException e) {
            throw new SQLException(
                    "Không đọc được file cấu hình database: " + configPath,
                    e
            );
        }

        String url = properties.getProperty("db.url");
        String user = properties.getProperty("db.user");
        String password = properties.getProperty("db.password");

        if (url == null || user == null || password == null) {
            throw new SQLException("File cấu hình database chưa đủ thông tin.");
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Không tìm thấy MySQL Connector/J.", e);
        }

        con = DriverManager.getConnection(url, user, password);
    }

    @Override
    public void close() throws SQLException {
        if (con != null && !con.isClosed()) {
            con.close();
        }
    }
}