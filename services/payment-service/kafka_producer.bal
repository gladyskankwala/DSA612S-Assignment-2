import ballerina/io;
import ballerinax/kafka;

configurable string kafkaBootstrapServers = "localhost:9092";

kafka:Producer producer = check new (kafkaBootstrapServers);

function publishPayment(Payment payment) returns error? {
    string topic = "payments.completed";
    if payment.status == "FAILED" {
        topic = "payments.failed";
    }

    check producer->send({topic: topic, value: payment});

    io:println("Payment " + payment.status + " sent to " + topic);
}