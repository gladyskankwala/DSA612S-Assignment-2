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

    check producer->send({
        topic: "orders.status.updated",
        value: updatedOrder
    });

    string statusTopic = "";

    if updatedOrder.status == CONFIRMED {
        statusTopic = "orders.confirmed";
    } else if updatedOrder.status == PREPARING {
        statusTopic = "orders.preparing";
    } else if updatedOrder.status == READY {
        statusTopic = "orders.ready";
    } else if updatedOrder.status == CANCELLED {
        statusTopic = "orders.cancelled";
    }

    if statusTopic != "" {
        check producer->send({
            topic: statusTopic,
            value: updatedOrder
        });
    }
}