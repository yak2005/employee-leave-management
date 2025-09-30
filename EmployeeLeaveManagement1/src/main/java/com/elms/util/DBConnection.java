package com.elms.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    // Change db name, user, and password according to your MySQL setup
	private static final String URL = "jdbc:mysql://localhost:3306/elms_db?useSSL=false&serverTimezone=UTC";;
    private static final String USER = "root";       // your MySQL username
    private static final String PASSWORD = "yyakshith2005";   // your MySQL password

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL Connector/J driver
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }
}
