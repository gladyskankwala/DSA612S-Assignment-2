import ballerina/io;
import ballerinax/mongodb;

configurable string mongodbUri = "mongodb://localhost:27017";
configurable string databaseName = "food_delivery";
configurable string collectionName = "payments";

mongodb:Client mongoClient = check new (mongodbUri);
mongodb:Database database = check mongoClient->getDatabase(databaseName);
mongodb:Collection paymentCollection = check database->getCollection(collectionName);

function savePayment(Payment payment) returns error? {
    check paymentCollection->insertOne(payment);
    io:println("Payment saved to MongoDB: " + payment.paymentId);
}

function getPayment(string orderId) returns Payment? {
    Payment|error result = paymentCollection->findOne({orderId: orderId}, Payment);

    if result is Payment {
        return result;
    }

    if result is error {
        io:println("Error retrieving payment: " + result.message());
    }

    return ();
}

function updatePaymentStatus(string paymentId, string status) returns error? {
    check paymentCollection->updateOne({paymentId: paymentId}, {set: {status: status}});
    io:println("Payment status updated: " + paymentId + " -> " + status);
}

function getAllPayments() returns Payment[]|error {
    return paymentCollection->find({}, Payment);
}

function closeMongoConnection() returns error? {
    check mongoClient->close();
}
