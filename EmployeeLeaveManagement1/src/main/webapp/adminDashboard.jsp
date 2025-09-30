<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.elms.util.DBConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <meta charset="UTF-8">
    <style>
        :root {
            --bg-light: #f0f8ff;
            --bg-dark: #1e1e2f;
            --text-light: #333;
            --text-dark: #fff;
            --card-light: rgba(255, 255, 255, 0.95);
            --card-dark: rgba(30,30,50,0.95);
            --btn-approve: #4CAF50;
            --btn-reject: #f44336;
            --btn-logout: #ff6a00;
            --btn-disabled: #888888;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            min-height: 100vh;
            color: var(--text-light);
            display: flex;
            flex-direction: column;
            align-items: center;
            transition: all 0.5s ease;
            background: linear-gradient(270deg, #f6d365, #fda085, #a1c4fd, #c2e9fb);
            background-size: 1000% 1000%;
            animation: gradientBG 25s ease infinite;
        }

        @keyframes gradientBG {
            0% {background-position:0% 50%;}
            25% {background-position:50% 50%;}
            50% {background-position:100% 50%;}
            75% {background-position:50% 50%;}
            100% {background-position:0% 50%;}
        }

        body.dark-mode { background: #1e1e2f; color: var(--text-dark); }

        .header {
            width: 100%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 30px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            backdrop-filter: blur(5px);
            margin-bottom: 20px;
            transition: all 0.5s ease;
        }

        .header h1 { margin: 0; font-size: 28px; }
        .toggle-btn { cursor: pointer; font-weight: bold; background: rgba(255,255,255,0.3); padding: 8px 15px; border-radius: 20px; margin-right: 10px; transition: 0.3s; }
        .toggle-btn:hover { background: rgba(255,255,255,0.6); }

        .datetime { font-size: 16px; margin-left: 20px; }

        .container {
            background: var(--card-light);
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            width: 95%;
            max-width: 1100px;
            transition: all 0.5s ease;
        }

        body.dark-mode .container { background: var(--card-dark); }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            transition: all 0.3s ease;
        }

        th, td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #ccc;
        }

        th { background: #ff6a00; color: #fff; }
        body.dark-mode th { background: #ffb347; color: #1e1e2f; }

        tr:hover { background: rgba(76, 175, 80, 0.1); }

        .btn {
            padding: 8px 16px;
            border-radius: 25px;
            text-decoration: none;
            color: #fff;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-approve { background: var(--btn-approve); }
        .btn-approve:hover { background: #45a049; transform: scale(1.05); }

        .btn-reject { background: var(--btn-reject); }
        .btn-reject:hover { background: #e53935; transform: scale(1.05); }

        .btn-disabled { background: var(--btn-disabled); cursor: not-allowed; }

        .btn-logout { background: var(--btn-logout); margin-top: 20px; padding: 12px 25px; }
        .btn-logout:hover { background: #ffb347; transform: scale(1.05); }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <h1>Admin Dashboard</h1>
        <div>
            <span class="datetime" id="datetime"></span>
            <span class="toggle-btn" onclick="toggleMode()">🌙 / ☀️</span>
            <a href="logout.jsp" class="btn btn-logout">Logout</a>
        </div>
    </div>

    <div class="container">
        <h2>All Leave Requests</h2>
        <table>
            <tr>
                <th>Employee</th>
                <th>Leave Type</th>
                <th>Start Date</th>
                <th>End Date</th>
                <th>Status</th>
                <th>Requested At</th>
                <th>Actions</th>
            </tr>
            <%
                try {
                    Connection conn = DBConnection.getConnection();
                    PreparedStatement ps = conn.prepareStatement(
                        "SELECT l.leave_id, e.name, l.leave_type, l.start_date, l.end_date, l.status, l.request_time " +
                        "FROM leaves l JOIN employee e ON l.employee_id = e.emp_id ORDER BY l.request_time DESC"
                    );
                    ResultSet rs = ps.executeQuery();
                    while(rs.next()){
                        String status = rs.getString("status");
            %>
            <tr>
                <td><%= rs.getString("name") %></td>
                <td><%= rs.getString("leave_type") %></td>
                <td><%= rs.getString("start_date") %></td>
                <td><%= rs.getString("end_date") %></td>
                <td><%= status %></td>
                <td><%= rs.getString("request_time") %></td>
                <td>
                    <% if("Pending".equalsIgnoreCase(status)){ %>
                        <a href="AdminServlet?action=approve&id=<%= rs.getInt("leave_id") %>" class="btn btn-approve">Approve</a>
                        <a href="AdminServlet?action=reject&id=<%= rs.getInt("leave_id") %>" class="btn btn-reject">Reject</a>
                    <% } else { %>
                        <button class="btn btn-disabled" disabled><%= status %></button>
                    <% } %>
                </td>
            </tr>
            <%
                    }
                    conn.close();
                } catch(Exception e){ out.println(e.getMessage()); }
            %>
        </table>
    </div>

    <script>
        // Toggle Light/Dark Mode
        function toggleMode(){
            document.body.classList.toggle('dark-mode');
        }

        // Display Date & Time
        function updateDateTime(){
            const now = new Date();
            const options = { weekday:'long', year:'numeric', month:'long', day:'numeric',
                              hour:'2-digit', minute:'2-digit', second:'2-digit'};
            document.getElementById('datetime').innerText = now.toLocaleDateString('en-US', options);
        }
        setInterval(updateDateTime, 1000);
        updateDateTime();
    </script>
</body>
</html>
