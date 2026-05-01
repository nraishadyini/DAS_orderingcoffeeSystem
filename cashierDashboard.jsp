<%@ page import="java.sql.*, java.util.*" %>
<%
    // Check if cashier is logged in
    if(session.getAttribute("username") == null || 
       !"cashier".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String cashierName = (String) session.getAttribute("username");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Cashier Dashboard - Coffee Shop</title>
    <meta charset="UTF-8">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: Arial, sans-serif;
            background: #3e2723;
            min-height: 100vh;
        }
        
        .header {
            background: #4e342e;
            color: white;
            padding: 20px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .container {
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        
        .tab-btn {
            background: #efebe9;
            border: none;
            padding: 12px 25px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
        }
        
        .tab-btn.active {
            background: #6d4c41;
            color: white;
        }
        
        .tab-content {
            display: none;
        }
        
        .tab-content.active {
            display: block;
        }
        
        .orders-table {
            width: 100%;
            border-collapse: collapse;
            background: #efebe9;
            border-radius: 10px;
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
        
        .payment-completed { color: #4caf50; font-weight: bold; }
        .payment-pending { color: #ff9800; font-weight: bold; }
        
        .confirm-btn {
            background: #4caf50;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
        }
        
        .confirm-btn:hover {
            background: #45a049;
        }
        
        .view-btn {
            background: #2196f3;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
        }
        
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
            border-radius: 10px;
            width: 90%;
            max-width: 600px;
        }
        
        .close {
            float: right;
            font-size: 28px;
            cursor: pointer;
        }
        
        .logout-btn {
            background: #8d6e63;
            color: white;
            padding: 8px 15px;
            text-decoration: none;
            border-radius: 5px;
        }
    </style>
</head>
<body>

<div class="header">
    <h2>💰 Cashier Dashboard</h2>
    <div>
        <span>Welcome, <%= cashierName %>!</span>
        <a href="logout.jsp" class="logout-btn" style="margin-left: 15px;">Logout</a>
    </div>
</div>

<div class="container">
    <div class="tabs">
        <button class="tab-btn active" onclick="showTab('pending')">Pending Orders</button>
        <button class="tab-btn" onclick="showTab('completed')">Completed Orders</button>
        <button class="tab-btn" onclick="showTab('audit')">Audit Log</button>
    </div>
    
    <!-- Pending Orders Tab -->
    <div id="pendingTab" class="tab-content active">
        <div style="background: #efebe9; border-radius: 10px; padding: 20px;">
            <h3>📋 Orders Awaiting Payment Confirmation</h3>
            <div id="pendingOrdersList">
                <p>Loading orders...</p>
            </div>
        </div>
    </div>
    
    <!-- Completed Orders Tab -->
    <div id="completedTab" class="tab-content">
        <div style="background: #efebe9; border-radius: 10px; padding: 20px;">
            <h3>✅ Completed Orders</h3>
            <div id="completedOrdersList">
                <p>Loading orders...</p>
            </div>
        </div>
    </div>
    
    <!-- Audit Log Tab -->
    <div id="auditTab" class="tab-content">
        <div style="background: #efebe9; border-radius: 10px; padding: 20px;">
            <h3>📜 Payment Audit Log</h3>
            <div id="auditList">
                <p>Loading audit log...</p>
            </div>
        </div>
    </div>
</div>

<!-- Order Details Modal -->
<div id="orderModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal()">&times;</span>
        <h3>Order Details</h3>
        <div id="orderDetails"></div>
    </div>
</div>

<script>
    function showTab(tab) {
        // Update tabs
        document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
        event.target.classList.add('active');
        
        // Hide all tabs
        document.getElementById('pendingTab').classList.remove('active');
        document.getElementById('completedTab').classList.remove('active');
        document.getElementById('auditTab').classList.remove('active');
        
        // Show selected tab
        if (tab === 'pending') {
            document.getElementById('pendingTab').classList.add('active');
            loadPendingOrders();
        } else if (tab === 'completed') {
            document.getElementById('completedTab').classList.add('active');
            loadCompletedOrders();
        } else if (tab === 'audit') {
            document.getElementById('auditTab').classList.add('active');
            loadAuditLog();
        }
    }
    
    function loadPendingOrders() {
        fetch('GetPendingOrdersServlet')
            .then(response => response.json())
            .then(data => {
                displayPendingOrders(data);
            })
            .catch(error => {
                console.error('Error:', error);
                document.getElementById('pendingOrdersList').innerHTML = '<p>Error loading orders.</p>';
            });
    }
    
    function displayPendingOrders(orders) {
        const container = document.getElementById('pendingOrdersList');
        if (!orders || orders.length === 0) {
            container.innerHTML = '<p>No pending orders.</p>';
            return;
        }
        
        let html = '<table class="orders-table">';
        html += '<thead><tr><th>Order ID</th><th>Customer</th><th>Date</th><th>Total (RM)</th><th>Payment Status</th><th>Payment Method</th><th>Action</th></tr></thead><tbody>';
        
        for (let i = 0; i < orders.length; i++) {
            const order = orders[i];
            html += `<tr>
                        <td>${order.orderID}</td>
                        <td>${order.username || 'Customer'}</td>
                        <td>${order.orderDate}</td>
                        <td>RM ${order.total.toFixed(2)}</td>
                        <td class="payment-pending">Pending</td>
                        <td>${order.paymentType || '-'}</td>
                        <td>
                            <button class="confirm-btn" onclick="confirmPayment(${order.orderID})">Confirm Payment</button>
                            <button class="view-btn" onclick="viewOrder(${order.orderID})">View</button>
                        </td>
                     </tr>`;
        }
        html += '</tbody></table>';
        container.innerHTML = html;
    }
    
    function loadCompletedOrders() {
        fetch('GetCompletedOrdersServlet')
            .then(response => response.json())
            .then(data => {
                displayCompletedOrders(data);
            })
            .catch(error => {
                console.error('Error:', error);
                document.getElementById('completedOrdersList').innerHTML = '<p>Error loading orders.</p>';
            });
    }
    
    function displayCompletedOrders(orders) {
        const container = document.getElementById('completedOrdersList');
        if (!orders || orders.length === 0) {
            container.innerHTML = '<p>No completed orders.</p>';
            return;
        }
        
        let html = '<table class="orders-table">';
        html += '<thead><tr><th>Order ID</th><th>Customer</th><th>Date</th><th>Total (RM)</th><th>Payment Status</th><th>Payment Method</th><th>Completed Date</th></tr></thead><tbody>';
        
        for (let i = 0; i < orders.length; i++) {
            const order = orders[i];
            html += `<tr>
                        <td>${order.orderID}</td>
                        <td>${order.username || 'Customer'}</td>
                        <td>${order.orderDate}</td>
                        <td>RM ${order.total.toFixed(2)}</td>
                        <td class="payment-completed">${order.paymentStatus || 'Completed'}</td>
                        <td>${order.paymentType || '-'}</td>
                        <td>${order.completedDate || order.paymentDate || '-'}</td>
                     </tr>`;
        }
        html += '</tbody></table>';
        container.innerHTML = html;
    }
    
    function loadAuditLog() {
        fetch('GetAuditLogServlet')
            .then(response => response.json())
            .then(data => {
                displayAuditLog(data);
            })
            .catch(error => {
                console.error('Error:', error);
                document.getElementById('auditList').innerHTML = '<p>Error loading audit log.</p>';
            });
    }
    
    function displayAuditLog(logs) {
        const container = document.getElementById('auditList');
        if (!logs || logs.length === 0) {
            container.innerHTML = '<p>No audit logs found.</p>';
            return;
        }
        
        let html = '<table class="orders-table">';
        html += '<thead><tr><th>Date</th><th>Order ID</th><th>Payment ID</th><th>Action</th><th>Status Change</th><th>Performed By</th><th>Notes</th></tr></thead><tbody>';
        
        for (let i = 0; i < logs.length; i++) {
            const log = logs[i];
            html += `<tr>
                        <td>${log.actionDate}</td>
                        <td>${log.orderID}</td>
                        <td>${log.paymentID || '-'}</td>
                        <td>${log.action}</td>
                        <td>${log.oldStatus || '-'} → ${log.newStatus || '-'}</td>
                        <td>${log.performedBy}</td>
                        <td>${log.notes || '-'}</td>
                     </tr>`;
        }
        html += '</tbody></table>';
        container.innerHTML = html;
    }
    
    function confirmPayment(orderID) {
        if (confirm('Confirm payment for Order #' + orderID + '?')) {
            fetch('ConfirmPaymentServlet?orderID=' + orderID)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('Payment confirmed successfully!');
                        loadPendingOrders();
                        loadCompletedOrders();
                        loadAuditLog();
                    } else {
                        alert('Error: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error confirming payment');
                });
        }
    }
    
    function viewOrder(orderID) {
        fetch('GetOrderDetailsServlet?orderID=' + orderID)
            .then(response => response.json())
            .then(data => {
                displayOrderDetails(data);
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error loading order details');
            });
    }
    
    function displayOrderDetails(order) {
        const modal = document.getElementById('orderModal');
        const detailsDiv = document.getElementById('orderDetails');
        
        let html = `<p><strong>Order ID:</strong> ${order.orderID}</p>
                    <p><strong>Customer:</strong> ${order.username}</p>
                    <p><strong>Date:</strong> ${order.orderDate}</p>
                    <p><strong>Status:</strong> ${order.orderStatus}</p>
                    <p><strong>Total:</strong> RM ${order.total.toFixed(2)}</p>
                    <h4>Items:</h4>
                    <table class="orders-table">
                        <thead><tr><th>Product</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr></thead>
                        <tbody>`;
        
        if (order.items) {
            for (let i = 0; i < order.items.length; i++) {
                const item = order.items[i];
                html += `<tr>
                            <td>${item.productName}</td>
                            <td>${item.quantity}</td>
                            <td>RM ${item.price.toFixed(2)}</td>
                            <td>RM ${item.subtotal.toFixed(2)}</td>
                         </tr>`;
            }
        }
        
        html += `</tbody></table>`;
        detailsDiv.innerHTML = html;
        modal.style.display = 'block';
    }
    
    function closeModal() {
        document.getElementById('orderModal').style.display = 'none';
    }
    
    // Load initial data
    document.addEventListener('DOMContentLoaded', function() {
        loadPendingOrders();
    });
</script>

</body>
</html>
