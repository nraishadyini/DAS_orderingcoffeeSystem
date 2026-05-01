<%@ page import="java.sql.*" %>
<%
    // Check if customer is logged in
    if(session.getAttribute("username") == null || 
       !"customer".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String orderID = request.getParameter("orderID");
    String totalAmount = request.getParameter("total");
    String error = request.getParameter("error");
    
    if (orderID == null || totalAmount == null) {
        response.sendRedirect("product.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Payment - Coffee Shop</title>
    <meta charset="UTF-8">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: Arial, sans-serif;
            background: rgba(0,0,0,0.5);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        
        .payment-modal {
            background: #efebe9;
            border-radius: 15px;
            padding: 30px;
            width: 90%;
            max-width: 450px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
            animation: slideDown 0.3s ease;
        }
        
        @keyframes slideDown {
            from { transform: translateY(-50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        
        .payment-header {
            text-align: center;
            margin-bottom: 25px;
        }
        
        .payment-header h2 {
            color: #4e342e;
            margin-bottom: 5px;
        }
        
        .order-info {
            background: #d7ccc8;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        
        .order-info p {
            margin: 5px 0;
            color: #4e342e;
        }
        
        .payment-methods {
            margin-bottom: 20px;
        }
        
        .payment-method {
            background: white;
            border: 2px solid #d7ccc8;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .payment-method:hover {
            border-color: #6d4c41;
            background: #efebe9;
        }
        
        .payment-method.selected {
            border-color: #4caf50;
            background: #e8f5e9;
        }
        
        .method-icon {
            font-size: 32px;
        }
        
        .method-info h4 {
            color: #4e342e;
            margin-bottom: 5px;
        }
        
        .method-info p {
            font-size: 12px;
            color: #8d6e63;
        }
        
        .card-details {
            display: none;
            background: white;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        
        .card-details input {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            border: 1px solid #d7ccc8;
            border-radius: 5px;
            box-sizing: border-box;
        }
        
        .card-row {
            display: flex;
            gap: 10px;
        }
        
        .card-row input {
            flex: 1;
        }
        
        .payment-btn {
            background: #6d4c41;
            color: white;
            border: none;
            padding: 12px;
            border-radius: 8px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
            margin-top: 10px;
        }
        
        .payment-btn:hover {
            background: #5d4037;
        }
        
        .error {
            color: #f44336;
            text-align: center;
            margin-top: 10px;
            font-size: 14px;
        }
        
        .loading {
            text-align: center;
            padding: 20px;
            display: none;
        }
    </style>
</head>
<body>

<div class="payment-modal">
    <div class="payment-header">
        <h2>💳 Payment</h2>
        <p>Complete your order payment</p>
    </div>
    
    <div class="order-info">
        <p><strong>Order ID:</strong> #<%= orderID %></p>
        <p><strong>Total Amount:</strong> RM <%= String.format("%.2f", Double.parseDouble(totalAmount)) %></p>
    </div>
    
    <form action="ProcessPaymentServlet" method="post" id="paymentForm">
        <input type="hidden" name="orderID" value="<%= orderID %>">
        <input type="hidden" name="totalAmount" value="<%= totalAmount %>">
        <input type="hidden" name="paymentMethod" id="selectedPaymentMethod" value="">
        
        <div class="payment-methods">
            <div class="payment-method" data-method="Credit Card" onclick="selectMethod('Credit Card')">
                <div class="method-icon">💳</div>
                <div class="method-info">
                    <h4>Credit / Debit Card</h4>
                    <p>Pay with credit or debit card</p>
                </div>
            </div>
            
            <div class="payment-method" data-method="Cash" onclick="selectMethod('Cash')">
                <div class="method-icon">💵</div>
                <div class="method-info">
                    <h4>Cash</h4>
                    <p>Pay with cash on delivery/pickup</p>
                </div>
            </div>
        </div>
        
        <div id="cardDetails" class="card-details">
            <h4>Card Details</h4>
            <input type="text" id="cardNumber" placeholder="Card Number">
            <div class="card-row">
                <input type="text" id="expiryDate" placeholder="MM/YY">
                <input type="text" id="cvv" placeholder="CVV">
            </div>
            <input type="text" id="cardName" placeholder="Cardholder Name">
        </div>
        
        <button type="button" class="payment-btn" onclick="submitPayment()">Pay Now</button>
        <div id="loading" class="loading">Processing payment...</div>
        
        <% if (error != null) { %>
            <div class="error"><%= error %></div>
        <% } %>
    </form>
</div>

<script>
    let selectedMethod = '';
    
    function selectMethod(method) {
        selectedMethod = method;
        document.getElementById('selectedPaymentMethod').value = method;
        
        // Update UI
        document.querySelectorAll('.payment-method').forEach(el => {
            el.classList.remove('selected');
        });
        document.querySelector(`[data-method="${method}"]`).classList.add('selected');
        
        // Show/hide card details
        if (method === 'Credit Card') {
            document.getElementById('cardDetails').style.display = 'block';
        } else {
            document.getElementById('cardDetails').style.display = 'none';
        }
    }
    
    function submitPayment() {
        if (!selectedMethod) {
            alert('Please select a payment method');
            return;
        }
        
        if (selectedMethod === 'Credit Card') {
            const cardNumber = document.getElementById('cardNumber').value;
            const expiryDate = document.getElementById('expiryDate').value;
            const cvv = document.getElementById('cvv').value;
            const cardName = document.getElementById('cardName').value;
            
            if (!cardNumber || !expiryDate || !cvv || !cardName) {
                alert('Please fill in all card details');
                return;
            }
        }
        
        // Show loading
        document.getElementById('loading').style.display = 'block';
        document.querySelector('.payment-btn').disabled = true;
        
        // Submit form
        document.getElementById('paymentForm').submit();
    }
</script>

</body>
</html>
