<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Pending Orders - Barista</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #3e2723;
            margin: 0;
            padding: 20px;
        }
        .container {
            background: #efebe9;
            border-radius: 12px;
            padding: 30px;
            max-width: 900px;
            margin: 0 auto;
        }
        h2 {
            color: #4e342e;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border: 1px solid #ddd;
        }
        th {
            background: #6d4c41;
            color: white;
        }
        .back-btn {
            display: inline-block;
            margin-top: 20px;
            background: #8d6e63;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 8px;
        }
        button {
            background: #4caf50;
            color: white;
            border: none;
            padding: 5px 15px;
            border-radius: 5px;
            cursor: pointer;
        }
        .success {
            background: #d4edda;
            color: #155724;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .error {
            background: #f8d7da;
            color: #721c24;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Pending Orders</h2>
    
    <%
        if(session.getAttribute("username") == null || 
           !"barista".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Display messages
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        if(success != null) {
            out.println("<div class='success'>" + success + "</div>");
        }
        if(error != null) {
            out.println("<div class='error'>Error: " + error + "</div>");
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            // Register JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Get connection
            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/dassystem", 
                "root", 
                "admin"
            );
            
            // Updated query to match your table structure
            String sql = "SELECT o.orderID, o.orderDate, o.orderTime, o.orderStatus, c.username " +
                         "FROM orders o " +
                         "INNER JOIN customer c ON o.userID = c.userID " +
                         "WHERE o.orderStatus = 'PENDING' " +
                         "ORDER BY o.orderDate DESC, o.orderTime DESC";
            
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
    %>
    
    <table border="1" cellpadding="10">
        <tr>
            <th>Order ID</th>
            <th>Customer</th>
            <th>Date</th>
            <th>Time</th>
            <th>Status</th>
            <th>Action</th>
        </tr>
        
        <%
            boolean hasOrders = false;
            while(rs.next()) {
                hasOrders = true;
        %>
        <tr>
            <td><%= rs.getInt("orderID") %></td>
            <td><%= rs.getString("username") != null ? rs.getString("username") : "N/A" %></td>
            <td><%= rs.getDate("orderDate") != null ? rs.getDate("orderDate") : "N/A" %></td>
            <td><%= rs.getString("orderTime") != null ? rs.getString("orderTime") : "N/A" %></td>
            <td><%= rs.getString("orderStatus") != null ? rs.getString("orderStatus") : "PENDING" %></td>
            <td>
                <form action="updateOrderStatus.jsp" method="post" onsubmit="return confirm('Mark order #<%= rs.getInt("orderID") %> as completed?')">
                    <input type="hidden" name="orderID" value="<%= rs.getInt("orderID") %>">
                    <button type="submit">Complete Order</button>
                </form>
            </td>
         </tr>
        <%
            }
            if(!hasOrders) {
        %>
         <tr>
            <td colspan="6" style="text-align: center; padding: 20px;">
                No pending orders found. All orders are completed!
            </td>
         </tr>
        <%
            }
        } catch (ClassNotFoundException e) {
            out.println("<div class='error'>MySQL Driver not found: " + e.getMessage() + "</div>");
            e.printStackTrace();
        } catch (SQLException e) {
            out.println("<div class='error'>Database error: " + e.getMessage() + "</div>");
            e.printStackTrace();
        } finally {
            // Close resources
            if(rs != null) try { rs.close(); } catch(Exception e) {}
            if(ps != null) try { ps.close(); } catch(Exception e) {}
            if(con != null) try { con.close(); } catch(Exception e) {}
        }
        %>
    </table>
    
    <br>
    <a href="baristaDashboard.jsp" class="back-btn">Back to Dashboard</a>
</div>
</body>
</html>
