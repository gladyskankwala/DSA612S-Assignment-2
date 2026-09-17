import ballerina/log;
import ballerinax/kafka;



kafka:ConsumerConfiguration consumerConfig = {
    groupId: "order-service-group",
    topics: ["orders.created"],
    offsetReset: "earliest"
};

listener kafka:Listener kafkaListener = new (kafkaUrl, consumerConfig);

service on kafkaListener {

    remote function onConsumerRecord(kafka:Caller caller, kafka:BytesConsumerRecord[] records) returns error? {

        foreach kafka:BytesConsumerRecord recordd in records {
            log:printInfo("Received order event from Kafka");
            log:printInfo(recordd.value.toString());
        }
    }
}