type Order record {
    string orderId;
    string customerId;
    decimal amount;
};

type Payment record {
    string paymentId;
    string orderId;
    string customerId;
    decimal amount;
    string status;
};