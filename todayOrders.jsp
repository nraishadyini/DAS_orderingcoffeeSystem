<%@ page import="java.sql.*" %>

<%
    if(session.getAttribute("role") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection con = DBConnection.getConnection();

    String sql = "SELECT o.orderID, c.username, o.orderStatus, o.orderTime " +
                 "FROM orders o " +
                 "JOIN customer c ON o.userID = c.userID " +
                 "WHERE o.orderDate = CURDATE()";

    PreparedStatement ps = con.prepareStatement(sql);
    ResultSet rs = ps.executeQuery();
%>

<h2>Today's Orders</h2>

<table border="1" cellpadding="10">
<tr>
    <th>Order ID</th>
    <th>Customer</th>
    <th>Status</th>
    <th>Time</th>
</tr>

<%
while(rs.next()){
%>
<tr>
    <td><%= rs.getInt("orderID") %></td>
    <td><%= rs.getString("username") %></td>
    <td><%= rs.getString("orderStatus") %></td>
    <td><%= rs.getString("orderTime") %></td>
</tr>
<%
}
%>
</table>