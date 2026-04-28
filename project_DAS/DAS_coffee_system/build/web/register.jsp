<%@ page import="java.util.*" %>
<%
    String message = "";

    if(request.getMethod().equalsIgnoreCase("POST")) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // Simpan dalam session (fake database)
        Map<String, String> user = new HashMap<>();
        user.put("username", username);
        user.put("password", password);
        user.put("role", role);

        session.setAttribute("registeredUser", user);

        message = "User registered successfully as " + role;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<div class="container">
    <h2>Register</h2>

    <form method="post">

        <select name="role" required>
            <option value="">-- Select Role --</option>
            <option>Barista</option>
            <option>Cashier</option>
            <option>Customer</option>
            <option>Store manager</option>

        </select>

        <input type="text" name="username" placeholder="Username" required>
        <input type="password" name="password" placeholder="Password" required>

        <button type="submit">Register</button>
    </form>

    <p><%= message %></p>

    <a href="login.jsp">Back to Login</a>
</div>

</body>
</html>