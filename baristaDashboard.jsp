<%-- 
    Document   : baristaDashboard
    Created on : May 1, 2026, 2:59:30?PM
    Author     : auni
--%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Barista Dashboard - Coffee Shop</title>
    <meta charset="UTF-8">
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
            max-width: 1200px;
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
        
        /* Tabs */
        .tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            border-bottom: 2px solid #d7ccc8;
            padding-bottom: 10px;
        }
        
        .tab-btn {
            background: #d7ccc8;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .tab-btn:hover {
            background: #bcaaa4;
        }
        
        .tab-btn.active {
            background: #6d4c41;
            color: white;
        }
        
        .tab-content {
            display: none;
            margin-top: 20px;
        }
        
        .tab-content.active {
            display: block;
        }
        
        /* Orders Section */
        .order-list {
            background: #d7ccc8;
            padding: 15px;
            border-radius: 8px;
            margin-top: 20px;
        }
        
        .order-item {
            background: white;
            padding: 15px;
            margin: 10px 0;
            border-radius: 5px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .complete-btn {
            background: #4caf50;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
        }
        
        .complete-btn:hover {
            background: #45a049;
        }
        
        /* Product Management */
        .btn-add {
            background: #4caf50;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            margin-bottom: 20px;
        }
        
        .btn-add:hover {
            background: #45a049;
        }
        
        .btn-edit {
            background: #2196f3;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
        }
        
        .btn-delete {
            background: #f44336;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
        }
        
        .products-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
        }
        
        .products-table th, .products-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #d7ccc8;
        }
        
        .products-table th {
            background: #d7ccc8;
            color: #4e342e;
        }
        
        .products-table tr:hover {
            background: #f5f5f5;
        }
        
        /* Modal */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }
        
        .modal-content {
            background-color: #efebe9;
            margin: 50px auto;
            padding: 25px;
            border-radius: 12px;
            width: 90%;
            max-width: 500px;
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #d7ccc8;
        }
        
        .close {
            font-size: 28px;
            cursor: pointer;
            color: #6d4c41;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #4e342e;
            font-weight: bold;
        }
        
        .form-group input, .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #d7ccc8;
            border-radius: 8px;
            box-sizing: border-box;
        }
        
        .btn-submit {
            background: #6d4c41;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 8px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
        }
        
        .btn-submit:hover {
            background: #5d4037;
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
        
        .message {
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
        }
        
        .message.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .message.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .action-buttons {
            display: flex;
            gap: 8px;
        }
    </style>
</head>
<body>

<div class="container">
    <%
        // Check if barista is logged in
        if(session.getAttribute("username") == null || 
           !"barista".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String username = (String) session.getAttribute("username");
        
        // Handle form actions
        String action = request.getParameter("action");
        String message = "";
        String messageType = "";
        
        if(action != null) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dassystem", "root", "admin");
                
                if(action.equals("add")) {
                    String productName = request.getParameter("productName");
                    String price = request.getParameter("price");
                    String size = request.getParameter("size");
                    String status = request.getParameter("status");
                    
                    String sql = "INSERT INTO product (productName, price, size, availability_status) VALUES (?, ?, ?, ?)";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, productName);
                    pstmt.setDouble(2, Double.parseDouble(price));
                    pstmt.setString(3, size);
                    pstmt.setString(4, status);
                    pstmt.executeUpdate();
                    message = "Product added successfully!";
                    messageType = "success";
                    
                } else if(action.equals("edit")) {
                    int productID = Integer.parseInt(request.getParameter("productID"));
                    String productName = request.getParameter("productName");
                    String price = request.getParameter("price");
                    String size = request.getParameter("size");
                    String status = request.getParameter("status");
                    
                    String sql = "UPDATE product SET productName=?, price=?, size=?, availability_status=? WHERE productID=?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, productName);
                    pstmt.setDouble(2, Double.parseDouble(price));
                    pstmt.setString(3, size);
                    pstmt.setString(4, status);
                    pstmt.setInt(5, productID);
                    pstmt.executeUpdate();
                    message = "Product updated successfully!";
                    messageType = "success";
                    
                } else if(action.equals("delete")) {
                    int productID = Integer.parseInt(request.getParameter("productID"));
                    
                    String sql = "DELETE FROM product WHERE productID=?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, productID);
                    pstmt.executeUpdate();
                    message = "Product deleted successfully!";
                    messageType = "success";
                }
                
            } catch(Exception e) {
                message = "Error: " + e.getMessage();
                messageType = "error";
                e.printStackTrace();
            } finally {
                try {
                    if(pstmt != null) pstmt.close();
                    if(conn != null) conn.close();
                } catch(SQLException e) {}
            }
        }
    %>
    
    <div class="welcome">
        <h2>Welcome, <%= username %>! ☕</h2>
        <p>Barista Dashboard - Manage orders and products</p>
    </div>
    
    <% if(!message.isEmpty()) { %>
        <div class="message <%= messageType %>">
            <%= message %>
        </div>
    <% } %>
    
    <!-- Tabs -->
    <div class="tabs">
        <button class="tab-btn active" onclick="showTab('orders')">📋 Pending Orders</button>
        <button class="tab-btn" onclick="showTab('products')">📦 Manage Products</button>
    </div>
    
    <!-- Orders Tab -->
    <div id="ordersTab" class="tab-content active">
        <div class="order-list">
            <h3>📋 Pending Orders</h3>
            <%
                Connection connOrders = null;
                Statement stmtOrders = null;
                ResultSet rsOrders = null;
                
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    connOrders = DriverManager.getConnection("jdbc:mysql://localhost:3306/dassystem", "root", "admin");
                    
                    String sql = "SELECT o.orderID, o.orderDate, o.orderTime, c.username, SUM(oi.subtotal) as total " +
                                "FROM orders o " +
                                "JOIN customer c ON o.userID = c.userID " +
                                "LEFT JOIN orderItem oi ON o.orderID = oi.orderID " +
                                "WHERE o.orderStatus = 'Processing' " +
                                "GROUP BY o.orderID " +
                                "ORDER BY o.orderID DESC";
                    stmtOrders = connOrders.createStatement();
                    rsOrders = stmtOrders.executeQuery(sql);
                    
                    boolean hasOrders = false;
                    while(rsOrders.next()) {
                        hasOrders = true;
                        int orderID = rsOrders.getInt("orderID");
                        String orderDate = rsOrders.getString("orderDate");
                        String orderTime = rsOrders.getString("orderTime");
                        String customerName = rsOrders.getString("username");
                        double total = rsOrders.getDouble("total");
            %>
                        <div class="order-item">
                            <div>
                                <strong>Order #<%= orderID %></strong><br>
                                Customer: <%= customerName %><br>
                                Time: <%= orderDate %> <%= orderTime %><br>
                                Total: RM <%= String.format("%.2f", total) %>
                            </div>
                            <form action="UpdateOrderStatusServlet" method="post" style="display:inline;">
                                <input type="hidden" name="orderID" value="<%= orderID %>">
                                <input type="hidden" name="status" value="Completed">
                                <button type="submit" class="complete-btn">✅ Complete Order</button>
                            </form>
                        </div>
            <%
                    }
                    
                    if(!hasOrders) {
                        out.println("<p style='padding:20px; text-align:center;'>No pending orders.</p>");
                    }
                    
                } catch(Exception e) {
                    out.println("<p style='color:red;'>Error loading orders: " + e.getMessage() + "</p>");
                    e.printStackTrace();
                } finally {
                    try {
                        if(rsOrders != null) rsOrders.close();
                        if(stmtOrders != null) stmtOrders.close();
                        if(connOrders != null) connOrders.close();
                    } catch(SQLException e) {}
                }
            %>
        </div>
    </div>
    
    <!-- Products Tab (CRUD) -->
    <div id="productsTab" class="tab-content">
        <button class="btn-add" onclick="openAddModal()">+ Add New Product</button>
        
        <table class="products-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Product Name</th>
                    <th>Price (RM)</th>
                    <th>Size</th>
                    <th>Status</th>
                    <th>Action</th>
                 </tr>
            </thead>
            <tbody>
                <%
                    Connection connProducts = null;
                    Statement stmtProducts = null;
                    ResultSet rsProducts = null;
                    
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        connProducts = DriverManager.getConnection("jdbc:mysql://localhost:3306/dassystem", "root", "admin");
                        
                        String sql = "SELECT productID, productName, price, size, availability_status FROM product ORDER BY productID";
                        stmtProducts = connProducts.createStatement();
                        rsProducts = stmtProducts.executeQuery(sql);
                        
                        while(rsProducts.next()) {
                            int productID = rsProducts.getInt("productID");
                            String productName = rsProducts.getString("productName");
                            double price = rsProducts.getDouble("price");
                            String size = rsProducts.getString("size");
                            String status = rsProducts.getString("availability_status");
                %>
                            <tr>
                                <td><%= productID %></td>
                                <td><%= productName %></td>
                                <td>RM <%= String.format("%.2f", price) %></td>
                                <td><%= size %></td>
                                <td><%= status %></td>
                                <td class="action-buttons">
                                    <button class="btn-edit" onclick="openEditModal(<%= productID %>, '<%= productName %>', <%= price %>, '<%= size %>', '<%= status %>')">Edit</button>
                                    <button class="btn-delete" onclick="confirmDelete(<%= productID %>)">Delete</button>
                                </td>
                            </tr>
                <%
                        }
                        
                    } catch(Exception e) {
                        out.println("<tr><td colspan='6' style='text-align:center; color:red;'>Error loading products: " + e.getMessage() + "</td></tr>");
                        e.printStackTrace();
                    } finally {
                        try {
                            if(rsProducts != null) rsProducts.close();
                            if(stmtProducts != null) stmtProducts.close();
                            if(connProducts != null) connProducts.close();
                        } catch(SQLException e) {}
                    }
                %>
            </tbody>
        </table>
    </div>
    
    <a href="logout.jsp" class="logout">🚪 Logout</a>
