<%-- 
    Document   : managerDashboard
    Created on : Apr 29, 2026, 7:08:15?AM
    Author     : auni
--%>

<!DOCTYPE html>
<html>
<head>
    <title>Manager Dashboard</title>
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
            transition: transform 0.2s, box-shadow 0.2s;
            display: block;
        }
        
        .menu-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            background: #bcaaa4;
        }
        
        .menu-item h3 {
            margin: 0 0 10px 0;
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
        
        .logout:hover {
            background: #5d4037;
        }
    </style>
</head>
<body>

<div class="container">
    <%
        // Check if manager is logged in
        if(session.getAttribute("username") == null || 
           !"manager".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String username = (String) session.getAttribute("username");
        String fullname = (String) session.getAttribute("fullname");
    %>
    
    <div class="welcome">
        <h2>Welcome, <%= username %>!</h2>
        <p><%= fullname %> Dashboard</p>
    </div>
    
    <div class="menu">
        <a href="manageProducts.jsp" class="menu-item">
            <h3>? Manage Products</h3>
            <p>Add, edit, or remove products</p>
        </a>
        <a href="viewCustomers.jsp" class="menu-item">
            <h3>? View Customers</h3>
            <p>View registered customers</p>
        </a>
        <a href="viewOrders.jsp" class="menu-item">
            <h3>? View Orders</h3>
            <p>Manage customer orders</p>
        </a>
        <a href="reports.jsp" class="menu-item">
            <h3>? Reports</h3>
            <p>View sales and inventory reports</p>
        </a>
        <a href="manageStaff.jsp" class="menu-item">
            <h3>? Manage Staff</h3>
            <p>Manage cashiers and baristas</p>
        </a>
    </div>
    
    <a href="logout.jsp" class="logout">Logout</a>
</div>

</body>
</html>
