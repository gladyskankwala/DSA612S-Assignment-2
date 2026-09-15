import ballerinax/kafka;

final kafka:Producer producer = check new ("localhost:9092");

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