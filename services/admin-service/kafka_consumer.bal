import ballerina/log;
import ballerinax/kafka;

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