</div>

<!-- Add/Edit Product Modal -->
<div id="productModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3 id="modalTitle">Add New Product</h3>
            <span class="close" onclick="closeModal()">&times;</span>
        </div>
        <form id="productForm" method="post">
            <input type="hidden" id="actionType" name="action" value="add">
            <input type="hidden" id="productID" name="productID" value="">
            
            <div class="form-group">
                <label>Product Name:</label>
                <input type="text" id="productName" name="productName" required>
            </div>
            
            <div class="form-group">
                <label>Price (RM):</label>
                <input type="number" step="0.01" id="price" name="price" required>
            </div>
            
            <div class="form-group">
                <label>Size:</label>
                <select id="size" name="size">
                    <option value="Regular">Regular</option>
                    <option value="Large">Large</option>
                </select>
            </div>
            
            <div class="form-group">
                <label>Status:</label>
                <select id="status" name="status">
                    <option value="Available">Available</option>
                    <option value="Out of Stock">Out of Stock</option>
                </select>
            </div>
            
            <button type="submit" class="btn-submit">Save Product</button>
        </form>
    </div>
</div>

<script>
    function showTab(tab) {
        // Update active button
        document.querySelectorAll('.tab-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        event.target.classList.add('active');
        
        // Hide all tabs
        document.getElementById('ordersTab').classList.remove('active');
        document.getElementById('productsTab').classList.remove('active');
        
        // Show selected tab
        if(tab === 'orders') {
            document.getElementById('ordersTab').classList.add('active');
        } else if(tab === 'products') {
            document.getElementById('productsTab').classList.add('active');
        }
    }
    
    function openAddModal() {
        document.getElementById('modalTitle').innerHTML = 'Add New Product';
        document.getElementById('actionType').value = 'add';
        document.getElementById('productID').value = '';
        document.getElementById('productName').value = '';
        document.getElementById('price').value = '';
        document.getElementById('size').value = 'Regular';
        document.getElementById('status').value = 'Available';
        document.getElementById('productModal').style.display = 'block';
    }
    
    function openEditModal(id, name, price, size, status) {
        document.getElementById('modalTitle').innerHTML = 'Edit Product';
        document.getElementById('actionType').value = 'edit';
        document.getElementById('productID').value = id;
        document.getElementById('productName').value = name;
        document.getElementById('price').value = price;
        document.getElementById('size').value = size;
        document.getElementById('status').value = status;
        document.getElementById('productModal').style.display = 'block';
    }
    
    function confirmDelete(id) {
        if(confirm('Are you sure you want to delete this product?')) {
            window.location.href = 'baristaDashboard.jsp?action=delete&productID=' + id;
        }
    }
    
    function closeModal() {
        document.getElementById('productModal').style.display = 'none';
    }
    
    // Close modal when clicking outside
    window.onclick = function(event) {
        const modal = document.getElementById('productModal');
        if(event.target == modal) {
            modal.style.display = 'none';
        }
    }
</script>

</body>
</html>
