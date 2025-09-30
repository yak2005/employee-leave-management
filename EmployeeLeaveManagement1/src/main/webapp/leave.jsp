<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Apply for Leave</title>
    <meta charset="UTF-8">
    <style>
        /* Animated background gradient with new colors */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(270deg, #a8edea, #fed6e3, #ffe29f, #c3f0ca);
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

        /* Leave container */
        .container {
            background: rgba(255,255,255,0.95);
            padding: 50px 60px;
            border-radius: 20px;
            text-align: center;
            box-shadow: 0 12px 25px rgba(0,0,0,0.3);
            backdrop-filter: blur(15px);
            width: 400px;
        }

        h2 {
            font-size: 32px;
            margin-bottom: 25px;
            color: #222;
            text-shadow: 1px 1px 3px rgba(0,0,0,0.1);
        }

        select, input[type="date"] {
            width: 100%;
            padding: 14px;
            margin: 12px 0;
            border-radius: 25px;
            border: 2px solid #ccc;
            outline: none;
            font-size: 16px;
            transition: all 0.3s ease;
        }

        select:focus, input[type="date"]:focus {
            border-color: #4CAF50;
            box-shadow: 0 0 8px rgba(76,175,80,0.3);
        }

        input[type="submit"] {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 30px;
            background: #4CAF50;
            color: #fff;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 20px;
            box-shadow: 0 5px 15px rgba(76,175,80,0.3);
        }

        input[type="submit"]:hover {
            background: #45a049;
            transform: scale(1.05);
        }

        .btn-back {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            padding: 12px 25px;
            border-radius: 30px;
            background: #888;
            color: #fff;
            font-weight: bold;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .btn-back:hover {
            background: #555;
            transform: scale(1.05);
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Apply for Leave</h2>
        <form action="LeaveServlet" method="post">
            <select name="leave_type" required>
                <option value="">Select Leave Type</option>
                <option value="Sick Leave">Sick Leave</option>
                <option value="Casual Leave">Casual Leave</option>
                <option value="Earned Leave">Earned Leave</option>
                <option value="Maternity Leave">Maternity Leave</option>
                <option value="Paternity Leave">Paternity Leave</option>
                <option value="Bereavement Leave">Bereavement Leave</option>
                <option value="Half-Day Leave">Half-Day Leave</option>
            </select><br/>
            <input type="date" name="start_date" required /><br/>
            <input type="date" name="end_date" required /><br/><br/>
            <input type="submit" value="Apply" />
        </form>
        <a href="dashboard.jsp" class="btn-back">Back to Dashboard</a>
    </div>
</body>
</html>
