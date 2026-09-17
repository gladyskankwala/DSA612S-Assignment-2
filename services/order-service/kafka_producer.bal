import ballerinax/kafka;

configurable string kafkaUrl = ?;

final kafka:Producer producer = check new (kafkaUrl);

public function publishOrderCreated(Order orderr) returns error? {
    check producer->send({
        topic: "orders.created",
        value: orderr
    });
}

public function publishOrderStatusUpdated(Order updatedOrder) returns error? {
    check producer ->send({
        topic: "orders.status.updated",
        value:  updatedOrder
    });
}