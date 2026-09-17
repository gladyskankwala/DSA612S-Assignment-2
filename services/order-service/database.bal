import ballerinax/mongodb;

public function addOrder(Order orderr) returns boolean|error {
    error? result = orderCollection ->insertOne(orderr);
    if result is error {
        return result;
    }

    return true;
}

public function getOrder(string orderId) returns Order|error? {
    map<json> filter = {
        orderId: orderId
    };

    Order|error? result = orderCollection->findOne(
        filter,
        {},
        (),
        Order
    );

    return result;
} 


public function getAllOrders() returns Order[]|error {
    map<json> filter = {};

    stream<Order, error?>|error result = orderCollection->find(
        filter,
        {},
        (),
        Order
    );

    if result is error {
        return result;
    }

    Order[] orders = check from Order orderr in result
        select orderr;

    check result.close();
    return orders;

}


public function updateOrder(Order orderr) returns boolean|error {
    map<json> filter = {
        orderId: orderr.orderId
    };

    mongodb:Update update = {
        set: orderr
    };

    mongodb:UpdateResult|error result = orderCollection->updateOne(
        filter,
        update,
        {}
    );

    if result is error {
        return result;
    }

    return result.matchedCount > 0;
}

public function deleteOrder(string orderId) returns boolean|error {
    map<json> filter = {
        orderId: orderId
    };

    mongodb:DeleteResult|error result = orderCollection->deleteOne(filter);

    if result is error {
        return result;
    }

    return result.deletedCount > 0;
}