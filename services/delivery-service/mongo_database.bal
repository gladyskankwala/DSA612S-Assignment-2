import ballerina/log;
import ballerinax/mongodb;

final mongodb:Database deliveryDatabase;
final mongodb:Collection deliveryCollection;
final mongodb:Collection driverCollection;

function init() returns error? {
    deliveryDatabase = check mongoClient->getDatabase("delivery_db");
    deliveryCollection = check deliveryDatabase->getCollection("deliveries");
    driverCollection = check deliveryDatabase->getCollection("drivers");
    check seedDrivers();
}

function seedDrivers() returns error? {
    Driver[] existing = check findDrivers({});
    if existing.length() > 0 {
        return;
    }
    string[] names = ["Driver Alpha", "Driver Bravo", "Driver Charlie"];
    foreach string n in names {
        check insertDriver({driverId: newId("DRV"), name: n, available: true});
    }
    log:printInfo("Seeded demo drivers");
}
