<%@ page import="java.util.*" %>

<%
    // Check login
    if(session.getAttribute("username") == null ||
       !"customer".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = (String) session.getAttribute("username");

    // Get cart from session
    List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");

    if(cart == null) {
        cart = new ArrayList<>();
        session.setAttribute("cart", cart);
    }

    double total = 0;
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Cart</title>
    <meta charset="UTF-8">

    <style>
        body {
            font-family: Arial;
            background: #3e2723;
            margin: 0;
            color: white;
        }

        .header {
            background: #4e342e;
            padding: 15px;
            display: flex;
            justify-content: space-between;
        }

        .container {
            max-width: 1000px;
            margin: 30px auto;
            background: #efebe9;
            color: #3e2723;
            padding: 20px;
            border-radius: 10px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px;
            border-bottom: 1px solid #ccc;
            text-align: center;
        }

        th {
            background: #6d4c41;
            color: white;
        }

        .btn {
            padding: 6px 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .remove {
            background: #c62828;
            color: white;
        }

        .checkout {
            background: green;
            color: white;
            padding: 10px 15px;
            margin-top: 15px;
            display: inline-block;
            text-decoration: none;
            border-radius: 5px;
        }

        .empty {
            text-align: center;
            padding: 40px;
        }
    </style>
</head>

<body>

<div class="header">
    <h2>? My Cart</h2>
    <a href="customerDashboard.jsp" style="color:white;">Back</a>
</div>

<div class="container">

<%
    if(cart.isEmpty()) {
%>
        <div class="empty">
            <h3>Your cart is empty ?</h3>
            <p>Go add some delicious coffee!</p>
        </div>
<%
    } else {
%>

<table>
    <tr>
        <th>Product</th>
        <th>Price (RM)</th>
        <th>Quantity</th>
        <th>Total</th>
        <th>Action</th>
    </tr>

<%
        for(Map<String, Object> item : cart) {
            String name = (String) item.get("name");
            double price = (double) item.get("price");
            int qty = (int) item.get("qty");

            double subTotal = price * qty;
            total += subTotal;
%>

    <tr>
        <td><%= name %></td>
        <td><%= price %></td>
        <td><%= qty %></td>
        <td><%= String.format("%.2f", subTotal) %></td>
        <td>
            <form action="RemoveFromCartServlet" method="post">
                <input type="hidden" name="name" value="<%= name %>">
                <button class="btn remove">Remove</button>
            </form>
        </td>
    </tr>

<%
        }
%>

</table>

<h3 style="margin-top:20px;">
    Grand Total: RM <%= String.format("%.2f", total) %>
</h3>

<a href="checkout.jsp" class="checkout">Proceed to Checkout</a>

<%
    }
%>

</div>

</body>
</html>