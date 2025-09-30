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

@WebServlet("/removeNotificationServlet")
public class RemoveNotificationServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String leaveId = request.getParameter("leaveId");
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("UPDATE leaves SET is_seen=1 WHERE leave_id=?");
            ps.setInt(1, Integer.parseInt(leaveId));
            int updated = ps.executeUpdate();
            conn.close();
            if(updated > 0) {
                response.getWriter().write("success");
            } else {
                response.getWriter().write("fail");
            }
        } catch(Exception e) {
            e.printStackTrace();
            response.getWriter().write("fail");
        }
    }
}
