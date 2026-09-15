import ballerina/http;
import ballerina/io;
import ballerinax/kafka;

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

map<Payment> payments = {};
int counter = 0;

kafka:Producer producer = check new ("localhost:9092");

listener kafka:Listener orderListener = new ("localhost:9092", {
    groupId: "payment-group",
    topics: ["orders.created"]
});

service on orderListener {

    remote function onConsumerRecord(Order[] orders) returns error? {

        foreach Order ord in orders {
            io:println("New order received: " + ord.orderId);

            counter = counter + 1;
            string paymentId = "PAY-" + counter.toString();

            string status = "COMPLETED";
            if ord.amount <= 0d || ord.amount > 5000d {
                status = "FAILED";
            }

            Payment payment = {
                paymentId: paymentId,
                orderId: ord.orderId,
                customerId: ord.customerId,
                amount: ord.amount,
                status: status
            };

            payments[ord.orderId] = payment;

            string topic = "payments.completed";
            if status == "FAILED" {
                topic = "payments.failed";
            }

            check producer->send({topic: topic, value: payment});

            io:println("Payment " + status + " sent to " + topic);
        }
    }
}

service /payments on new http:Listener(8084) {

    resource function get [string orderId]() returns Payment|string {
        Payment? p = payments[orderId];
        if p is Payment {
            return p;
        }
        return "Payment not found";
    }
}