<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Today's Orders</title>
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
        .completed {
            color: #4caf50;
            font-weight: bold;
        }
        .pending {
            color: #ff9800;
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Today's Orders (<%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()) %>)</h2>
    
    <%
        if(session.getAttribute("role") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/dassystem", "root", "admin"
            );

            // Query for today's orders
            String sql = "SELECT o.orderID, c.username, o.orderStatus, o.orderTime " +
                         "FROM orders o " +
                         "INNER JOIN customer c ON o.userID = c.userID " +
                         "WHERE o.orderDate = CURDATE() " +
                         "ORDER BY o.orderTime DESC";
            
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
    %>
    
    <table border="1" cellpadding="10">
        <tr>
            <th>Order ID</th>
            <th>Customer</th>
            <th>Status</th>
            <th>Time</th>
         </tr>
        
        <%
            boolean hasOrders = false;
            while(rs.next()){
                hasOrders = true;
                String status = rs.getString("orderStatus");
                String statusClass = "COMPLETED".equals(status) ? "completed" : "pending";
        %>
         <tr>
             <td><%= rs.getInt("orderID") %></td>
             <td><%= rs.getString("username") %></td>
             <td class="<%= statusClass %>"><%= status %></td>
             <td><%= rs.getString("orderTime") %></td>
         </tr>
        <%
            }
            if(!hasOrders) {
        %>
         <tr>
            <td colspan="4" style="text-align: center;">No orders placed today</td>
         </tr>
        <%
            }
        } catch(Exception e) {
            out.println("<div style='color:red; padding:10px; background:#fff; border-radius:5px;'>Error: " + e.getMessage() + "</div>");
            e.printStackTrace();
        } finally {
            if(rs != null) try { rs.close(); } catch(Exception e) {}
            if(ps != null) try { ps.close(); } catch(Exception e) {}
            if(con != null) try { con.close(); } catch(Exception e) {}
        }
        %>
    </table>
    
    <a href="baristaDashboard.jsp" class="back-btn">Back to Dashboard</a>
</div>
</body>
</html>
