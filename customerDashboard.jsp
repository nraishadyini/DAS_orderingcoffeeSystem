<%
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
    <title>Customer Dashboard</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #3e2723;
            margin: 0;
        }

        /* Header */
        .header {
            background: #4e342e;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h2 {
            margin: 0;
        }

        .logout {
            background: #8d6e63;
            padding: 8px 15px;
            border-radius: 5px;
            text-decoration: none;
            color: white;
        }

        .logout:hover {
            background: #5d4037;
        }

        /* Container */
        .container {
            max-width: 1100px;
            margin: 30px auto;
            padding: 20px;
        }

        /* Welcome */
        .welcome {
            background: linear-gradient(135deg, #6d4c41, #4e342e);
            color: white;
            padding: 30px;
            border-radius: 15px;
            text-align: center;
        }

        .welcome h1 {
            margin-bottom: 10px;
        }

        /* Menu Cards */
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }

        .card {
            background: #efebe9;
            padding: 25px;
            border-radius: 12px;
            text-align: center;
            text-decoration: none;
            color: #3e2723;
            transition: 0.3s;
        }

        .card:hover {
            transform: translateY(-5px);
            background: #d7ccc8;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .card h3 {
            margin-bottom: 10px;
        }

        .icon {
            font-size: 40px;
            margin-bottom: 10px;
        }
    </style>
</head>

<body>

<!-- Header -->
<div class="header">
    <h2>☕ Coffee Shop</h2>
    <a href="logout.jsp" class="logout">Logout</a>
</div>

<!-- Main -->
<div class="container">

    <div class="welcome">
        <h1>Welcome, <%= username %> 👋</h1>
        <p>What would you like to do today?</p>
    </div>

    <div class="menu-grid">

        <!-- View Menu -->
        <a href="product.jsp" class="card">
            <div class="icon">☕</div>
            <h3>Browse Menu</h3>
            <p>View all available drinks and food</p>
        </a>

  

        <!-- Cart -->
        <a href="cart.jsp" class="card">
            <div class="icon">🛒</div>
            <h3>My Cart</h3>
            <p>View items in your cart</p>
        </a>


</div>

</body>
</html>
