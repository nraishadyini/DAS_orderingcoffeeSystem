import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class UpdateOrderStatusServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String orderID = request.getParameter("orderID");
        String status = request.getParameter("status");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dassystem", "root", "admin");
            
            String sql = "UPDATE orders SET orderStatus = ? WHERE orderID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setInt(2, Integer.parseInt(orderID));
            pstmt.executeUpdate();
            
            response.sendRedirect("baristaDashboard.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("baristaDashboard.jsp?error=" + e.getMessage());
        } finally {
            try {
                if(pstmt != null) pstmt.close();
                if(conn != null) conn.close();
            } catch(SQLException e) {}
        }
    }
}
