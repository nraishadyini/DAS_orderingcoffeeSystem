<%-- 
    Document   : login
    Created on : Apr 29, 2026, 7:07:49?AM
    Author     : auni
--%>

<!DOCTYPE html>
<html>
<head>
    <title>Login - Coffee Shop System</title>
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
            width: 350px;
            text-align: center;
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
        }

        h2 {
            color: #4e342e;
            margin-bottom: 20px;
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

        .error {
            color: red;
            font-size: 14px;
            margin-top: 10px;
            padding: 8px;
            background: #ffebee;
            border-radius: 5px;
        }
        
        .success {
            color: green;
            font-size: 14px;
            margin-top: 10px;
            padding: 8px;
            background: #e8f5e9;
            border-radius: 5px;
        }
        
        .role-selector {
            margin-bottom: 15px;
            text-align: left;
        }
        
        label {
            display: block;
            margin-bottom: 5px;
            color: #4e342e;
            font-weight: bold;
        }
        
        hr {
            margin: 15px 0;
            border: 1px solid #d7ccc8;
        }
        
        .credentials-info {
            font-size: 12px;
            color: #6d4c41;
            text-align: left;
            margin-top: 15px;
            padding: 10px;
            background: #d7ccc8;
            border-radius: 8px;
        }
        
        .credentials-info p {
            margin: 5px 0;
        }
        
        /* New style for forgot password link */
        .forgot-password {
            margin-top: 10px;
            text-align: right;
        }
        
        .forgot-password a {
            display: inline;
            font-size: 12px;
            color: #6d4c41;
            margin-top: 0;
        }
        
        .forgot-password a:hover {
            color: #3e2723;
            text-decoration: underline;
        }
        
        .links-container {
            margin-top: 20px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>☕ Coffee Shop System</h2>
    <h3>Login</h3>
    
    <form action="LoginServlet" method="post">
        <div class="role-selector">
            <label>Login As:</label>
            <select name="role" required>
                <option value="">Select Role</option>
                <option value="customer">Customer</option>
                <option value="manager">Store Manager</option>
                <option value="cashier">Cashier</option>
                <option value="barista">Barista</option>
            </select>
        </div>
        
        <input type="text" name="username" placeholder="Username" required>
        <input type="password" name="password" placeholder="Password" required>
        
        <!-- Forgot Password Link -->
        <div class="forgot-password">
            <a href="forgot.jsp">Forgot Password?</a>
        </div>
        
        <button type="submit">Login</button>
    </form>
    
    <% if(request.getParameter("success") != null) { %>
        <div class="success">
            <%= request.getParameter("success") %>
        </div>
    <% } %>
    
    <% if(request.getAttribute("error") != null) { %>
        <div class="error">
            <%= request.getAttribute("error") %>
        </div>
    <% } %>
    
    <hr>
    
    <div class="links-container">
        <a href="register.jsp">🆕 New Customer? Register here</a>
    </div>
    
    <!-- Optional: Show test credentials for staff -->
    <div class="credentials-info">
        <strong>📋 Staff Test Credentials:</strong>
        <p>👔 Manager: admin / 1234</p>
        <p>💰 Cashier: cashier1 / cashier123 or cashier2 / cashier456</p>
        <p>☕ Barista: barista1 / barista123 or barista2 / barista456</p>
        <p>👤 Customer: Register first, then login</p>
        <p>🔐 <a href="forgot.jsp" style="display: inline; font-size: 11px;">Forgot your password?</a></p>
    </div>
</div>

</body>
</html>
