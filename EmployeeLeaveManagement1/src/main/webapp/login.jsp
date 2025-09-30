<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Employee Login</title>
    <meta charset="UTF-8">
    <style>
    /* Full page animated background gradient */
    body {
        margin: 0;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        height: 100vh;
        background: linear-gradient(270deg, #ff9a9e, #fad0c4, #a1c4fd, #c2e9fb, #fbc2eb, #a6c0fe);
        background-size: 1200% 1200%;
        animation: gradientBG 20s ease infinite;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    @keyframes gradientBG {
        0% {background-position:0% 50%;}
        25% {background-position:50% 50%;}
        50% {background-position:100% 50%;}
        75% {background-position:50% 50%;}
        100% {background-position:0% 50%;}
    }

    /* Login container */
    .login-box {
        background: rgba(255, 255, 255, 0.95); /* Slightly more opaque for contrast */
        padding: 50px 60px;
        border-radius: 20px;
        box-shadow: 0 12px 25px rgba(0,0,0,0.3);
        text-align: center;
        backdrop-filter: blur(15px);
        width: 380px;
    }

    .login-box h2 {
        margin-bottom: 30px;
        font-size: 32px;
        color: #222; /* Dark text for readability */
        text-shadow: 1px 1px 3px rgba(0,0,0,0.2);
    }

    input[type="email"], input[type="password"] {
        width: 100%;
        padding: 14px;
        margin: 10px 0;
        border: 2px solid #ccc;
        border-radius: 25px;
        outline: none;
        font-size: 16px;
        transition: all 0.3s ease;
    }

    input[type="email"]:focus, input[type="password"]:focus {
        border-color: #ff6a00;
        box-shadow: 0 0 8px rgba(255,106,0,0.4);
    }

    input[type="submit"] {
        width: 100%;
        padding: 14px;
        border: none;
        border-radius: 25px;
        background: #ff6a00; /* Strong orange for contrast */
        color: #fff;
        font-size: 18px;
        font-weight: bold;
        cursor: pointer;
        transition: all 0.3s ease;
        margin-top: 15px;
    }

    input[type="submit"]:hover {
        background: #ffb347; /* lighter hover effect */
        transform: scale(1.05);
        box-shadow: 0 5px 15px rgba(255,180,71,0.4);
    }

    .error {
        color: #d32f2f; /* strong red for errors */
        margin-top: 15px;
        font-weight: bold;
        text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
    }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>Employee Login</h2>
        <form action="login" method="post">
            <input type="email" name="email" placeholder="Email" required /><br/>
            <input type="password" name="password" placeholder="Password" required /><br/><br/>
            <input type="submit" value="Login" />
        </form>
        <%
            String error = request.getParameter("error");
            if (error != null) {
        %>
            <div class="error"><%= error %></div>
        <%
            }
        %>
    </div>
</body>
</html>
