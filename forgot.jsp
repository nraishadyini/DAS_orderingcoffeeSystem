<%-- 
    Document   : forgot
    Created on : Apr 29, 2026, 7:07:29?AM
    Author     : auni
--%>

<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password - Coffee Shop</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #3e2723;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .container {
            background: #efebe9;
            padding: 30px;
            border-radius: 12px;
            width: 400px;
            text-align: center;
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
        }

        h2 {
            color: #4e342e;
            margin-bottom: 10px;
        }
        
        h3 {
            color: #6d4c41;
            margin-bottom: 20px;
            font-size: 16px;
        }

        input {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border-radius: 8px;
            border: 1px solid #bcaaa4;
            box-sizing: border-box;
        }

        button {
            width: 100%;
            padding: 10px;
            background: #6d4c41;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 10px;
        }

        button:hover {
            background: #5d4037;
        }

        a {
            display: block;
            margin-top: 15px;
            color: #3e2723;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

        .message {
            margin-top: 15px;
            padding: 10px;
            border-radius: 8px;
            font-size: 14px;
        }

        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .info {
            background-color: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
            font-size: 12px;
            margin-top: 20px;
            padding: 10px;
            border-radius: 8px;
            text-align: left;
        }
        
        hr {
            margin: 20px 0;
            border: 1px solid #d7ccc8;
        }
        
        .back-link {
            margin-top: 15px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>? Forgot Password?</h2>
    <h3>Reset your account password</h3>
    
    <p>Enter your username to receive a password reset link.</p>

    <form action="ForgotServlet" method="post">
        <input type="text" name="username" placeholder="Enter your username" required autofocus>
        <button type="submit">Send Reset Link</button>
    </form>

    <%
        String message = (String) request.getAttribute("message");
        String messageType = (String) request.getAttribute("messageType");
        
        if (message != null && !message.isEmpty()) {
    %>
        <div class="message <%= messageType %>">
            <%= message %>
        </div>
    <%
        }
    %>

    <hr>
    
    <div class="back-link">
        <a href="login.jsp">? Back to Login</a>
    </div>
    
    <div class="info">
        <strong>? How it works:</strong><br>
        ? Enter your registered username<br>
        ? A reset link will be generated (check console for demo)<br>
        ? Click the link to reset your password<br>
        ? Reset link expires in 1 hour<br><br>
        <strong>?? Note:</strong><br>
        ? For customer accounts only<br>
        ? Staff accounts (Manager/Cashier/Barista) - contact administrator
    </div>
</div>

</body>
</html>
