<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="com.elms.util.DBConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Leave History</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            background: linear-gradient(135deg, #fdfbfb, #ebedee, #a1c4fd, #c2e9fb);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding-top: 50px;
        }
        .container {
            background: rgba(255,255,255,0.9);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
            width: 80%;
            max-width: 900px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #ccc;
        }
        th {
            background: #4CAF50;
            color: #fff;
        }
        tr:hover {
            background: #f5f5f5;
        }
        .btn-back {
            display: inline-block;
            margin-top: 15px;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 25px;
            background: #888;
            color: #fff;
            transition: 0.3s;
        }
        .btn-back:hover {
            background: #555;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>My Leave History</h2>
        <table>
            <tr>
                <th>Leave Type</th>
                <th>Start Date</th>
                <th>End Date</th>
                <th>Status</th>
            </tr>
            <%
                String email = (String) session.getAttribute("user");
                if(email != null){
                    try {
                        Connection conn = DBConnection.getConnection();
                        PreparedStatement ps = conn.prepareStatement(
                            "SELECT leave_type, start_date, end_date, status FROM leaves WHERE email=?"
                        );
                        ps.setString(1, email);
                        ResultSet rs = ps.executeQuery();
                        while(rs.next()){
            %>
            <tr>
                <td><%= rs.getString("leave_type") %></td>
                <td><%= rs.getString("start_date") %></td>
                <td><%= rs.getString("end_date") %></td>
                <td><%= rs.getString("status") %></td>
            </tr>
            <%
                        }
                        conn.close();
                    } catch(Exception e){ out.println("Error: "+e.getMessage()); }
                }
            %>
        </table>
        <a href="dashboard.jsp" class="btn-back">Back to Dashboard</a>
    </div>
</body>
</html>
