import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class UpdatePasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userIDParam = request.getParameter("userID");
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        String message = "";
        String messageType = "error";
        
        // Validate inputs
        if (userIDParam == null || token == null || newPassword == null || confirmPassword == null) {
            message = "Missing required parameters.";
            request.setAttribute("message", message);
            request.setAttribute("messageType", messageType);
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
            rd.forward(request, response);
            return;
        }
        
        int userID = Integer.parseInt(userIDParam);
        
        // Validate passwords match
        if (!newPassword.equals(confirmPassword)) {
            message = "Passwords do not match!";
            request.setAttribute("message", message);
            request.setAttribute("messageType", messageType);
            RequestDispatcher rd = request.getRequestDispatcher("resetPassword.jsp?token=" + token + "&userID=" + userID);
            rd.forward(request, response);
            return;
        }
        
        // Validate password length (max 8 characters as per your table)
        if (newPassword.length() < 6 || newPassword.length() > 8) {
            message = "Password must be between 6 and 8 characters long!";
            request.setAttribute("message", message);
            request.setAttribute("messageType", messageType);
            RequestDispatcher rd = request.getRequestDispatcher("resetPassword.jsp?token=" + token + "&userID=" + userID);
            rd.forward(request, response);
            return;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/dassystem";
            String dbUsername = "root";
            String dbPassword = "admin";
            
            conn = DriverManager.getConnection(url, dbUsername, dbPassword);
            
            // Verify token again
            String verifySql = "SELECT * FROM password_resets WHERE userID = ? AND token = ? AND expiry_time > NOW()";
            pstmt = conn.prepareStatement(verifySql);
            pstmt.setInt(1, userID);
            pstmt.setString(2, token);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                // Update password in customer table
                String updateSql = "UPDATE customer SET password = ? WHERE userID = ?";
                PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                updateStmt.setString(1, newPassword);
                updateStmt.setInt(2, userID);
                int rowsUpdated = updateStmt.executeUpdate();
                updateStmt.close();
                
                if (rowsUpdated > 0) {
                    // Delete used reset token
                    String deleteSql = "DELETE FROM password_resets WHERE userID = ?";
                    PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
                    deleteStmt.setInt(1, userID);
                    deleteStmt.executeUpdate();
                    deleteStmt.close();
                    
                    message = "Password has been reset successfully! Please login with your new password.";
                    messageType = "success";
                    request.setAttribute("message", message);
                    request.setAttribute("messageType", messageType);
                    RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
                    rd.forward(request, response);
                    return;
                } else {
                    message = "Failed to update password. Please try again.";
                }
            } else {
                message = "Invalid or expired reset link. Please request a new password reset.";
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            message = "Database error occurred: " + e.getMessage();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {}
        }
        
        request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);
        RequestDispatcher rd = request.getRequestDispatcher("resetPassword.jsp?token=" + token + "&userID=" + userID);
        rd.forward(request, response);
    }
}
