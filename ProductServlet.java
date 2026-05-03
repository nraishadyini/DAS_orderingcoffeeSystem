import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

public class ProductServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dassystem", "root", "admin");
            
            String sql = "SELECT productID, productName, price, size FROM product WHERE availability_status = 'Available' ORDER BY productName";
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            
            // Generate HTML directly
            while(rs.next()) {
                String name = rs.getString("productName");
                double price = rs.getDouble("price");
                String size = rs.getString("size");
                
                // Determine icon
                String icon = "☕";
                if(name.toLowerCase().contains("tea")) icon = "🍵";
                
                out.println("<div class='card'>");
                out.println("<div class='card-icon'>" + icon + "</div>");
                out.println("<div class='card-info'>");
                out.println("<div class='card-name'>" + name + "</div>");
                out.println("<div class='card-price'>RM " + String.format("%.2f", price) + "</div>");
                out.println("<div class='card-size'>" + size + "</div>");
                out.println("</div></div>");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>Error loading products</p>");
        } finally {
            try {
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
                if(conn != null) conn.close();
            } catch(SQLException e) {}
        }
        
        out.flush();
    }
}
