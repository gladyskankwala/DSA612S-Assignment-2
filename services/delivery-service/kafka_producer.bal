import ballerina/log;
import ballerinax/kafka;

configurable string kafkaUrl = "localhost:9092";

final kafka:Producer producer = check new (kafkaUrl, {
    acks: kafka:ACKS_ALL,
    retryCount: 3
});

function publishDeliveryEvent(string topic, Delivery d) returns error? {
    DeliveryEvent event = {
        deliveryId: d.deliveryId,
        orderId: d.orderId,
        customerId: d.customerId,
        restaurantId: d.restaurantId,
        driverId: d.driverId,
        status: d.status,
        timestamp: nowStr()
    };
    check producer->send({topic: topic, key: d.orderId.toBytes(), value: event});
    log:printInfo("Published to " + topic + " for order " + d.orderId);
}
