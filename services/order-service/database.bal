final map<Order> orders = {};

public function addOrder(Order orderr) returns boolean {
    if orders.hasKey(orderr.customerId) {
        return false;
    }

    orders[orderr.orderId] = orderr;
    return true;
}


public function getOrder(string orderId) returns Order? {
    return orders[orderId];
}

public function getAllOrders() returns Order[] {
    return orders.toArray();
}


public function updateOrder(Order orderr) returns boolean {
    if !orders.hasKey(orderr.orderId) {
        return false;
    }

    orders[orderr.orderId] = orderr;
    return true;
}



public function deleteOrder(string orderId) returns boolean {
    if !orders.hasKey(orderId) {
        return false;
    }

    _=orders.remove(orderId);
    return true;
}