<%-- 
    Document   : product
    Created on : Apr 29, 2026
    Author     : auni
    Description: Display all products from database (Beverages Only) - Direct DB Connection
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
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #3e2723;
            min-height: 100vh;
        }

        .header {
            background: #4e342e;
            color: white;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }

        .header h1 {
            font-size: 28px;
        }

        .header p {
            font-size: 14px;
            opacity: 0.8;
            margin-top: 5px;
        }

        .back-btn {
            display: inline-block;
            margin-top: 10px;
            background: #8d6e63;
            color: white;
            padding: 8px 20px;
            text-decoration: none;
            border-radius: 5px;
            font-size: 14px;
        }

        .back-btn:hover {
            background: #5d4037;
        }

        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .welcome {
            background: linear-gradient(135deg, #6d4c41, #4e342e);
            color: white;
            padding: 25px;
            border-radius: 12px;
            text-align: center;
            margin-bottom: 30px;
        }

        .welcome h2 {
            margin-bottom: 10px;
        }

        /* Category Filter */
        .filter {
            text-align: center;
            margin-bottom: 30px;
        }

        .filter-btn {
            background: #efebe9;
            border: none;
            padding: 10px 20px;
            margin: 5px;
            border-radius: 25px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }

        .filter-btn:hover, .filter-btn.active {
            background: #6d4c41;
            color: white;
        }

        /* Products Grid */
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 25px;
        }

        .card {
            background: #efebe9;
            border-radius: 12px;
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
        }

        .card-icon {
            background: linear-gradient(135deg, #6d4c41, #4e342e);
            height: 150px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 60px;
        }

        .card-info {
            padding: 20px;
            text-align: center;
        }

        .card-name {
            font-size: 18px;
            font-weight: bold;
            color: #4e342e;
            margin-bottom: 8px;
        }

        .card-price {
            font-size: 22px;
            color: #6d4c41;
            font-weight: bold;
            margin: 10px 0;
        }

        .card-size {
            font-size: 12px;
            color: #8d6e63;
        }

        .footer {
            background: #4e342e;
            color: #d7ccc8;
            text-align: center;
            padding: 20px;
            margin-top: 50px;
        }

        @media (max-width: 768px) {
            .grid {
                grid-template-columns: 1fr;
            }
            .filter-btn {
                padding: 6px 12px;
                font-size: 12px;
            }
        }
    </style>
</head>
<body>

<div class="header">
    <h1>☕ Coffee Shop</h1>
    <p>Premium Beverages</p>
    <a href="customerDashboard.jsp" class="back-btn">← Back to Dashboard</a>
</div>

<div class="container">
    <div class="welcome">
        <h2>Welcome back, <%= username %>! 👋</h2>
        <p>What would you like to drink today?</p>
    </div>

    <!-- Category Filter -->
    <div class="filter">
        <button class="filter-btn active" onclick="filterProducts('all')">All</button>
        <button class="filter-btn" onclick="filterProducts('Coffee')">☕ Coffee</button>
        <button class="filter-btn" onclick="filterProducts('Tea')">🍵 Tea</button>
        <button class="filter-btn" onclick="filterProducts('Other')">🥤 Other</button>
    </div>

    <!-- Products Grid -->
    <div class="grid" id="productsGrid">
        <%
            // Direct database connection
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dassystem", "root", "admin");
                
                String sql = "SELECT productID, productName, price, size FROM product WHERE availability_status = 'Available' ORDER BY productName";
                stmt = conn.createStatement();
                rs = stmt.executeQuery(sql);
                
                boolean hasProducts = false;
                while(rs.next()) {
                    hasProducts = true;
                    String productName = rs.getString("productName");
                    double price = rs.getDouble("price");
                    String size = rs.getString("size");
                    int productID = rs.getInt("productID");
                    
                    // Determine icon and category based on product name
                    String icon = "☕";
                    String category = "Coffee";
                    String nameLower = productName.toLowerCase();
                    
                    if(nameLower.contains("tea") || nameLower.contains("matcha") || nameLower.contains("chai")) {
                        icon = "🍵";
                        category = "Tea";
                    } else if(nameLower.contains("chocolate") || nameLower.contains("hot chocolate")) {
                        icon = "🍫";
                        category = "Other";
                    } else if(nameLower.contains("cold brew") || nameLower.contains("signature")) {
                        icon = "🥤";
                        category = "Other";
                    } else {
                        icon = "☕";
                        category = "Coffee";
                    }
        %>
                    <div class="card" data-category="<%= category %>">
                        <div class="card-icon"><%= icon %></div>
                        <div class="card-info">
                            <div class="card-name"><%= productName %></div>
                            <div class="card-price">RM <%= String.format("%.2f", price) %></div>
                            <div class="card-size"><%= size %></div>
                        </div>
                    </div>
        <%
                }
                
                if(!hasProducts) {
        %>
                    <div style="text-align: center; padding: 50px; background: #efebe9; border-radius: 12px;">
                        <h3>No products available</h3>
                        <p>Please check back later.</p>
                    </div>
        <%
                }
                
            } catch(Exception e) {
                e.printStackTrace();
        %>
                <div style="text-align: center; padding: 50px; background: #efebe9; border-radius: 12px;">
                    <h3>Error loading products</h3>
                    <p>Database connection error. Please try again.</p>
                </div>
        <%
            } finally {
                try {
                    if(rs != null) rs.close();
                    if(stmt != null) stmt.close();
                    if(conn != null) conn.close();
                } catch(SQLException e) {}
            }
        %>
    </div>
</div>

<div class="footer">
    <p>&copy; 2024 Coffee Shop System - Serving the best beverages</p>
</div>

<script>
    // Filter function for categories
    function filterProducts(category) {
        // Update active button
        document.querySelectorAll('.filter-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        event.target.classList.add('active');
        
        // Get all product cards
        const cards = document.querySelectorAll('.card');
        
        if (category === 'all') {
            // Show all cards
            cards.forEach(card => {
                card.style.display = 'block';
            });
        } else {
            // Filter by category
            cards.forEach(card => {
                const cardCategory = card.getAttribute('data-category');
                if (cardCategory === category) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        }
    }
</script>

</body>
</html>
