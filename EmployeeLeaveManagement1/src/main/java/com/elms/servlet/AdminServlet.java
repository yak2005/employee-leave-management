package com.elms.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.elms.util.DBConnection;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String id = request.getParameter("id");

        if(action != null && id != null) {
            try {
                Connection conn = DBConnection.getConnection();

                // First check if leave is still pending
                PreparedStatement check = conn.prepareStatement(
                    "SELECT status FROM leaves WHERE leave_id=?"
                );
                check.setInt(1, Integer.parseInt(id));
                ResultSet rs = check.executeQuery();

                if(rs.next()) {
                    String status = rs.getString("status");
                    if("Pending".equalsIgnoreCase(status)) {
                        PreparedStatement ps = conn.prepareStatement(
                            "UPDATE leaves SET status=? WHERE leave_id=?"
                        );

                        if(action.equals("approve")) {
                            ps.setString(1, "Approved");
                        } else if(action.equals("reject")) {
                            ps.setString(1, "Rejected");
                        }

                        ps.setInt(2, Integer.parseInt(id));
                        ps.executeUpdate();
                        ps.close();
                    }
                    // else do nothing, already processed
                }

                rs.close();
                check.close();
                conn.close();

            } catch(Exception e) {
                e.printStackTrace();
            }
        }

        // redirect back to admin dashboard
        response.sendRedirect("adminDashboard.jsp");
    }
}
