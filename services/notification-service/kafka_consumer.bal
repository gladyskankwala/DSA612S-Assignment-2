import ballerina/log;
import ballerinax/kafka;

configurable string kafkaUrl = ?;

kafka:ConsumerConfiguration consumerConfig = {
    groupId: "notification-service",
    topics: ["orders.created",
            "orders.confirmed",
            "orders.preparing",
            "orders.ready",
            "orders.cancelled",
            "payments.completed",
            "payments.failed",
            "delivery.assigned",
             "delivery.completed"],
        offsetReset: "earliest"
};


    listener kafka:Listener kafkaListener =
        new (kafkaUrl, consumerConfig);


        service on kafkaListener {

            remote function onConsumerRecord (
                kafka:Caller caller,
                kafka:BytesConsumerRecord[] records
            ) returns error?  {

                foreach kafka:BytesConsumerRecord recordd in records {

                    string eventData = check string:fromBytes(recordd.value);

                    string eventType = recordd.offset.partition.topic;

                    log:printInfo("NOTIFICATION SERVICE");

                    log:printInfo("Order event received");

                    log:printInfo("Event type: " + eventType);
                    
                    log:printInfo("Event Data: " + eventData);

                    createOrderNotification(
                        eventType,
                        eventData);

                    log:printInfo(
                        "Notification generated New order "
                    );
                    log:printInfo(
                        "==================================="
                    );

                }
            }
        }