import ballerinax/mongodb;

final mongodb:Database customerDatabese;
final mongodb:Collection customerCollection;

function init() returns error?{
    customerDatabese = check mongoClient->getDatabase("customer_db");

    customerCollection = check customerDatabese->getCollection("customers");

}

