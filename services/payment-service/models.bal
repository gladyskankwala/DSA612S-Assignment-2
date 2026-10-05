public type Order record {
    string orderId;
    string customerId;
    decimal totalAmount;
};

public type Payment record {
    string paymentId;
    string orderId;
    string customerId;
    decimal amount;
    string status;
};