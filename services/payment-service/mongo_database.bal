import ballerinax/mongodb;

final mongodb:Database paymentDatabase;
final mongodb:Collection paymentCollection;

function init() returns error? {
    paymentDatabase = check mongoClient->getDatabase("food_delivery");
    paymentCollection = check paymentDatabase->getCollection("payments");
}
