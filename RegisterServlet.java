import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            // Load MySQL Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Database connection - VERIFY these credentials!
            String url = "jdbc:mysql://localhost:3306/dassystem";
            String dbUsername = "root";
            String dbPassword = "admin"; // Change this to your actual MySQL password
            
            conn = DriverManager.getConnection(url, dbUsername, dbPassword);
            
            // SQL Insert
            String sql = "INSERT INTO customer (username, password, email, phoneNumber) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            pstmt.setString(3, email);
            pstmt.setString(4, phoneNumber);
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                // Success - redirect to login page
                response.sendRedirect("login.jsp?success=Registration successful! Please login.");
            } else {
                // Failed
                response.sendRedirect("register.jsp?error=Registration failed. Please try again.");
            }
            
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=Database driver not found. Please contact support.");
            
        } catch (SQLException e) {
            e.printStackTrace();
            
            // Check for duplicate entry error
            if (e.getMessage().contains("Duplicate entry")) {
                response.sendRedirect("register.jsp?error=Username or email already exists!");
            } else {
                response.sendRedirect("register.jsp?error=Database error: " + e.getMessage());
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=An unexpected error occurred: " + e.getMessage());
            
        } finally {
            // Close resources
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
