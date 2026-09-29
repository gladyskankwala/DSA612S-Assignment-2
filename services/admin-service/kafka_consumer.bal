import ballerina/log;
import ballerinax/kafka;

<<<<<<< HEAD
configurable string kafkaUrl = ?;

kafka:ConsumerConfiguration consumerConfig = {
    groupId: "admin-service",
    topics:[
        "orders.created",
        "orders.confirmed",
        "orders.preparing",
        "orders.ready",
        "orders.cancelled",
        "payments.completed",
        "payments.failed",
        "delivery.assigned",
        "delivery.completed"
    ],

    offsetReset: "earliest"
};

listener kafka:Listener adminKafkaListener = new (kafkaUrl,consumerConfig);

    service on adminKafkaListener {

        remote function onConsumerRecord(
            kafka:Caller caller,
            kafka:BytesConsumerRecord[] records
        ) returns error? {

            foreach kafka:BytesConsumerRecord recordd in records{

                string eventData = recordd.value.toString();

                string eventType =
                        recordd.offset.partition.topic;

                log:printInfo(
                    "=============================="
                );

                log:printInfo(
                    "ADMIN SERVICE"
                );

                log:printInfo(
                    "Received order event from kafka"
                );

                log:printInfo(
                    "Event Type: " + eventType
                );

                log:printInfo(
                    "Event Data:" + eventData);

                updateStatistics(eventType);

                log:printInfo(
                    "Admin statistics updated"
                );

                log:printInfo(
                    "================================="
                );
            }
        }
    }
=======

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
>>>>>>> 7b27d0f4ce21753f6be1b29a9801588f24baa9d7
