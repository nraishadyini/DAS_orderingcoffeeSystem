<%-- 
    Document   : product
    Created on : Apr 29, 2026
    Author     : auni
    Description: Display all products from database in grid layout (Display Only)
--%>

<%@ page import="java.sql.*, java.util.*" %>
<%
    if(session.getAttribute("username") == null || 
       !"customer".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Our Menu - Coffee Shop</title>

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', Arial;
            background: #3e2723;
        }

        .header {
            background: #4e342e;
            color: white;
            padding: 15px;
            text-align: center;
        }

        .container {
            padding: 20px;
            max-width: 1200px;
            margin: auto;
        }

        .filter {
            text-align: center;
            margin: 20px 0;
        }

        .btn {
            padding: 10px 15px;
            margin: 5px;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            background: #efebe9;
        }

        .btn.active {
            background: #6d4c41;
            color: white;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 20px;
        }

        .card {
            background: #efebe9;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
        }

        .icon {
            font-size: 40px;
        }

        .price {
            color: #6d4c41;
            font-weight: bold;
        }
    </style>
</head>

<body>

<div class="header">
    ☕ Coffee Menu
</div>

<div class="container">

    <!-- FILTER -->
    <div class="filter">
        <button class="btn active" onclick="filter('all')">All</button>
        <button class="btn" onclick="filter('Coffee')">Coffee</button>
        <button class="btn" onclick="filter('Tea')">Tea</button>
        <button class="btn" onclick="filter('Food')">Food</button>
        <button class="btn" onclick="filter('Dessert')">Dessert</button>
    </div>

    <!-- GRID -->
    <div class="grid" id="grid"></div>

</div>

<script>

let allProducts = [
    // ☕ COFFEE
    {name:"Espresso", price:6, category:"Coffee", icon:"☕"},
    {name:"Latte", price:10, category:"Coffee", icon:"☕"},
    {name:"Cappuccino", price:10, category:"Coffee", icon:"☕"},
    {name:"Mocha", price:12, category:"Coffee", icon:"☕"},
    {name:"Americano", price:8, category:"Coffee", icon:"☕"},

    // 🍵 TEA
    {name:"Green Tea", price:7, category:"Tea", icon:"🍵"},
    {name:"Milk Tea", price:8, category:"Tea", icon:"🍵"},
    {name:"Matcha Latte", price:11, category:"Tea", icon:"🍵"},

    // 🍔 FOOD
    {name:"Chicken Sandwich", price:12, category:"Food", icon:"🍔"},
    {name:"Beef Burger", price:15, category:"Food", icon:"🍔"},
    {name:"Club Sandwich", price:14, category:"Food", icon:"🍔"},

    // 🍰 DESSERT
    {name:"Cheesecake", price:14, category:"Dessert", icon:"🍰"},
    {name:"Chocolate Cake", price:13, category:"Dessert", icon:"🍰"},
    {name:"Brownie", price:9, category:"Dessert", icon:"🍰"}
];

// =======================
// DISPLAY FUNCTION
// =======================
function display(list) {
    let html = "";

    list.forEach(p => {
        html += `
        <div class="card">
            <div class="icon">${p.icon}</div>
            <h3>${p.name}</h3>
            <p class="price">RM ${p.price.toFixed(2)}</p>
            <p>${p.category}</p>
        </div>`;
    });

    document.getElementById("grid").innerHTML = html;
}

function filter(type) {

    document.querySelectorAll(".btn").forEach(b => b.classList.remove("active"));
    event.target.classList.add("active");

    if(type === "all") {
        display(allProducts);
    } else {
        let filtered = allProducts.filter(p => p.category === type);
        display(filtered);
    }
}

display(allProducts);

</script>

</body>
</html>
