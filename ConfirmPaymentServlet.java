import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

public class ConfirmPaymentServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String orderID = request.getParameter("orderID");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dassystem", "root", "admin");
            conn.setAutoCommit(false);
            
            // Update order status to Completed
            String updateOrderSQL = "UPDATE orders SET orderStatus = 'Completed' WHERE orderID = ?";
            pstmt = conn.prepareStatement(updateOrderSQL);
            pstmt.setInt(1, Integer.parseInt(orderID));
            pstmt.executeUpdate();
            pstmt.close();
            
            // Update payment status if exists
            String updatePaymentSQL = "UPDATE payment SET paymentStatus = 'Completed' WHERE orderID = ?";
            pstmt = conn.prepareStatement(updatePaymentSQL);
            pstmt.setInt(1, Integer.parseInt(orderID));
            pstmt.executeUpdate();
            
            conn.commit();
            
            out.print("{\"success\":true}");
            
        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {}
            e.printStackTrace();
            out.print("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {}
        }
        
        out.flush();
    }
}
