import ballerinax/kafka;

final kafka:Producer orderProducer = check new ("localhost:9092");

public function publishOrderCreated(Order order) returns error? {
    check orderProducer->send({
        topic: "orders.created",
        value: order
    });
}