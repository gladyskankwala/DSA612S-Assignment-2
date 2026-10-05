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

@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"],
        allowMethods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
        allowHeaders: ["*"]
    }
}

service /payments on new http:Listener(8084) {

    resource function get [string orderId]() returns Payment|string|error {
        Payment|error? p = getPayment(orderId);

        if p is error {
            return p;
        }

        if p is Payment {
            return p;
        }

        return "Payment not found";
    }
}
