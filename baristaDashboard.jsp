<%-- 
    Document   : baristaDashboard
    Created on : May 1, 2026, 2:59:30?PM
    Author     : auni
--%>
<!DOCTYPE html>
<html>
<head>
    <title>Barista Dashboard</title>
    
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
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
        }
        
        h2 {
            color: #4e342e;
        }
        
        .welcome {
            background: #6d4c41;
            color: white;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .menu {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }
        
        .menu-item {
            background: #d7ccc8;
            padding: 25px;
            text-align: center;
            border-radius: 8px;
            text-decoration: none;
            color: #3e2723;
            transition: transform 0.2s;
            display: block;
        }
        
        .menu-item:hover {
            transform: translateY(-5px);
            background: #bcaaa4;
        }
        
        .logout {
            background: #8d6e63;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 8px;
            display: inline-block;
            margin-top: 20px;
        }
        
        .order-list {
            background: #d7ccc8;
            padding: 15px;
            border-radius: 8px;
            margin-top: 20px;
        }
        
        .order-item {
            background: white;
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .complete-btn {
            background: #4caf50;
            color: white;
            border: none;
            padding: 5px 15px;
            border-radius: 5px;
            cursor: pointer;
        }        
    </style>
</head>
<body>

<div class="container">
    <%
        if(session.getAttribute("username") == null || 
           !"barista".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String username = (String) session.getAttribute("username");
    %>
    
    <div class="welcome">
        <h2>Welcome, <%= username %>!</h2>
        <p>Barista Dashboard</p>
    </div>
    
    <div class="menu">
        <a href="viewPendingOrders.jsp" class="menu-item">
            <h3>? Pending Orders</h3>
            <p>View and prepare drinks</p>
        </a>
        <a href="updateOrderStatus.jsp" class="menu-item">
            <h3>? Update Status</h3>
            <p>Mark orders as complete</p>
        </a>
        <a href="todayOrders.jsp" class="menu-item">
            <h3>? Today's Orders</h3>
            <p>View all orders for today</p>
        </a>
        
    </div>
    
    
    </div>
    
    <a href="logout.jsp" class="logout">Logout</a>
</div>

<script>
    function completeOrder(orderId) {
        alert("Order #" + orderId + " marked as complete!");
        // Add actual order completion logic here
    }
</script>

</body>
</html>
