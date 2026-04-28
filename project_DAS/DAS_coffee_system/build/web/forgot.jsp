<%
    String msg = "";

    if(request.getMethod().equalsIgnoreCase("POST")) {
        String username = request.getParameter("username");
        msg = "Password reset link sent for " + username;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<div class="container">
    <h2>Forgot Password</h2>

    <form method="post">
        <input type="text" name="username" placeholder="Enter Username" required>

        <button type="submit">Recover</button>
    </form>

    <p><%= msg %></p>

    <a href="login.jsp">Back</a>
</div>

</body>
</html>