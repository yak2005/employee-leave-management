package com.elms.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.elms.util.DBConnection;

@WebServlet("/CancelLeaveServlet")
public class CancelLeaveServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String leaveIdStr = request.getParameter("leaveId");
        response.setContentType("text/plain");

        if (leaveIdStr == null || leaveIdStr.isEmpty()) {
            response.getWriter().write("error");
            return;
        }

        int leaveId = Integer.parseInt(leaveIdStr);

        try (Connection conn = DBConnection.getConnection()) {
            // Only allow cancel if status is still Pending
            String sql = "DELETE FROM leaves WHERE leave_id=? AND status='Pending'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, leaveId);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                response.getWriter().write("success");
            } else {
                response.getWriter().write("not_allowed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error");
        }
    }
}
