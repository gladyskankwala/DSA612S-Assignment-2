import ballerinax/kafka;

listener kafka:Listener orderListener = check new (kafkaBootstrapServers, {
    groupId: "payment-group",
    topics: ["orders.created"]
});
