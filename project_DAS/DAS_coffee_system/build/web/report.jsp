<%@ page import="java.util.*" %>
<%
    String role = (String) session.getAttribute("role");

    // =========================
    // SAMPLE DATA (nanti replace DB)
    // =========================
    double totalNetSales = 2462.47;
    double tax = 147.79;
    double totalSales = totalNetSales + tax;

    Map<String, Integer> categoryQty = new LinkedHashMap<>();
    Map<String, Double> categorySales = new LinkedHashMap<>();

    categoryQty.put("Coffee", 120);
    categoryQty.put("Food", 80);
    categoryQty.put("Beverage", 60);

    categorySales.put("Coffee", 1200.50);
    categorySales.put("Food", 900.30);
    categorySales.put("Beverage", 200.97);

    double cash = 532.06;
    double card = 2414.99;
    double giftcard = 30.00;
    double totalPayments = cash + card + giftcard;

    // ROLE CHECK
    if(role == null || !role.trim().equalsIgnoreCase("Store Manager")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Daily Sales Report</title>
    <link rel="stylesheet" href="style.css">

    <style>
        body { font-family: Arial; background:#f5f5f5; }
        .report-container { width: 80%; margin: auto; background: white; padding: 20px; }
        .header { display:flex; justify-content:space-between; border-bottom:1px solid #ccc; }
        .section { margin-top:20px; }
        table { width:100%; border-collapse: collapse; }
        th, td { padding:10px; border-bottom:1px solid #ddd; }
        th { background:#eee; }
        .title { font-weight:bold; margin-bottom:10px; }
    </style>
</head>

<body>

<div class="report-container">

    <!-- HEADER -->
    <div class="header">
        <h2>DAS COFFEE - DAILY REPORT</h2>
        <h3><%= new java.util.Date() %></h3>
    </div>

    <!-- SALES SUMMARY -->
    <div class="section">
        <div class="title">SALES SUMMARY</div>
        <p>Total Net Sales: RM <%= String.format("%.2f", totalNetSales) %></p>
        <p>Tax: RM <%= String.format("%.2f", tax) %></p>
        <p><b>Total Sales: RM <%= String.format("%.2f", totalSales) %></b></p>
    </div>

    <!-- CATEGORY SALES -->
    <div class="section">
        <div class="title">SALES BY CATEGORY</div>

        <table>
            <tr>
                <th>Category</th>
                <th>Quantity</th>
                <th>Net Sales (RM)</th>
            </tr>

            <%
                for(String key : categoryQty.keySet()) {
            %>
            <tr>
                <td><%= key %></td>
                <td><%= categoryQty.get(key) %></td>
                <td><%= String.format("%.2f", categorySales.get(key)) %></td>
            </tr>
            <%
                }
            %>
        </table>
    </div>

    <!-- PAYMENT DETAILS -->
    <div class="section">
        <div class="title">PAYMENT DETAILS</div>

        <table>
            <tr>
                <td>Cash</td>
                <td>RM <%= String.format("%.2f", cash) %></td>
            </tr>
            <tr>
                <td>Card</td>
                <td>RM <%= String.format("%.2f", card) %></td>
            </tr>
            <tr>
                <td>Gift Card</td>
                <td>RM <%= String.format("%.2f", giftcard) %></td>
            </tr>
            <tr>
                <th>Total Payments</th>
                <th>RM <%= String.format("%.2f", totalPayments) %></th>
            </tr>
        </table>
    </div>

    <!-- DISCOUNT -->
    <div class="section">
        <div class="title">DISCOUNTS</div>
        <p>Rewards Used: 5 orders</p>
        <p>Total Discount: RM <%= String.format("%.2f", 21.65) %></p>
    </div>

</div>

</body>
</html>