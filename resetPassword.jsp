<%@ page import="java.sql.*" %>
<%
    String token = request.getParameter("token");
    String userIDParam = request.getParameter("userID");
    String message = "";
    String messageType = "error";
    boolean isValidToken = false;
    String username = "";
    int userID = 0;
    
    if (token != null && userIDParam != null && !token.isEmpty() && !userIDParam.isEmpty()) {
        try {
            userID = Integer.parseInt(userIDParam);
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/dassystem";
                String dbUsername = "root";
                String dbPassword = "admin";
                
                conn = DriverManager.getConnection(url, dbUsername, dbPassword);
                
                // Verify token with userID and expiry time
                String sql = "SELECT pr.*, c.username FROM password_resets pr " +
                            "JOIN customer c ON pr.userID = c.userID " +
                            "WHERE pr.userID = ? AND pr.token = ? AND pr.expiry_time > NOW()";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, userID);
                pstmt.setString(2, token);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    isValidToken = true;
                    username = rs.getString("username");
                    message = "Please enter your new password below for user: " + username;
                    messageType = "success";
                } else {
                    message = "Invalid or expired reset link. Please request a new password reset.";
                    messageType = "error";
                }
                
            } catch (Exception e) {
                e.printStackTrace();
                message = "Database error occurred: " + e.getMessage();
                messageType = "error";
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {}
            }
        } catch (NumberFormatException e) {
            message = "Invalid user ID format.";
            messageType = "error";
        }
    } else {
        message = "Invalid reset link. Please request a new password reset.";
        messageType = "error";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Reset Password - Coffee Shop</title>
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
            margin-bottom: 20px;
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
        
        .password-requirements {
            font-size: 12px;
            color: #6c757d;
            text-align: left;
            margin-top: 5px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>? Reset Password</h2>
    
    <div class="message <%= messageType %>">
        <%= message %>
    </div>
    
    <% if (isValidToken) { %>
        <form action="UpdatePasswordServlet" method="post">
            <input type="hidden" name="userID" value="<%= userID %>">
            <input type="hidden" name="token" value="<%= token %>">
            <input type="password" name="newPassword" placeholder="New Password" required>
            <input type="password" name="confirmPassword" placeholder="Confirm New Password" required>
            <div class="password-requirements">
                ?? Password must be at least 6 characters long
            </div>
            <button type="submit">Update Password</button>
        </form>
    <% } %>
    
    <a href="login.jsp">? Back to Login</a>
</div>

</body>
</html>
