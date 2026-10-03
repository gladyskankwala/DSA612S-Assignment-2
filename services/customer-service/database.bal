import ballerinax/mongodb;


public function createCustomer(Customer customer) returns error?{

    map<json> document = {
        customerId: customer.customerId,
        name: customer.name,
        email: customer.email,
        phone: customer.phone,
        addresses: customer.addresses,
        orderHistory: customer.orderHistory
    };

    check customerCollection->insertOne(document);

}

public function getCustomer(string customerId) returns Customer|error {

    var result = customerCollection->findOne(
        {customerId: customerId},
        {},
        (),
        Customer
    );

    if result is error {
        return result;
    }

    if result is () {
        return error("Customer not found");
    }

    return result;
}


public function getCustomers() returns Customer[]|error {

    Customer[] customers = [];

    var result = customerCollection->find(
        {},
        {},
        (),
        Customer
    );

    if result is error {
        return result;
    }

    check from Customer customer in result

        do {
            customers.push(customer);
        };

        check result.close();

        return customers;
}

public function updateCustomer (
    string customerId,
    Customer customer
) returns error? {

    mongodb:Update update = {
        set:{
        name: customer.name,
        email: customer.email,
        phone: customer.phone,
        addresses: customer.addresses,
        orderHistory: customer.orderHistory
    }
};

    var result = customerCollection->updateOne(
        {customerId: customerId},
        update
    );

    if result is error {
        return result;
    }
}


public function deleteCustomer (
    string customerId
) returns error? {
    var result = customerCollection->deleteOne(
        {customerId: customerId}
    );

    if result is error {
        return result;
    }
}

public function addOrderHistory (
    string customerId,
    OrderHistory history
) returns error? {

    var customerResult = customerCollection->findOne(
        {customerId: customerId},
        {},
        (),
        Customer
    );

    if customerResult is error {
        return customerResult;
    }

    if customerResult is () {
        return error("Customer not found");

    }

    Customer customer = customerResult;

    OrderHistory[] updatedHistory = customer.orderHistory;

    updatedHistory.push(history);

    mongodb:Update update = {
        set: {
            orderHistory:updatedHistory
        }
    };
    
    var result = customerCollection->updateOne(
        {customerId: customerId},
        update
    );

    if result is error {
        return result;
    }
}

public function getOrderHistory(
    string customerId
) returns OrderHistory[]|error {
    
    var result = customerCollection->findOne(
        {customerId:customerId},
        {},
        (),
        Customer
    );

    if result is error {
        return result;
    }

    if result is () {
        return error ("Customer not found");
    }

    return result.orderHistory;
}