import ballerina/http;

service on orderListener {

    remote function onConsumerRecord(Order[] orders) returns error? {
        foreach Order ord in orders {
            Payment payment = processOrder(ord);
            check savePayment(payment);
            check publishPayment(payment);
        }
    }
}

service /payments on new http:Listener(8084) {

    resource function get [string orderId]() returns Payment|string {
        Payment? p = getPayment(orderId);
        if p is Payment {
            return p;
        }
        return "Payment not found";
    }

    resource function get all() returns Payment[]|error {
        return getAllPayments();
    }

    resource function put [string paymentId]/status(string status) returns string|error {
        check updatePaymentStatus(paymentId, status);
        return "Payment status updated successfully";
    }
}
