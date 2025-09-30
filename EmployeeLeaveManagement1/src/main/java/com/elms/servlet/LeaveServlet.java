package com.elms.servlet;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet; // <-- ADD THIS
import java.io.IOException;
import java.sql.*;
import com.elms.util.DBConnection;

@WebServlet("/LeaveServlet")  // <-- ADD THIS LINE
public class LeaveServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("id") == null) {
            response.sendRedirect("login.jsp?error=Please+login+first");
            return;
        }

        int employeeId = (int) session.getAttribute("id");
        String leaveType = request.getParameter("leave_type");
        String startDate = request.getParameter("start_date");
        String endDate = request.getParameter("end_date");

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO leaves (employee_id, leave_type, start_date, end_date, status) VALUES (?, ?, ?, ?, 'Pending')"
            );
            ps.setInt(1, employeeId);
            ps.setString(2, leaveType);
            ps.setString(3, startDate);
            ps.setString(4, endDate);

            int row = ps.executeUpdate();

            if (row > 0) {
                response.sendRedirect("dashboard.jsp?msg=Leave+Applied+Successfully");
            } else {
                response.sendRedirect("leave.jsp?error=Failed+to+apply+leave");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("leave.jsp?error=Something+went+wrong");
        }
    }
}
