<%@page import="java.util.Map"%>
<%
    String error = "";

    if(request.getMethod().equalsIgnoreCase("POST")) {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String roleInput = request.getParameter("role"); // ? role dari dropdown

        boolean validUser = false;
        String role = "";

        // default admin
        if("admin".equals(username) && "1234".equals(password)) {
            validUser = true;
            role = "Store Manager";
        }

        // registered user
        Map user = (Map) session.getAttribute("registeredUser");

        if(user != null) {
            String regUser = (String) user.get("username");
            String regPass = (String) user.get("password");
            String regRole = (String) user.get("role");

            if(username.equals(regUser) && password.equals(regPass) && roleInput.equals(regRole)) {
                validUser = true;
                role = regRole;
            }
        }

        if(validUser) {
            session.setAttribute("role", role);
            response.sendRedirect("report.jsp");
            return;
        } else {
            error = "Invalid username, password or role!";
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<div class="container">
    <h2>LOGIN - DAS COFFEE</h2>

    <form method="post">

        <input type="text" name="username" placeholder="Username" required>
        <input type="password" name="password" placeholder="Password" required>

        <select name="role" required>
            <option value="">-- Select Role --</option>
            <option value="Store Manager">Store Manager</option>
            <option value="Customer">Customer</option>
            <option value="Cashier">Cashier</option>
             <option value="Barista">Barista</option>


        </select>

        <button type="submit">LOGIN</button>

        <p class="error"><%= error %></p>
    </form>

    <a href="forgot.jsp">Forgot Password?</a>
    <a href="register.jsp">Register</a>
</div>

</body>
</html>