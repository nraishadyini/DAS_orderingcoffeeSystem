<%-- 
    Document   : product
    Created on : Apr 29, 2026
    Author     : auni
    Description: Display all products from database in grid layout (Display Only)
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
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .logo h2 { color: #efebe9; }
        .logo a { text-decoration: none; color: white; }
        
        .back-btn {
            background: #8d6e63;
            color: white;
            padding: 8px 15px;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.2s;
        }
        
        .back-btn:hover {
            background: #5d4037;
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
        .welcome-banner p { font-size: 16px; opacity: 0.9; }
        
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
            font-weight: 500;
        }
        
        .category-btn:hover, .category-btn.active {
            background: #6d4c41;
            color: white;
            transform: translateY(-2px);
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
            margin-bottom: 5px;
        }
        
        /* Loading Spinner */
        .loading {
            text-align: center;
            padding: 50px;
            color: #efebe9;
            font-size: 18px;
        }
        
        /* Empty State */
        .empty-products {
            text-align: center;
            padding: 60px;
            background: #efebe9;
            border-radius: 15px;
            color: #6d4c41;
        }
        
        .empty-products .icon {
            font-size: 64px;
            margin-bottom: 20px;
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
            .header {
                flex-direction: column;
                text-align: center;
            }
            .products-grid {
                grid-template-columns: 1fr;
            }
            .category-filter {
                gap: 8px;
            }
            .category-btn {
                padding: 6px 15px;
                font-size: 12px;
            }
        }
    </style>
</head>
<body>

<!-- Header -->
<div class="header">
    <div class="logo">
        <a href="customerDashboard.jsp">
            <h2> Coffee Shop</h2>
        </a>
    </div>
    <div class="header-actions">
        <a href="customerDashboard.jsp" class="back-btn">? Back to Dashboard</a>
    </div>
</div>

<!-- Main Content -->
<div class="container">
    <div class="welcome-banner">
        <h1> Our Premium Menu</h1>
        <p>Browse our selection of finest coffee, tea, pastries, and more!</p>
    </div>
    
    <!-- Category Filter -->
    <div class="category-filter" id="categoryFilter">
        <button class="category-btn active" data-category="all">All</button>
        <button class="category-btn" data-category="Coffee"> Coffee</button>
        <button class="category-btn" data-category="Tea">Tea</button>
        <button class="category-btn" data-category="Pastry"> Pastry</button>
        <button class="category-btn" data-category="Cake"> Cake</button>
        <button class="category-btn" data-category="Sandwich"> Sandwich</button>
        <button class="category-btn" data-category="Specialty">Specialty</button>
        <button class="category-btn" data-category="Addons"> Add-ons</button>
    </div>
    
    <!-- Products Grid -->
    <div class="products-grid" id="productsGrid">
        <div class="loading">Loading delicious products...</div>
    </div>
</div>

<!-- Footer -->
<div class="footer">
    <p>&copy; 2024 Coffee Shop System. All rights reserved.</p>
    <p>Serving you the best coffee experience!</p>
</div>

<script>
    let allProducts = [];
    
    // Load products on page load
    document.addEventListener('DOMContentLoaded', function() {
        loadProductsFromDatabase();
    });
    
    // Load products from database via servlet
    function loadProductsFromDatabase() {
        fetch('ProductServlet')
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                console.log('Products loaded:', data.length);
                allProducts = data;
                displayProducts(allProducts);
            })
            .catch(error => {
                console.error('Error loading products:', error);
                document.getElementById('productsGrid').innerHTML = `
                    <div class="empty-products">
                        <div class="icon">??</div>
                        <h3>Unable to load products</h3>
                        <p>Please check your database connection and try again.</p>
                        <button onclick="location.reload()" style="margin-top:15px; padding:10px 20px; background:#6d4c41; color:white; border:none; border-radius:5px; cursor:pointer;">Refresh</button>
                    </div>
                `;
            });
    }
    
    function displayProducts(products) {
        const container = document.getElementById('productsGrid');
        
        if (products.length === 0) {
            container.innerHTML = `
                <div class="empty-products">
                    <div class="icon">??</div>
                    <h3>No products found</h3>
                    <p>No products available in this category.</p>
                </div>
            `;
            return;
        }
        
        let html = '';
        products.forEach(product => {
            let icon = getProductIcon(product.productName);
            let price = parseFloat(product.price).toFixed(2);
            let size = product.size || 'Regular';
            
            html += `
                <div class="product-card">
                    <div class="product-image">${icon}</div>
                    <div class="product-info">
                        <div class="product-name">${escapeHtml(product.productName)}</div>
                        <div class="product-price">RM ${price}</div>
                        <div class="product-size">${escapeHtml(size)}</div>
                    </div>
                </div>
            `;
        });
        container.innerHTML = html;
    }
    
    
    function getProductIcon(productName) {
        const name = productName.toLowerCase();
        if (name.includes('espresso') || name.includes('latte') || name.includes('cappuccino') || 
            name.includes('mocha') || name.includes('americano') || name.includes('caramel')) return '?';
        if (name.includes('tea') || name.includes('matcha') || name.includes('chai')) return '?';
        if (name.includes('croissant') || name.includes('muffin') || name.includes('roll') || name.includes('pastry')) return '?';
        if (name.includes('cake') || name.includes('cheesecake') || name.includes('tiramisu') || 
            name.includes('brownie') || name.includes('cookie') || name.includes('red velvet')) return '?';
        if (name.includes('sandwich')) return '?';
        if (name.includes('frappuccino') || name.includes('cold brew') || name.includes('signature')) return '?';
        if (name.includes('shot') || name.includes('whipped') || name.includes('milk')) return '?';
        return '?';
    }
    
    
        displayProducts(filtered);
    }
</script>

</body>
</html>
