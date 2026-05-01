<%-- 
    Document   : customerDashboard
    Created on : Apr 29, 2026, 7:07:02?AM
    Author     : auni
--%>

<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<%
    // Check if customer is logged in
    if(session.getAttribute("username") == null || 
       !"customer".equals(session.getAttribute("role"))) {
        response.sendRedirect("product.jsp");
        return;
    }
    
    String username = (String) session.getAttribute("username");
    int userID = 0;
    String email = "";
    String phoneNumber = "";
    
    // Get customer details from database
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dassystem", "root", "admin");
        
        String sql = "SELECT * FROM customer WHERE username = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, username);
        rs = pstmt.executeQuery();
        
        if(rs.next()) {
            userID = rs.getInt("userID");
            email = rs.getString("email");
            phoneNumber = rs.getString("phoneNumber");
            session.setAttribute("userID", userID);
        }
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if(rs != null) rs.close();
            if(pstmt != null) pstmt.close();
            if(conn != null) conn.close();
        } catch(SQLException e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Customer Dashboard - Coffee Shop</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #3e2723;
            min-height: 100vh;
        }
        
        /* Layout with Sidebar */
        .app-container {
            display: flex;
            min-height: 100vh;
        }
        
        /* Sidebar Styles */
        .sidebar {
            width: 280px;
            background: #4e342e;
            color: white;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            transition: all 0.3s;
            box-shadow: 2px 0 10px rgba(0,0,0,0.3);
            z-index: 100;
        }
        
        .sidebar-header {
            padding: 25px 20px;
            text-align: center;
            border-bottom: 1px solid #6d4c41;
        }
        
        .sidebar-header h2 {
            color: #efebe9;
            margin-bottom: 5px;
        }
        
        .user-avatar {
            width: 80px;
            height: 80px;
            background: #6d4c41;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 40px;
        }
        
        .user-name-sidebar {
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .user-email-sidebar {
            font-size: 12px;
            color: #d7ccc8;
            word-break: break-all;
        }
        
        /* Navigation Menu */
        .nav-menu {
            padding: 20px 0;
        }
        
        .nav-item {
            padding: 12px 25px;
            display: flex;
            align-items: center;
            gap: 12px;
            color: #efebe9;
            text-decoration: none;
            transition: all 0.3s;
            cursor: pointer;
            border-left: 3px solid transparent;
        }
        
        .nav-item:hover {
            background: #5d4037;
            border-left-color: #ff9800;
        }
        
        .nav-item.active {
            background: #5d4037;
            border-left-color: #ff9800;
        }
        
        .nav-icon {
            font-size: 22px;
            width: 30px;
        }
        
        .nav-text {
            font-size: 15px;
        }
        
        .logout-item {
            margin-top: 30px;
            border-top: 1px solid #6d4c41;
            padding-top: 20px;
        }
        
        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 20px;
        }
        
        /* Top Header */
        .top-header {
            background: #efebe9;
            padding: 15px 25px;
            border-radius: 12px;
            margin-bottom: 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .page-title {
            color: #4e342e;
            font-size: 24px;
        }
        
        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: #efebe9;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .stat-number {
            font-size: 32px;
            font-weight: bold;
            color: #4e342e;
        }
        
        .stat-label {
            color: #6d4c41;
            margin-top: 5px;
        }
        
        /* Menu Grid for Dashboard Cards */
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .menu-card {
            background: #efebe9;
            border-radius: 15px;
            padding: 30px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-decoration: none;
            color: #3e2723;
            display: block;
            border: none;
            width: 100%;
        }
        
        .menu-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            background: #d7ccc8;
        }
        
        .menu-icon { font-size: 48px; margin-bottom: 15px; }
        .menu-card h3 { color: #4e342e; margin-bottom: 10px; font-size: 20px; }
        .menu-card p { color: #6d4c41; font-size: 14px; }
        
        /* Orders Table */
        .orders-table {
            width: 100%;
            border-collapse: collapse;
            background: #efebe9;
            border-radius: 12px;
            overflow: hidden;
        }
        
        .orders-table th, .orders-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #d7ccc8;
        }
        
        .orders-table th {
            background: #d7ccc8;
            color: #4e342e;
        }
        
        .status-pending { color: #ff9800; font-weight: bold; }
        .status-processing { color: #2196f3; font-weight: bold; }
        .status-completed { color: #4caf50; font-weight: bold; }
        
        /* Profile Section */
        .profile-section {
            background: #efebe9;
            border-radius: 15px;
            padding: 25px;
            margin-top: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .profile-section h3 { color: #4e342e; margin-bottom: 20px; border-bottom: 2px solid #d7ccc8; padding-bottom: 10px; }
        .profile-info { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px; }
        .info-item { padding: 10px; }
        .info-label { font-weight: bold; color: #6d4c41; margin-bottom: 5px; }
        .info-value { color: #3e2723; font-size: 16px; }
        
        /* Track Order Form */
        .track-form {
            background: #efebe9;
            border-radius: 12px;
            padding: 25px;
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
        
        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #bcaaa4;
            border-radius: 8px;
        }
        
        .submit-btn {
            background: #6d4c41;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
        }
        
        .submit-btn:hover { background: #5d4037; }
        
        .track-result {
            background: #d7ccc8;
            padding: 15px;
            border-radius: 8px;
            margin-top: 20px;
        }
        
        /* Notification */
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 20px;
            border-radius: 8px;
            color: white;
            animation: slideIn 0.3s ease;
            z-index: 1001;
        }
        
        .notification.success { background: #4caf50; }
        .notification.error { background: #f44336; }
        
        @keyframes slideIn {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        
        .footer {
            background: #4e342e;
            color: #d7ccc8;
            text-align: center;
            padding: 20px;
            margin-top: 40px;
        }
        
        @media (max-width: 768px) {
            .sidebar {
                width: 70px;
            }
            .sidebar .nav-text, .sidebar .user-email-sidebar, .sidebar-header h2 {
                display: none;
            }
            .main-content {
                margin-left: 70px;
            }
            .user-name-sidebar {
                font-size: 12px;
            }
            .menu-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<div class="app-container">
    <!-- Sidebar Navigation -->
    <div class="sidebar">
        <div class="sidebar-header">
            <div class="user-avatar">
                ?
            </div>
            <div class="user-name-sidebar"><%= username %></div>
            <div class="user-email-sidebar"><%= email %></div>
        </div>
        
        <div class="nav-menu">
            <div class="nav-item active" data-page="dashboard">
                <span class="nav-icon">?</span>
                <span class="nav-text">Dashboard</span>
            </div>
            <div class="nav-item" data-page="orders">
                <span class="nav-icon">?</span>
                <span class="nav-text">My Orders</span>
            </div>
            <div class="nav-item" data-page="track">
                <span class="nav-icon">?</span>
                <span class="nav-text">Track Order</span>
            </div>
            <div class="nav-item" data-page="profile">
                <span class="nav-icon">?</span>
                <span class="nav-text">My Profile</span>
            </div>
            <div class="nav-item logout-item" data-page="logout">
                <span class="nav-icon">?</span>
                <span class="nav-text">Logout</span>
            </div>
        </div>
    </div>
    
    <!-- Main Content -->
    <div class="main-content">
        <div class="top-header">
            <h1 class="page-title" id="pageTitle">? Dashboard</h1>
        </div>
        
        <!-- Dashboard Page -->
        <div id="dashboardPage">
            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-number" id="totalOrders">0</div>
                    <div class="stat-label">Total Orders</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number" id="pendingOrders">0</div>
                    <div class="stat-label">Pending Orders</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number" id="completedOrders">0</div>
                    <div class="stat-label">Completed Orders</div>
                </div>
            </div>
            
            <!-- Action Menu Cards -->
            <div class="menu-grid">
                <div class="menu-card" onclick="window.location.href='product.jsp'">
                    <div class="menu-icon">?</div>
                    <h3>Our Menu</h3>
                    <p>Browse all products and place order</p>
                </div>
                
                <div class="menu-card" onclick="goToOrders()">
                    <div class="menu-icon">?</div>
                    <h3>My Orders</h3>
                    <p>View your order history</p>
                </div>
                
                <div class="menu-card" onclick="goToTrack()">
                    <div class="menu-icon">?</div>
                    <h3>Track Order</h3>
                    <p>Track your current order status</p>
                </div>
                
                <div class="menu-card" onclick="goToProfile()">
                    <div class="menu-icon">?</div>
                    <h3>My Profile</h3>
                    <p>View and edit your profile</p>
                </div>
            </div>
            
            <!-- Profile Information Section -->
            <div class="profile-section">
                <h3>? Your Profile Information</h3>
                <div class="profile-info">
                    <div class="info-item">
                        <div class="info-label">Username</div>
                        <div class="info-value"><%= username %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Email</div>
                        <div class="info-value"><%= email %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Phone Number</div>
                        <div class="info-value"><%= phoneNumber %></div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Orders Page (hidden by default) -->
        <div id="ordersPage" style="display: none;">
            <div style="background: #efebe9; border-radius: 12px; padding: 20px;">
                <h3>? My Order History</h3>
                <div id="ordersList" style="overflow-x: auto; margin-top: 15px;">
                    <p style="text-align:center; padding:40px;">Loading orders...</p>
                </div>
            </div>
        </div>
        
        <!-- Track Order Page (hidden by default) -->
        <div id="trackPage" style="display: none;">
            <div class="track-form">
                <h3>? Track Your Order</h3>
                <div class="form-group" style="margin-top: 20px;">
                    <label>Enter Order ID:</label>
                    <input type="number" id="trackOrderID" placeholder="Enter Order ID">
                </div>
                <button class="submit-btn" onclick="trackOrder()">Track Order</button>
                <div id="trackResult" style="margin-top: 20px;"></div>
            </div>
        </div>
        
        <!-- Profile Page (hidden by default) -->
        <div id="profilePage" style="display: none;">
            <div class="profile-section">
                <h3>? My Profile</h3>
                <div class="profile-info">
                    <div class="info-item">
                        <div class="info-label">Username</div>
                        <div class="info-value"><%= username %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Email</div>
                        <div class="info-value"><%= email %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Phone Number</div>
                        <div class="info-value"><%= phoneNumber %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Member Since</div>
                        <div class="info-value">2024</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Footer -->
<div class="footer">
    <p>&copy; 2024 Coffee Shop System. All rights reserved.</p>
    <p>Serving you the best coffee experience!</p>
</div>

<script>
    let currentUserID = <%= userID %>;
    
    // Page navigation
    document.querySelectorAll('.nav-item').forEach(item => {
        item.addEventListener('click', function() {
            const page = this.getAttribute('data-page');
            
            if (page === 'logout') {
                window.location.href = 'logout.jsp';
                return;
            }
            
            // Update active state
            document.querySelectorAll('.nav-item').forEach(nav => nav.classList.remove('active'));
            this.classList.add('active');
            
            // Hide all pages
            document.getElementById('dashboardPage').style.display = 'none';
            document.getElementById('ordersPage').style.display = 'none';
            document.getElementById('trackPage').style.display = 'none';
            document.getElementById('profilePage').style.display = 'none';
            
            // Show selected page
            if (page === 'dashboard') {
                document.getElementById('dashboardPage').style.display = 'block';
                document.getElementById('pageTitle').innerHTML = '? Dashboard';
                loadOrderStats();
            } else if (page === 'orders') {
                document.getElementById('ordersPage').style.display = 'block';
                document.getElementById('pageTitle').innerHTML = '? My Orders';
                loadMyOrders();
            } else if (page === 'track') {
                document.getElementById('trackPage').style.display = 'block';
                document.getElementById('pageTitle').innerHTML = '? Track Order';
                document.getElementById('trackResult').innerHTML = '';
                document.getElementById('trackOrderID').value = '';
            } else if (page === 'profile') {
                document.getElementById('profilePage').style.display = 'block';
                document.getElementById('pageTitle').innerHTML = '? My Profile';
            }
        });
    });
    
    function goToOrders() {
        document.querySelector('.nav-item[data-page="orders"]').click();
    }
    
    function goToTrack() {
        document.querySelector('.nav-item[data-page="track"]').click();
    }
    
    function goToProfile() {
        document.querySelector('.nav-item[data-page="profile"]').click();
    }
    
    function loadOrderStats() {
        fetch('GetOrderStatsServlet?userID=' + currentUserID)
            .then(response => response.json())
            .then(data => {
                document.getElementById('totalOrders').textContent = data.totalOrders || 0;
                document.getElementById('pendingOrders').textContent = data.pendingOrders || 0;
                document.getElementById('completedOrders').textContent = data.completedOrders || 0;
            })
            .catch(error => {
                console.log('Error loading stats:', error);
                document.getElementById('totalOrders').textContent = '0';
                document.getElementById('pendingOrders').textContent = '0';
                document.getElementById('completedOrders').textContent = '0';
            });
    }
    
    function loadMyOrders() {
        fetch('GetCustomerOrdersServlet?userID=' + currentUserID)
            .then(response => response.json())
            .then(data => {
                displayOrders(data);
            })
            .catch(error => {
                console.log('Error loading orders:', error);
                document.getElementById('ordersList').innerHTML = '<p style="text-align:center; padding:40px;">No orders found.</p>';
            });
    }
    
    function displayOrders(orders) {
        const ordersList = document.getElementById('ordersList');
        if (!orders || orders.length === 0) {
            ordersList.innerHTML = '<p style="text-align:center; padding:40px;">? No orders found.</p>';
            return;
        }
        
        let html = '<table class="orders-table">';
        html += '<thead><tr><th>Order ID</th><th>Date</th><th>Total (RM)</th><th>Status</th></tr></thead><tbody>';
        orders.forEach(order => {
            let statusClass = '';
            if (order.orderStatus === 'Pending') statusClass = 'status-pending';
            else if (order.orderStatus === 'Processing') statusClass = 'status-processing';
            else if (order.orderStatus === 'Completed') statusClass = 'status-completed';
            
            html += `<tr>
                        <td>${order.orderID}</td>
                        <td>${order.orderDate}</td>
                        <td>RM ${(order.total || 0).toFixed(2)}</td>
                        <td class="${statusClass}">${order.orderStatus}</td>
                     </tr>`;
        });
        html += '</tbody></table>';
        ordersList.innerHTML = html;
    }
    
    function trackOrder() {
        const orderID = document.getElementById('trackOrderID').value;
        if (!orderID) {
            showNotification('Please enter Order ID', 'error');
            return;
        }
        
        fetch('TrackOrderServlet?orderID=' + orderID + '&userID=' + currentUserID)
            .then(response => response.json())
            .then(data => {
                if (data.found) {
                    let statusIcon = data.orderStatus === 'Pending' ? '?' : (data.orderStatus === 'Processing' ? '??' : '?');
                    document.getElementById('trackResult').innerHTML = `
                        <div class="track-result">
                            <h4>? Order #${data.orderID}</h4>
                            <p><strong>Date:</strong> ${data.orderDate}</p>
                            <p><strong>Status:</strong> ${statusIcon} ${data.orderStatus}</p>
                            <p><strong>Total:</strong> RM ${(data.total || 0).toFixed(2)}</p>
                        </div>
                    `;
                } else {
                    document.getElementById('trackResult').innerHTML = `
                        <div class="track-result" style="background:#ffebee;">
                            <p style="color:red;">? Order not found or you don't have permission to view it.</p>
                        </div>
                    `;
                }
            })
            .catch(error => {
                document.getElementById('trackResult').innerHTML = `
                    <div class="track-result">
                        <p>?? Unable to track order. Please try again later.</p>
                    </div>
                `;
            });
    }
    
    function showNotification(message, type) {
        const notification = document.createElement('div');
        notification.className = `notification ${type}`;
        notification.textContent = message;
        document.body.appendChild(notification);
        setTimeout(() => notification.remove(), 3000);
    }
    
    // Load initial data
    document.addEventListener('DOMContentLoaded', function() {
        loadOrderStats();
    });
</script>

</body>
</html>
