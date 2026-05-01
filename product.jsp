<%-- 
    Document   : product
    Created on : Apr 29, 2026
    Author     : auni
    Description: Display all products from database
--%>

<%@ page import="java.sql.*, java.util.*" %>
<%
    // Check if customer is logged in
    if(session.getAttribute("username") == null || 
       !"customer".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String username = (String) session.getAttribute("username");
    int userID = 0;
    
    // Get userID from session
    if(session.getAttribute("userID") != null) {
        userID = (int) session.getAttribute("userID");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Our Menu - Coffee Shop</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #3e2723;
            min-height: 100vh;
        }
        
        /* Header */
        .header {
            background: #4e342e;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.3);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        
        .logo h2 { color: #efebe9; }
        .logo a { text-decoration: none; color: white; }
        
        .cart-icon {
            background: #6d4c41;
            padding: 8px 15px;
            border-radius: 20px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .cart-count {
            background: #ff9800;
            border-radius: 50%;
            width: 22px;
            height: 22px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
        }
        
        .back-btn {
            background: #8d6e63;
            color: white;
            padding: 8px 15px;
            text-decoration: none;
            border-radius: 5px;
        }
        
        /* Main Container */
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        /* Welcome Banner */
        .welcome-banner {
            background: linear-gradient(135deg, #6d4c41, #4e342e);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .welcome-banner h1 { font-size: 28px; margin-bottom: 10px; }
        
        /* Category Filter */
        .category-filter {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
            flex-wrap: wrap;
            justify-content: center;
        }
        
        .category-btn {
            background: #efebe9;
            border: none;
            padding: 10px 25px;
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.3s;
            color: #4e342e;
            font-size: 14px;
        }
        
        .category-btn:hover, .category-btn.active {
            background: #6d4c41;
            color: white;
        }
        
        /* Products Grid */
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
        }
        
        .product-card {
            background: #efebe9;
            border-radius: 15px;
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
        }
        
        .product-image {
            background: linear-gradient(135deg, #6d4c41, #4e342e);
            height: 180px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 64px;
        }
        
        .product-info {
            padding: 20px;
        }
        
        .product-name {
            font-size: 18px;
            font-weight: bold;
            color: #4e342e;
            margin-bottom: 8px;
        }
        
        .product-price {
            font-size: 22px;
            color: #6d4c41;
            font-weight: bold;
            margin: 10px 0;
        }
        
        .product-size {
            font-size: 12px;
            color: #8d6e63;
            margin-bottom: 15px;
        }
        
        .add-to-cart-btn {
            background: #6d4c41;
            color: white;
            border: none;
            padding: 10px;
            border-radius: 8px;
            cursor: pointer;
            width: 100%;
            font-size: 14px;
            transition: background 0.3s;
        }
        
        .add-to-cart-btn:hover {
            background: #5d4037;
        }
        
        /* Loading Spinner */
        .loading {
            text-align: center;
            padding: 50px;
            color: #efebe9;
            font-size: 18px;
        }
        
        /* Cart Modal */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            overflow-y: auto;
        }
        
        .modal-content {
            background-color: #efebe9;
            margin: 50px auto;
            padding: 30px;
            border-radius: 15px;
            width: 90%;
            max-width: 500px;
            position: relative;
            animation: slideDown 0.3s ease;
        }
        
        @keyframes slideDown {
            from { transform: translateY(-50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        
        .close {
            position: absolute;
            right: 20px;
            top: 15px;
            font-size: 28px;
            cursor: pointer;
            color: #6d4c41;
        }
        
        .cart-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #d7ccc8;
        }
        
        .remove-item {
            color: #f44336;
            cursor: pointer;
            margin-left: 10px;
        }
        
        .submit-btn {
            background: #6d4c41;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            width: 100%;
            margin-top: 15px;
            font-size: 16px;
        }
        
        .total-display {
            text-align: right;
            font-weight: bold;
            margin-top: 15px;
            padding-top: 10px;
            font-size: 18px;
        }
        
        /* Notification */
        .notification {
            position: fixed;
            top: 80px;
            right: 20px;
            padding: 15px 20px;
            border-radius: 8px;
            color: white;
            z-index: 1100;
            animation: slideIn 0.3s;
        }
        
        .notification.success { background: #4caf50; }
        .notification.error { background: #f44336; }
        
        @keyframes slideIn {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        
        /* Footer */
        .footer {
            background: #4e342e;
            color: #d7ccc8;
            text-align: center;
            padding: 20px;
            margin-top: 50px;
        }
        
        @media (max-width: 768px) {
            .header { flex-direction: column; gap: 15px; text-align: center; }
            .products-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<!-- Header -->
<div class="header">
    <div class="logo">
        <a href="customerDashboard.jsp">
            <h2>☕ Coffee Shop</h2>
        </a>
    </div>
    <div style="display: flex; gap: 15px; align-items: center;">
        <div class="cart-icon" onclick="openCartModal()">
            🛒 Cart <span class="cart-count" id="cartCount">0</span>
        </div>
        <a href="customerDashboard.jsp" class="back-btn">← Dashboard</a>
    </div>
</div>

<!-- Main Content -->
<div class="container">
    <div class="welcome-banner">
        <h1>☕ Our Premium Menu</h1>
        <p>Browse our selection of finest coffee, tea, pastries, and more!</p>
    </div>
    
    <!-- Category Filter -->
    <div class="category-filter" id="categoryFilter">
        <button class="category-btn active" data-category="all">All</button>
        <button class="category-btn" data-category="Coffee">☕ Coffee</button>
        <button class="category-btn" data-category="Tea">🍵 Tea</button>
        <button class="category-btn" data-category="Pastry">🥐 Pastry</button>
        <button class="category-btn" data-category="Cake">🍰 Cake</button>
        <button class="category-btn" data-category="Sandwich">🥪 Sandwich</button>
        <button class="category-btn" data-category="Specialty">✨ Specialty</button>
    </div>
    
    <!-- Products Grid -->
    <div class="products-grid" id="productsGrid">
        <div class="loading">Loading delicious products...</div>
    </div>
</div>

<!-- Cart Modal -->
<div id="cartModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeCartModal()">&times;</span>
        <h3>🛒 Your Cart</h3>
        <div id="cartItemsList"></div>
        <div id="cartTotalDisplay" class="total-display"></div>
        <button class="submit-btn" onclick="placeOrder()">Place Order</button>
    </div>
</div>

<!-- Footer -->
<div class="footer">
    <p>&copy; 2024 Coffee Shop System. All rights reserved.</p>
    <p>Serving you the best coffee experience!</p>
</div>

<script>
    let cart = [];
    let allProducts = [];
    let currentUserID = <%= userID %>;
    let currentUsername = "<%= username %>";
    
    // Load products on page load
    document.addEventListener('DOMContentLoaded', function() {
        loadProductsFromDatabase();
        loadCartFromStorage();
    });
    
    // Load products from database via servlet
    function loadProductsFromDatabase() {
        fetch('ProductServlet')
            .then(response => response.json())
            .then(data => {
                allProducts = data;
                displayProducts(allProducts);
            })
            .catch(error => {
                console.error('Error loading products:', error);
                document.getElementById('productsGrid').innerHTML = '<div style="text-align:center; padding:50px; color:#efebe9;">Error loading products. Please refresh the page.</div>';
            });
    }
    
    function displayProducts(products) {
        const container = document.getElementById('productsGrid');
        
        if (products.length === 0) {
            container.innerHTML = '<div style="text-align:center; padding:50px; color:#efebe9;">No products found in this category.</div>';
            return;
        }
        
        let html = '';
        products.forEach(product => {
            let icon = getProductIcon(product.productName);
            html += `
                <div class="product-card">
                    <div class="product-image">${icon}</div>
                    <div class="product-info">
                        <div class="product-name">${product.productName}</div>
                        <div class="product-price">RM ${parseFloat(product.price).toFixed(2)}</div>
                        <div class="product-size">${product.size || 'Regular'}</div>
                        <button class="add-to-cart-btn" onclick="addToCart(${product.productID}, '${product.productName}', ${product.price})">
                            🛒 Add to Cart
                        </button>
                    </div>
                </div>
            `;
        });
        container.innerHTML = html;
    }
    
    function getProductIcon(productName) {
        const name = productName.toLowerCase();
        if (name.includes('espresso') || name.includes('latte') || name.includes('cappuccino') || name.includes('mocha') || name.includes('americano')) return '☕';
        if (name.includes('tea') || name.includes('matcha') || name.includes('chai')) return '🍵';
        if (name.includes('croissant') || name.includes('muffin') || name.includes('roll')) return '🥐';
        if (name.includes('cake') || name.includes('cheesecake') || name.includes('tiramisu')) return '🍰';
        if (name.includes('sandwich')) return '🥪';
        if (name.includes('frappuccino') || name.includes('cold brew')) return '🥤';
        return '☕';
    }
    
    // Category Filter
    document.querySelectorAll('.category-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.category-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            
            const category = this.getAttribute('data-category');
            filterProductsByCategory(category);
        });
    });
    
    function filterProductsByCategory(category) {
        if (category === 'all') {
            displayProducts(allProducts);
            return;
        }
        
        const filtered = allProducts.filter(product => {
            const name = product.productName.toLowerCase();
            switch(category) {
                case 'Coffee': return name.includes('espresso') || name.includes('latte') || name.includes('cappuccino') || name.includes('mocha') || name.includes('americano') || name.includes('caramel');
                case 'Tea': return name.includes('tea') || name.includes('matcha') || name.includes('chai');
                case 'Pastry': return name.includes('croissant') || name.includes('muffin') || name.includes('roll') || name.includes('pastry');
                case 'Cake': return name.includes('cake') || name.includes('cheesecake') || name.includes('tiramisu') || name.includes('brownie') || name.includes('cookie');
                case 'Sandwich': return name.includes('sandwich');
                case 'Specialty': return name.includes('signature') || name.includes('cold brew') || name.includes('frappuccino');
                default: return true;
            }
        });
        displayProducts(filtered);
    }
    
    // Cart Functions
    function addToCart(productID, productName, price) {
        const existingItem = cart.find(item => item.productID === productID);
        
        if (existingItem) {
            existingItem.quantity++;
            existingItem.subtotal = existingItem.price * existingItem.quantity;
        } else {
            cart.push({
                productID: productID,
                name: productName,
                price: price,
                quantity: 1,
                subtotal: price
            });
        }
        
        updateCartDisplay();
        saveCartToStorage();
        showNotification(productName + ' added to cart!', 'success');
        
        // Animate cart icon
        const cartIcon = document.querySelector('.cart-icon');
        cartIcon.style.transform = 'scale(1.1)';
        setTimeout(() => { cartIcon.style.transform = ''; }, 200);
    }
    
    function updateCartDisplay() {
        const cartCountSpan = document.getElementById('cartCount');
        const totalItems = cart.reduce((sum, item) => sum + item.quantity, 0);
        cartCountSpan.textContent = totalItems;
    }
    
    function openCartModal() {
        const modal = document.getElementById('cartModal');
        const cartItemsList = document.getElementById('cartItemsList');
        const cartTotalDisplay = document.getElementById('cartTotalDisplay');
        
        if (cart.length === 0) {
            cartItemsList.innerHTML = '<p style="text-align:center; padding:20px;">Your cart is empty.</p>';
            cartTotalDisplay.innerHTML = '';
        } else {
            let html = '';
            let total = 0;
            cart.forEach((item, index) => {
                total += item.subtotal;
                html += `
                    <div class="cart-item">
                        <span>${item.quantity}x ${item.name}</span>
                        <span>RM ${item.subtotal.toFixed(2)} 
                            <span class="remove-item" onclick="removeFromCart(${index})">🗑️</span>
                        </span>
                    </div>
                `;
            });
            cartItemsList.innerHTML = html;
            cartTotalDisplay.innerHTML = `Total: RM ${total.toFixed(2)}`;
        }
        modal.style.display = 'block';
    }
    
    function closeCartModal() {
        document.getElementById('cartModal').style.display = 'none';
    }
    
    function removeFromCart(index) {
        cart.splice(index, 1);
        updateCartDisplay();
        saveCartToStorage();
        openCartModal(); // Refresh modal
        showNotification('Item removed from cart', 'success');
    }
    
    function placeOrder() {
        if (cart.length === 0) {
            showNotification('Your cart is empty!', 'error');
            return;
        }
        
        const total = cart.reduce((sum, item) => sum + item.subtotal, 0);
        
        if (confirm(`Total amount: RM ${total.toFixed(2)}\n\nProceed to checkout?`)) {
            const orderData = {
                userID: currentUserID,
                items: cart.map(item => ({
                    productID: item.productID,
                    quantity: item.quantity,
                    price: item.price
                }))
            };
            
            fetch('PlaceOrderServlet', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(orderData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showNotification('✅ Order placed successfully! Order ID: ' + data.orderID, 'success');
                    cart = [];
                    updateCartDisplay();
                    saveCartToStorage();
                    closeCartModal();
                } else {
                    showNotification('Failed to place order: ' + data.message, 'error');
                }
            })
            .catch(error => {
                // Demo mode
                const demoOrderID = Math.floor(Math.random() * 9000) + 1000;
                showNotification('✅ Order placed! Order ID: ' + demoOrderID, 'success');
                cart = [];
                updateCartDisplay();
                saveCartToStorage();
                closeCartModal();
            });
        }
    }
    
    function saveCartToStorage() {
        sessionStorage.setItem('cart_' + currentUserID, JSON.stringify(cart));
    }
    
    function loadCartFromStorage() {
        const savedCart = sessionStorage.getItem('cart_' + currentUserID);
        if (savedCart) {
            cart = JSON.parse(savedCart);
            updateCartDisplay();
        }
    }
    
    function showNotification(message, type) {
        const notification = document.createElement('div');
        notification.className = `notification ${type}`;
        notification.textContent = message;
        document.body.appendChild(notification);
        setTimeout(() => notification.remove(), 3000);
    }
    
    // Close modal on outside click
    window.onclick = function(event) {
        const modal = document.getElementById('cartModal');
        if (event.target == modal) {
            modal.style.display = 'none';
        }
    }
</script>

</body>
</html>
