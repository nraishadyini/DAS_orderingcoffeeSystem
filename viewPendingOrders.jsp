<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
    if(session.getAttribute("username") == null || 
       !"barista".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection con = DBConnection.getConnection();

    String sql = "SELECT o.orderID, o.orderDate, o.orderTime, c.username " +
                 "FROM orders o " +
                 "JOIN customer c ON o.userID = c.userID " +
                 "WHERE o.orderStatus = 'PENDING'";

    PreparedStatement ps = con.prepareStatement(sql);
    ResultSet rs = ps.executeQuery();
%>

<h2>Pending Orders</h2>

<table border="1" cellpadding="10">
<tr>
    <th>Order ID</th>
    <th>Customer</th>
    <th>Date</th>
    <th>Time</th>
    <th>Action</th>
</tr>

<%
while(rs.next()){
%>
<tr>
    <td><%= rs.getInt("orderID") %></td>
    <td><%= rs.getString("username") %></td>
    <td><%= rs.getDate("orderDate") %></td>
    <td><%= rs.getString("orderTime") %></td>
    <td>
        <a href="updateOrderStatus.jsp?orderID=<%= rs.getInt("orderID") %>">
            Start Prepare
        </a>
    </td>
</tr>
<%
}
%>
</table>