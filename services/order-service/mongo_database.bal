import ballerinax/mongodb;

final mongodb:Database orderDatabase;
final mongodb:Collection orderCollection;

function init() returns error? {
    orderDatabase = check mongoClient->getDatabase("food_delivery");
    orderCollection = check orderDatabase->getCollection("orders");
}