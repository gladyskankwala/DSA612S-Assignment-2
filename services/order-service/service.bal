import ballerina/http;

service /orders on new http:Listener(9091) {
    
    resource function post .(@http:Payload Order orderr) returns http:Created|http:Conflict|error {
        boolean added = check addOrder(orderr);
        if !added {
            return <http:Conflict>{
                body: "Order already exists"
            };
        }

        check  publishOrderCreated(orderr);

        return <http:Created>{
            body: orderr
        };
    }

    resource function get .() returns Order[]|error {
        return check  getAllOrders();
    }
    resource function get [string orderId]() returns Order|http:NotFound|error {
        Order? orderr = check getOrder(orderId);

        if orderr is () {
            return <http:NotFound>{
                body: "Order not found"
            };
        }
        return orderr;
    }

    resource function put [string orderId](@http:Payload Order orderr) returns Order|http:BadRequest|http:NotFound|error {
        if orderr.orderId != orderId {
            return <http:BadRequest>{
                body: "Order ID does not match"
            };
        }
        boolean updated = check updateOrder(orderr);
        if !updated {
            return <http:NotFound>{
                body: "Order not found"
            };
        }
        return orderr;
    }

    resource function delete [string orderId]() returns http:NoContent|http:NotFound|error {
        boolean deleted = check deleteOrder(orderId);
        if !deleted {
            return <http:NotFound>{
                body: "Order not found"
            };
        }
        return <http:NoContent>{};
    }

    resource function patch [string orderId]/status(@http:Payload OrderStatus nextStatus)
    returns Order|http:BadRequest|http:NotFound|error {
        Order? existingOrderr = check getOrder(orderId);
        if existingOrderr is () {
            return <http:NotFound>{
                body: "Order not found"
            };
        }
        if !isValidTransition(existingOrderr.status, nextStatus) {
            return <http:BadRequest>{
                body: "Invalid status transition"
            };
        }

        Order updatedOrder = existingOrderr.clone(); 
        updatedOrder.status =nextStatus;
        _= check updateOrder(updatedOrder);

        check publishOrderStatusUpdated(updatedOrder);

        return updatedOrder;
    }
}