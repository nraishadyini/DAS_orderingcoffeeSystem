<%-- 
    Document   : logout
    Created on : May 1, 2026, 2:59:55?PM
    Author     : auni
--%>
<%
    session.invalidate();
    response.sendRedirect("login.jsp");
%>
