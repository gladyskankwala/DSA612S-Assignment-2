import ballerina/io;

map<Payment> payments = {};
int counter = 0;

function processOrder(Order ord) returns Payment {
    io:println("New order received: " + ord.orderId);

    counter = counter + 1;
    string paymentId = "PAY-" + counter.toString();

    string status = "COMPLETED";
    if ord.totalAmount <= 0d || ord.totalAmount > 5000d {
        status = "FAILED";
    }

    Payment payment = {
        paymentId: paymentId,
        orderId: ord.orderId,
        customerId: ord.customerId,
        amount: ord.totalAmount,
        status: status
    };

    payments[ord.orderId] = payment;

    return payment;
}

function getPayment(string orderId) returns Payment? {
    return payments[orderId];
}