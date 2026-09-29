public type AdminStats record {|
    int totalOrders;
    int completedPayments;
    int failedPayment;
|};

public type OrderEvent record {
    string orderId;
    string customerId;
    string restaurentId;
    decimal totalAmount;
    string status;
    
};

public type PaymentEvent record {
    string paymentId;
    string orderId;
    string customerId;
    decimal amount;
    string status;
};