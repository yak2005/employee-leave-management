package com.elms.servlet;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            // 1. Load MySQL Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 2. Connect to database
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/elms_db?useSSL=false&serverTimezone=UTC", 
                    "root", 
                    "yyakshith2005"
            );

            // 3. Prepare SQL query
            String sql = "SELECT * FROM employee WHERE email=? AND password=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // 4. Set session attributes
                HttpSession session = request.getSession();
                session.setAttribute("id", rs.getInt("emp_id"));     // crucial for LeaveServlet
                session.setAttribute("user", rs.getString("name"));  // employee name
                session.setAttribute("role", rs.getString("role"));  // admin or employee

                // 5. Redirect based on role
                String role = rs.getString("role");
                if (role.equalsIgnoreCase("admin")) {
                    response.sendRedirect("adminDashboard.jsp");
                } else {
                    response.sendRedirect("dashboard.jsp");
                }
            } else {
                // Invalid credentials
                response.sendRedirect("login.jsp?error=Invalid+credentials");
            }

            // 6. Close connection
            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=Server+error");
        }
    }

    // Optional: handle GET requests by redirecting to login page
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }
}
