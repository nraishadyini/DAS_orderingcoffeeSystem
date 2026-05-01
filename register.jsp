<%-- 
    Document   : register
    Created on : Apr 29, 2026, 7:08:27?AM
    Author     : auni
--%>
<%-- 
    Document   : register
    Created on : Apr 29, 2026, 7:08:27?AM
    Author     : auni
--%>

<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
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
            width: 320px;
            text-align: center;
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
        }

        h2 {
            color: #4e342e;
        }

        input, select {
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
        }

        button:hover {
            background: #5d4037;
        }

        a {
            display: block;
            margin-top: 10px;
            color: #3e2723;
            text-decoration: none;
        }

        .error {
            color: red;
            font-size: 14px;
        }
        
        .message {
            color: green;
            font-size: 14px;
            margin-top: 10px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Register</h2>
    
    <!-- FIXED: Removed .java extension -->
    <form action="RegisterServlet" method="post">
        <input type="text" name="username" placeholder="Username" required>
        <input type="password" name="password" placeholder="Password" required>
        <input type="email" name="email" placeholder="Email" required>
        <input type="text" name="phoneNumber" placeholder="Phone Number" required>
        <button type="submit">Register</button>
    </form>

    <a href="login.jsp">Back to Login</a>
</div>

</body>
</html>
