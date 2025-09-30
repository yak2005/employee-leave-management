<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*,java.sql.*, com.elms.util.DBConnection" %>
<%@ page session="true" %>
<%
    // ======= SESSION CHECK =======
    Integer empId = (Integer) session.getAttribute("id");
    String userName = (String) session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    if(empId == null || userName == null){
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Employee Dashboard</title>
    <meta charset="UTF-8">
    <style>
        :root {
            --bg-light: #f0f8ff;
            --bg-dark: #1e1e2f;
            --text-light: #333;
            --text-dark: #fff;
            --card-light: rgba(255,255,255,0.9);
            --card-dark: rgba(30,30,50,0.95);
            --btn-light: #4CAF50;
            --btn-dark: #ff6a00;
            --btn-hover-light: #45a049;
            --btn-hover-dark: #ffb347;
            --logout-btn: #e53935; 
            --logout-hover: #ff6b6b;
            --notification-approved: #d4edda;
            --notification-rejected: #f8d7da;
            --notification-text-approved: #155724;
            --notification-text-rejected: #721c24;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0; color: var(--text-light);
            min-height: 100vh; display: flex; flex-direction: column; align-items: center;
            justify-content: flex-start; transition: all 0.5s ease;
            background: linear-gradient(270deg,#9d50bb,#6e48aa,#00d2ff,#f9f586);
            background-size: 800% 800%; animation: gradientBG 20s ease infinite;
        }
        @keyframes gradientBG { 0%{background-position:0% 50%;} 50%{background-position:100% 50%;} 100%{background-position:0% 50%;} }
        body.dark-mode { background: var(--bg-dark); color: var(--text-dark); }
        .header { width: 100%; background: rgba(76,175,80,0.9); color: #fff; display: flex;
            justify-content: space-between; align-items: center; padding: 15px 30px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3); backdrop-filter: blur(5px); transition: all 0.5s ease; overflow: visible; position: relative; z-index: 1000;
        }
        body.dark-mode .header { background: rgba(255,106,0,0.9); }
        .header h1 { margin: 0; font-size: 26px; }
        .toggle-btn { cursor: pointer; font-weight: bold; background: rgba(255,255,255,0.3); padding: 8px 18px; border-radius: 20px; transition: 0.3s; margin-right: 15px; font-size: 16px; }
        .toggle-btn:hover { background: rgba(255,255,255,0.6); }

        .bell-container { position: relative; display: inline-block; cursor: pointer; margin-right: 10px; font-size: 24px; z-index: 1000; }
        .bell-badge { position: absolute; top: -8px; right: -8px; background: red; color: #fff; font-size: 12px; border-radius: 50%; padding: 2px 6px; }
        .notification-dropdown { display: none; position: absolute; right: 0; top: 35px; background: #fff; min-width: 300px; max-height: 400px; overflow-y: auto; box-shadow: 0 8px 16px rgba(0,0,0,0.3); border-radius: 10px; z-index: 9999; }
        .notification-dropdown.dark-mode { background: #333; color: #fff; }
        .notification-item { padding: 10px 15px; border-bottom: 1px solid #ccc; font-size: 14px; position: relative; cursor: pointer; }
        .notification-item.approved { background: var(--notification-approved); color: var(--notification-text-approved); }
        .notification-item.rejected { background: var(--notification-rejected); color: var(--notification-text-rejected); }
        .notification-item:last-child { border-bottom: none; }
        .remove-btn { position: absolute; right: 10px; top: 8px; cursor: pointer; font-weight: bold; color: #888; }
        .remove-btn:hover { color: #333; }

        .container { background: var(--card-light); margin-top: 50px; padding: 50px; border-radius: 20px; text-align: center; box-shadow: 0 12px 25px rgba(0,0,0,0.3); backdrop-filter: blur(15px); transition: all 0.5s ease; width: 85%; max-width: 900px; position: relative; z-index: 1; overflow-x:auto; }
        body.dark-mode .container { background: var(--card-dark); }

        h2 { font-size: 32px; margin-bottom: 10px; }
        p { font-size: 18px; margin: 5px 0; }

        .btn { display: inline-block; margin: 15px 10px; padding: 14px 28px; border-radius: 30px; text-decoration: none; background: var(--btn-light); color: #fff; font-weight: bold; font-size: 16px; transition: all 0.3s ease; box-shadow: 0 5px 12px rgba(0,0,0,0.25); }
        .btn:hover { background: var(--btn-hover-light); transform: scale(1.05); }
        body.dark-mode .btn { background: var(--btn-dark); }
        body.dark-mode .btn:hover { background: var(--btn-hover-dark); }
        .btn-logout { background: var(--logout-btn); box-shadow: 0 5px 12px rgba(0,0,0,0.3); }
        .btn-logout:hover { background: var(--logout-hover); transform: scale(1.05); }
        .datetime { margin-top: 25px; font-size: 18px; color: #555; }
        body.dark-mode .datetime { color: #ccc; }

        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th, td { padding: 10px; text-align: center; }
        th { background: #4CAF50; color: #fff; }
        tr:nth-child(even) { background: #f9f9f9; }
        body.dark-mode th { background: #ff6a00; }
        body.dark-mode tr:nth-child(even) { background: #444; }
    </style>
</head>
<body>
    <div class="header" id="header">
        <h1>Employee Dashboard</h1>
        <div style="display:flex; align-items:center;">
            <span class="toggle-btn" onclick="toggleMode()">&#x2600; Light / &#x1F319; Dark</span>
            <div class="bell-container" onclick="toggleNotifications()">
                🔔
                <span class="bell-badge">
                    <%
                        int count = 0;
                        try (Connection conn = DBConnection.getConnection();
                             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM leaves WHERE employee_id=? AND status<>'Pending' AND is_seen=0")) {
                             ps.setInt(1, empId);
                             ResultSet rs = ps.executeQuery();
                             if(rs.next()){ count = rs.getInt(1); }
                        } catch(Exception e) { count=0; }
                        out.print(count);
                    %>
                </span>
                <div class="notification-dropdown" id="notificationDropdown">
                    <%
                        try (Connection conn = DBConnection.getConnection();
                             PreparedStatement ps = conn.prepareStatement(
                              "SELECT leave_id, leave_type, status, start_date, end_date FROM leaves WHERE employee_id=? AND status<>'Pending' AND is_seen=0 ORDER BY leave_id DESC")) {
                            ps.setInt(1, empId);
                            ResultSet rs = ps.executeQuery();
                            while(rs.next()){
                                int leaveId = rs.getInt("leave_id");
                                String status = rs.getString("status");
                                String type = rs.getString("leave_type");
                                String start = rs.getString("start_date");
                                String end = rs.getString("end_date");
                                String cssClass = "approved";
                                if("Rejected".equalsIgnoreCase(status)) cssClass = "rejected";
                    %>
                    <div class="notification-item <%= cssClass %>" data-leaveid="<%= leaveId %>">
                        <%= type %> leave from <%= start %> to <%= end %> has been <%= status %>.
                        <span class="remove-btn" onclick="removeNotification(this)">×</span>
                    </div>
                    <%
                            }
                        } catch(Exception e) { /* log error silently */ }
                    %>
                </div>
            </div>
            <a href="logout.jsp" class="btn btn-logout">Logout &#x1F512;</a>
        </div>
    </div>

    <div class="container">
        <h2>Welcome, <%= userName %></h2>
        <p>Role: <%= role %></p>
        <a href="leave.jsp" class="btn">Apply for Leave &#x1F4DD;</a>

        <h3 style="margin-top:30px;">Your Leave Requests</h3>
        <table border="0">
            <tr>
                <th>Type</th>
                <th>Start Date</th>
                <th>End Date</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            <%
                try (Connection conn2 = DBConnection.getConnection();
                     PreparedStatement ps2 = conn2.prepareStatement("SELECT leave_id, leave_type, start_date, end_date, status FROM leaves WHERE employee_id=? ORDER BY leave_id DESC")) {
                    ps2.setInt(1, empId);
                    ResultSet rs2 = ps2.executeQuery();
                    while(rs2.next()){
                        int leaveId = rs2.getInt("leave_id");
                        String type = rs2.getString("leave_type");
                        String start = rs2.getString("start_date");
                        String end = rs2.getString("end_date");
                        String statusStr = rs2.getString("status");
            %>
            <tr>
                <td><%= type %></td>
                <td><%= start %></td>
                <td><%= end %></td>
                <td><%= statusStr %></td>
                <td>
                    <% if("Pending".equalsIgnoreCase(statusStr)){ %>
                        <button onclick="cancelLeave(<%= leaveId %>)" style="background:#e53935;color:#fff;border:none;padding:8px 12px;border-radius:6px;cursor:pointer;">Cancel</button>
                    <% } else { %>
                        <span style="color:#888;">-</span>
                    <% } %>
                </td>
            </tr>
            <%
                    }
                } catch(Exception ex){ %>
                    <tr><td colspan="5" style="color:red;">Error loading leaves</td></tr>
            <% } %>
        </table>
        <div class="datetime" id="datetime"></div>
    </div>

    <script>
        function toggleMode(){
            document.body.classList.toggle('dark-mode');
            document.getElementById('header').classList.toggle('dark-mode');
            document.querySelectorAll('.notification-dropdown').forEach(e=>e.classList.toggle('dark-mode'));
        }

        function toggleNotifications(){
            var dropdown = document.getElementById('notificationDropdown');
            dropdown.style.display = (dropdown.style.display === 'block') ? 'none' : 'block';
        }

        document.addEventListener('click', function(event){
            var dropdown = document.getElementById('notificationDropdown');
            var bell = document.querySelector('.bell-container');
            if(!bell.contains(event.target)){ dropdown.style.display='none'; }
        });

        function updateDateTime(){
            const now = new Date();
            const options = { weekday:'long', year:'numeric', month:'long', day:'numeric', hour:'2-digit', minute:'2-digit', second:'2-digit'};
            document.getElementById('datetime').innerText = now.toLocaleDateString('en-US', options);
        }
        setInterval(updateDateTime, 1000);
        updateDateTime();

        function removeNotification(el){
            var notification = el.parentElement;
            var leaveId = notification.getAttribute('data-leaveid');
            fetch('removeNotificationServlet?leaveId=' + leaveId)
            .then(res=>res.text())
            .then(data=>{
                if(data.trim() === 'success') notification.remove();
            });
        }

        function cancelLeave(leaveId){
            if(!confirm("Are you sure you want to cancel this leave request?")) return;

            fetch('CancelLeaveServlet?leaveId=' + leaveId)
            .then(res=>res.text())
            .then(text=>{
                text=text.trim();
                if(text==='success'){
                    alert('Leave cancelled successfully.');
                    // remove the row without reloading
                    document.querySelectorAll('tr').forEach(row=>{
                        if(row.querySelector('button') && row.querySelector('button').onclick.toString().includes(leaveId)){
                            row.remove();
                        }
                    });
                } else if(text==='not_allowed'){
                    alert('Cannot cancel: leave already approved/rejected.');
                } else {
                    alert('Error cancelling leave. Try again.');
                }
            }).catch(err=>{
                console.error(err);
                alert('Network error. Try again.');
            });
        }
    </script>
</body>
</html>
