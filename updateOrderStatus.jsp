<%@ page import="java.sql.*" %>
<%
    String orderID = request.getParameter("orderID");

    if(orderID != null && !orderID.trim().isEmpty()) {
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            // Register JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Get connection
            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/dassystem", 
                "root", 
                "admin"
            );
            
            // Update order status to COMPLETED
            String sql = "UPDATE orders SET orderStatus='COMPLETED' WHERE orderID=? AND orderStatus='PENDING'";
            ps = con.prepareStatement(sql);
            ps.setString(1, orderID);
            int updated = ps.executeUpdate();
            
            if(updated > 0) {
                response.sendRedirect("viewPendingOrders.jsp?success=Order+%23" + orderID + "+has+been+completed!");
            } else {
                response.sendRedirect("viewPendingOrders.jsp?error=Order+%23" + orderID + "+not+found+or+already+completed");
            }
        } catch (Exception e) {
            response.sendRedirect("viewPendingOrders.jsp?error=" + e.getMessage().replace(" ", "+"));
        } finally {
            if(ps != null) try { ps.close(); } catch(Exception e) {}
            if(con != null) try { con.close(); } catch(Exception e) {}
        }
    } else {
        response.sendRedirect("viewPendingOrders.jsp?error=Invalid+order+ID");
    }
%>
