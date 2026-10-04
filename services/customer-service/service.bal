import ballerina/http;

@http:ServiceConfig {
    cors: {
        allowOrigins: ["http://localhost:5500", "http://127.0.0.1:5500"],
        allowMethods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
        allowHeaders: ["Content-Type", "Authorization"]
    }
}

service /customers on new http:Listener(8086) {

    
    

    resource function post .(Customer customer) returns json|error {

        check createCustomer(customer);

        return {
            "message": "Customer created successfully",
            "customerId": customer.customerId
        };
    }

    resource function get .() returns Customer[]|error {

        return getCustomers();
    }

    resource function get [string customerId] () returns Customer|error{
        return getCustomer(customerId);
    }

    
    resource function put [string customerId] (
        Customer customer
    ) returns json|error {

        check updateCustomer (
            customerId,
            customer
        );

        return {
            "message": "Customer updated successfully",
            "customerId": customerId
        };
    }

    resource function delete [ string customerId] () returns json|error {

        check deleteCustomer(customerId);

        return {
            "message": "Customer deleted successfully",
            "customerId": customerId
        };
    }

    resource function post[string customerId]/orders(
        OrderHistory history
    ) returns json|error {

        check addOrderHistory (
            customerId,
            history
        );

        return {
            "message": "Order History added sucessfully",
            "customerId": customerId,
            "orderId": history.orderId
        };
    }

    resource function get [string customerId]/orders()
        returns OrderHistory[]|error {
        return getOrderHistory(customerId);
    }
}

