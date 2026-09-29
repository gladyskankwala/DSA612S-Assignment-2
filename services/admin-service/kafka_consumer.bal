import ballerina/log;
import ballerinax/kafka;


configurable string kafkaBootStrapServers = "localhost:9092";

listener kafka:Listener ordersListener = new (kafkaBootStrapServers, {
    groupId: "admin-service-group",
    topics: ["orders.created"],
    offsetReset: "earliest"
});

listener kafka:Listener completedPaymentsListener = new (kafkaBootStrapServers, {
    groupId: "admin-service-group",
    topics: ["payments.completed"],
    offsetReset: "earliest"
});


listener kafka:Listener failedPaymentsListener = new (kafkaBootStrapServers, {
    groupId: "admin-service-group",
    topics: ["payments.failed"],
    offsetReset: "earliest"
});

service on completedPaymentsListener {
    remote function onConsumerRecord(PaymentEvent[] events) returns error? {
        foreach PaymentEvent event in events {
            completedPayments += 1;
            log:printInfo("Admin received completed payment: " + event.paymentId);
        }


    }
}

service on ordersListener {
    remote function onConsumerRecord(OrderEvent[] events) returns error? {
        foreach OrderEvent event in events {
            totalOrders += 1;
            log:printInfo("Admin received new order: " + event.orderId);


        }
    }
}


service on failedPaymentsListener {
    remote function onConsumerRecord(PaymentEvent[] events) returns error? {
        foreach PaymentEvent event in events {
            failedPayments += 1;
            log:printInfo("Admin received failed payment: " + event.paymentId);
        }
    }

    
}