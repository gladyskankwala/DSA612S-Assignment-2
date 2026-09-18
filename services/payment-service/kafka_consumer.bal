import ballerinax/kafka;

listener kafka:Listener orderListener = new (kafkaBootstrapServers, {
    groupId: "payment-group",
    topics: ["orders.created"]
});