import ballerina/time;
import ballerina/uuid;
import ballerinax/mongodb;

function newId(string prefix) returns string => prefix + "-" + uuid:createType4AsString();

function nowStr() returns string => time:utcToString(time:utcNow());

function insertDelivery(Delivery d) returns error? {
    check deliveryCollection->insertOne(d);
}

function findDelivery(string orderId) returns Delivery|error? {
    map<json> filter = {orderId: orderId};
    return deliveryCollection->findOne(filter, {}, (), Delivery);
}

function findDeliveries(map<json> filter) returns Delivery[]|error {
    stream<Delivery, error?> result = check deliveryCollection->find(filter, {}, (), Delivery);
    Delivery[] out = check from Delivery d in result
        order by d.createdAt ascending
        select d;
    check result.close();
    return out;
}

function updateDeliveryFields(string orderId, map<json> fields) returns boolean|error {
    map<json> filter = {orderId: orderId};
    mongodb:Update update = {set: fields};
    mongodb:UpdateResult result = check deliveryCollection->updateOne(filter, update, {});
    return result.matchedCount > 0;
}

function claimDelivery(string orderId, string driverId) returns boolean|error {
    map<json> filter = {orderId: orderId, status: PENDING};
    mongodb:Update update = {set: {driverId: driverId, status: ASSIGNED, updatedAt: nowStr()}};
    mongodb:UpdateResult result = check deliveryCollection->updateOne(filter, update, {});
    return result.modifiedCount == 1;
}

function insertDriver(Driver d) returns error? {
    check driverCollection->insertOne(d);
}

function findDriver(string driverId) returns Driver|error? {
    map<json> filter = {driverId: driverId};
    return driverCollection->findOne(filter, {}, (), Driver);
}

function findDrivers(map<json> filter) returns Driver[]|error {
    stream<Driver, error?> result = check driverCollection->find(filter, {}, (), Driver);
    Driver[] out = check from Driver d in result
        select d;
    check result.close();
    return out;
}

function updateDriverFields(string driverId, map<json> fields) returns boolean|error {
    map<json> filter = {driverId: driverId};
    mongodb:Update update = {set: fields};
    mongodb:UpdateResult result = check driverCollection->updateOne(filter, update, {});
    return result.matchedCount > 0;
}

function claimDriver(string driverId) returns boolean|error {
    map<json> filter = {driverId: driverId, available: true};
    mongodb:Update update = {set: {available: false}};
    mongodb:UpdateResult result = check driverCollection->updateOne(filter, update, {});
    return result.modifiedCount == 1;
}
