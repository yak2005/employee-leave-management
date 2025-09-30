<%@ page import="java.sql.*, com.elms.util.DBConnection" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Delete Leave Requests</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 50px; background: #f5f5f5; }
        .container { background: #fff; padding: 30px; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.2); max-width: 600px; margin:auto; }
        h2 { text-align: center; }
        input[type="submit"] { padding: 12px 25px; border:none; background:#e53935; color:#fff; font-weight:bold; border-radius:10px; cursor:pointer; }
        input[type="submit"]:hover { background:#ff6b6b; }
        select { padding: 10px; width: 100%; margin-bottom: 20px; border-radius:10px; }
        .back { display:block; text-align:center; margin-top:20px; text-decoration:none; color:#333; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Delete Leave Requests</h2>

        <form action="deleteLeaves.jsp" method="post">
            <label>Select Leave Status to Delete:</label>
            <select name="status">
                <option value="All">All</option>
                <option value="Pending">Pending</option>
                <option value="Approved">Approved</option>
                <option value="Rejected">Rejected</option>
            </select>
            <input type="submit" value="Delete Selected">
        </form>

        <%
            if(request.getMethod().equalsIgnoreCase("POST")) {
                String status = request.getParameter("status");
                try {
                    Connection conn = DBConnection.getConnection();
                    PreparedStatement ps;
                    if(status.equals("All")) {
                        ps = conn.prepareStatement("TRUNCATE TABLE leaves");
                    } else {
                        ps = conn.prepareStatement("DELETE FROM leaves WHERE status=?");
                        ps.setString(1, status);
                    }
                    int rows = ps.executeUpdate();
                    conn.close();
        %>
                    <p style="color:green; text-align:center;">
                        <% if(status.equals("All")) { %>
                            All leave requests deleted successfully.
                        <% } else { %>
                            <%= rows %> leave request(s) with status "<%= status %>" deleted successfully.
                        <% } %>
                    </p>
        <%
                } catch(Exception e) {
                    out.println("<p style='color:red; text-align:center;'>Error: " + e.getMessage() + "</p>");
                }
            }
        %>

        <a href="adminDashboard.jsp" class="back">Back to Admin Dashboard</a>
    </div>
</body>
</html>
