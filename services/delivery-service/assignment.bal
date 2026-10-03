import ballerina/log;

function handleOrderReady(OrderEvent e) returns error? {
    Delivery|error? existing = findDelivery(e.orderId);
    if existing is Delivery {
        log:printInfo("Delivery already exists for order " + e.orderId + ", skipping duplicate event");
        return;
    }
    if existing is error {
        return existing;
    }
    string ts = nowStr();
    Delivery d = {
        deliveryId: newId("DEL"),
        orderId: e.orderId,
        customerId: e.customerId,
        restaurantId: e.restaurantId,
        driverId: "",
        status: PENDING,
        createdAt: ts,
        updatedAt: ts
    };
    check insertDelivery(d);
    check tryAssign(d);
}

function tryAssign(Delivery d) returns error? {
    Driver[] free = check findDrivers({available: true});
    foreach Driver dr in free {
        boolean gotDriver = check claimDriver(dr.driverId);
        if !gotDriver {
            continue;
        }
        boolean gotDelivery = check claimDelivery(d.orderId, dr.driverId);
        if !gotDelivery {
            _ = check updateDriverFields(dr.driverId, {available: true});
            return;
        }
        Delivery assigned = {
            deliveryId: d.deliveryId,
            orderId: d.orderId,
            customerId: d.customerId,
            restaurantId: d.restaurantId,
            driverId: dr.driverId,
            status: ASSIGNED,
            createdAt: d.createdAt,
            updatedAt: nowStr()
        };
        check publishDeliveryEvent("delivery.assigned", assigned);
        log:printInfo("Order " + d.orderId + " assigned to " + dr.driverId);
        return;
    }
    log:printInfo("No driver available for order " + d.orderId + ", staying PENDING");
}

function assignPending() returns error? {
    Delivery[] pending = check findDeliveries({status: PENDING});
    foreach Delivery d in pending {
        check tryAssign(d);
    }
}
