import ballerina/http;
import ballerina/log;

final map<DeliveryStatus> nextStatus = {
    "ASSIGNED": PICKED_UP,
    "PICKED_UP": IN_TRANSIT,
    "IN_TRANSIT": DELIVERED
};

@http:ServiceConfig {
    cors: {
        allowOrigins: ["http://127.0.0.1:5500", "http://localhost:5500"],
        allowMethods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
        allowHeaders: ["Content-Type"]
    }
}

service /delivery on new http:Listener(8085) {
    resource function get .() returns json {
        return {"service": "delivery-service", "status": "active"};
    }

    resource function get health() returns json {
        return {"service": "delivery-service", "status": "running"};
    }

    resource function get deliveries() returns Delivery[]|error {
        return findDeliveries({});
    }

    resource function get deliveries/[string orderId]() returns Delivery|http:NotFound|error {
        Delivery|error? d = findDelivery(orderId);
        if d is Delivery {
            return d;
        }
        if d is error {
            return d;
        }
        return <http:NotFound>{body: "Delivery not found for order " + orderId};
    }

    resource function put deliveries/[string orderId]/status(StatusUpdate body)
            returns Delivery|http:NotFound|http:BadRequest|error {
        Delivery|error? found = findDelivery(orderId);
        if found is error {
            return found;
        }
        if found is () {
            return <http:NotFound>{body: "Delivery not found for order " + orderId};
        }
        Delivery d = found;

        DeliveryStatus? expected = nextStatus[d.status];
        if expected is () || expected != body.status {
            return <http:BadRequest>{
                body: "Invalid transition " + d.status + " -> " + body.status
            };
        }

        Delivery updated = {
            deliveryId: d.deliveryId,
            orderId: d.orderId,
            customerId: d.customerId,
            restaurantId: d.restaurantId,
            driverId: d.driverId,
            status: body.status,
            createdAt: d.createdAt,
            updatedAt: nowStr()
        };
        _ = check updateDeliveryFields(orderId, {status: updated.status, updatedAt: updated.updatedAt});
        check publishDeliveryEvent("delivery.status.updated", updated);

        if updated.status == DELIVERED {
            check publishDeliveryEvent("delivery.completed", updated);
            _ = check updateDriverFields(updated.driverId, {available: true});
            error? r = assignPending();
            if r is error {
                log:printError("assignPending failed", r);
            }
        }
        return updated;
    }

    resource function get drivers() returns Driver[]|error {
        return findDrivers({});
    }

    resource function post drivers(NewDriver body) returns record {|*http:Created; Driver body;|}|error {
        Driver dr = {
            driverId: newId("DRV"),
            name: body.name,
            available: true,
            latitude: body.latitude,
            longitude: body.longitude
        };
        check insertDriver(dr);
        error? r = assignPending();
        if r is error {
            log:printError("assignPending failed", r);
        }
        return {body: dr};
    }

    resource function put drivers/[string driverId]/location(LocationUpdate body)
            returns Driver|http:NotFound|error {
        boolean ok = check updateDriverFields(driverId, {latitude: body.latitude, longitude: body.longitude});
        if !ok {
            return <http:NotFound>{body: "Driver not found"};
        }
        Driver|error? dr = findDriver(driverId);
        if dr is Driver {
            return dr;
        }
        return <http:NotFound>{body: "Driver not found"};
    }
}
