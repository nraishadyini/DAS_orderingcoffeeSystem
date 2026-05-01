/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role"); // Add role selection

        // Default error message
        String errorMessage = "Invalid username or password!";
        
        // Check based on role
        if (role != null) {
            switch(role) {
                case "manager":
                    // Manager credentials (hardcoded)
                    if(username.equals("admin") && password.equals("1234")) {
                        HttpSession session = request.getSession();
                        session.setAttribute("username", username);
                        session.setAttribute("role", "manager");
                        session.setAttribute("fullname", "Store Manager");
                        response.sendRedirect("managerDashboard.jsp");
                        return;
                    } else {
                        errorMessage = "Invalid manager credentials!";
                    }
                    break;
                    
                case "cashier":
                    // Cashier credentials (hardcoded)
                    if(username.equals("cashier1") && password.equals("cashier123")) {
                        HttpSession session = request.getSession();
                        session.setAttribute("username", username);
                        session.setAttribute("role", "cashier");
                        session.setAttribute("fullname", "Cashier");
                        response.sendRedirect("cashierDashboard.jsp");
                        return;
                    } else if(username.equals("cashier2") && password.equals("cashier456")) {
                        HttpSession session = request.getSession();
                        session.setAttribute("username", username);
                        session.setAttribute("role", "cashier");
                        session.setAttribute("fullname", "Cashier");
                        response.sendRedirect("cashierDashboard.jsp");
                        return;
                    } else {
                        errorMessage = "Invalid cashier credentials!";
                    }
                    break;
                    
                case "barista":
                    // Barista credentials (hardcoded)
                    if(username.equals("barista1") && password.equals("barista123")) {
                        HttpSession session = request.getSession();
                        session.setAttribute("username", username);
                        session.setAttribute("role", "barista");
                        session.setAttribute("fullname", "Barista");
                        response.sendRedirect("baristaDashboard.jsp");
                        return;
                    } else if(username.equals("barista2") && password.equals("barista456")) {
                        HttpSession session = request.getSession();
                        session.setAttribute("username", username);
                        session.setAttribute("role", "barista");
                        session.setAttribute("fullname", "Barista");
                        response.sendRedirect("baristaDashboard.jsp");
                        return;
                    } else {
                        errorMessage = "Invalid barista credentials!";
                    }
                    break;
                    
                case "customer":
                    // Customer - check from database
                    if(validateCustomer(username, password)) {
                        HttpSession session = request.getSession();
                        session.setAttribute("username", username);
                        session.setAttribute("role", "customer");
                        
                        // Get customer details
                        Customer customer = getCustomerDetails(username);
                        session.setAttribute("customer", customer);
                        session.setAttribute("fullname", customer != null ? customer.getUsername() : username);
                        
                        response.sendRedirect("customerDashboard.jsp");
                        return;
                    } else {
                        errorMessage = "Invalid customer credentials!";
                    }
                    break;
                    
                default:
                    errorMessage = "Invalid role selected!";
                    break;
            }
        } else {
            errorMessage = "Please select a role!";
        }
        
        // If login fails
        request.setAttribute("error", errorMessage);
        RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
        rd.forward(request, response);
    }
    
    // Method to validate customer from database
    private boolean validateCustomer(String username, String password) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dassystem", "root", "admin");
            
            String sql = "SELECT * FROM customer WHERE username = ? AND password = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            rs = pstmt.executeQuery();
            
            return rs.next(); // Returns true if customer exists
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    // Method to get customer details
    private Customer getCustomerDetails(String username) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Customer customer = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dassystem", "root", "admin");
            
            String sql = "SELECT * FROM customer WHERE username = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                customer = new Customer();
                customer.setId(rs.getInt("id"));
                customer.setUsername(rs.getString("username"));
                customer.setEmail(rs.getString("email"));
                customer.setPhoneNumber(rs.getString("phoneNumber"));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return customer;
    }
}
