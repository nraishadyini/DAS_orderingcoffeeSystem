<%@ page import="java.sql.*" %>

<%
    String orderID = request.getParameter("orderID");

    if(orderID != null) {
        Connection con = DBConnection.getConnection();

        String sql = "UPDATE orders SET orderStatus='COMPLETED' WHERE orderID=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, orderID);

        ps.executeUpdate();

        response.sendRedirect("viewPendingOrders.jsp");
    }
%>