import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class ForgotServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String message = "";
        String messageType = "error";
        
        if (username == null || username.trim().isEmpty()) {
            message = "Please enter your username!";
            request.setAttribute("message", message);
            request.setAttribute("messageType", messageType);
            RequestDispatcher rd = request.getRequestDispatcher("forgot.jsp");
            rd.forward(request, response);
            return;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            // Load MySQL Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Database connection
            String url = "jdbc:mysql://localhost:3306/dassystem";
            String dbUsername = "root";
            String dbPassword = "admin";
            
            conn = DriverManager.getConnection(url, dbUsername, dbPassword);
            
            // Get userID and email from customer table
            String getCustomerSql = "SELECT userID, email, username FROM customer WHERE username = ?";
            pstmt = conn.prepareStatement(getCustomerSql);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                int userID = rs.getInt("userID");
                String email = rs.getString("email");
                String foundUsername = rs.getString("username");
                String resetToken = generateResetToken();
                
                // Save reset token to database
                saveResetToken(conn, userID, resetToken);
                
                // Generate reset link (using userID instead of username)
                String resetLink = "resetPassword.jsp?token=" + resetToken + "&userID=" + userID;
                
                message = "Password reset link has been generated! ";
                message += "<br><strong>Demo Link:</strong> <a href='" + resetLink + "'>Click here to reset password</a>";
                message += "<br><br><em>(In production, this link would be sent to: " + email + ")</em>";
                message += "<br><br><strong>User Info:</strong> " + foundUsername + " (ID: " + userID + ")";
                messageType = "success";
                
                // For debugging - print to console
                System.out.println("=========================================");
                System.out.println("Password Reset Request:");
                System.out.println("Username: " + foundUsername);
                System.out.println("User ID: " + userID);
                System.out.println("Email: " + email);
                System.out.println("Reset Token: " + resetToken);
                System.out.println("Reset Link: " + resetLink);
                System.out.println("=========================================");
                
            } else {
                // Check if username exists in staff accounts
                if (checkStaffExists(username)) {
                    message = "Staff accounts (Manager/Cashier/Barista) cannot reset password online. Please contact the system administrator.";
                    messageType = "error";
                } else {
                    message = "Username '" + username + "' not found in our system!";
                    messageType = "error";
                }
            }
            
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            message = "Database driver not found. Please contact support.";
            messageType = "error";
            
        } catch (SQLException e) {
            e.printStackTrace();
            message = "Database error occurred: " + e.getMessage();
            messageType = "error";
            
        } catch (Exception e) {
            e.printStackTrace();
            message = "An unexpected error occurred: " + e.getMessage();
            messageType = "error";
            
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        // Set attributes and forward to forgot.jsp
        request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);
        RequestDispatcher rd = request.getRequestDispatcher("forgot.jsp");
        rd.forward(request, response);
    }
    
    // Generate random reset token
    private String generateResetToken() {
        return java.util.UUID.randomUUID().toString() + System.currentTimeMillis();
    }
    
    // Save reset token to database
    private void saveResetToken(Connection conn, int userID, String token) throws SQLException {
        // First, delete any existing tokens for this user
        String deleteSql = "DELETE FROM password_resets WHERE userID = ?";
        PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
        deleteStmt.setInt(1, userID);
        deleteStmt.executeUpdate();
        deleteStmt.close();
        
        // Insert new token with expiry (1 hour from now)
        String insertSql = "INSERT INTO password_resets (userID, token, expiry_time) VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 1 HOUR))";
        PreparedStatement insertStmt = conn.prepareStatement(insertSql);
        insertStmt.setInt(1, userID);
        insertStmt.setString(2, token);
        insertStmt.executeUpdate();
        insertStmt.close();
        
        System.out.println("Reset token saved for userID: " + userID);
    }
    
    // Check if username exists in staff (hardcoded for demo)
    private boolean checkStaffExists(String username) {
        // Manager accounts
        if (username.equals("admin")) return true;
        
        // Cashier accounts
        if (username.equals("cashier1") || username.equals("cashier2")) return true;
        
        // Barista accounts
        if (username.equals("barista1") || username.equals("barista2")) return true;
        
        return false;
    }
}
