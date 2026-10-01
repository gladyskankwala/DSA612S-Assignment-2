import ballerina/log;
import ballerinax/kafka;

listener kafka:Listener orderReadyListener = new (kafkaUrl, {
    groupId: "delivery-service-group",
    topics: ["orders.ready"],
    offsetReset: "earliest"
});

service on orderReadyListener {

    remote function onConsumerRecord(OrderEvent[] events) returns error? {
        foreach OrderEvent e in events {
            log:printInfo("DELIVERY SERVICE received orders.ready for " + e.orderId);
            error? r = handleOrderReady(e);
            if r is error {
                log:printError("Failed to handle order " + e.orderId, r);
            }
        }
    }
}
