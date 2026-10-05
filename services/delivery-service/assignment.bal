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

        log:printInfo(
            "Order " + d.orderId + " assigned to " + dr.driverId
        );

        // Automatically simulate the delivery journey.
        check progressDelivery(assigned);

        return;
    }

    log:printInfo(
        "No driver available for order " + d.orderId + ", staying PENDING"
    );
}

function progressDelivery(Delivery assigned) returns error? {

    Delivery current = assigned;

    DeliveryStatus[] statuses = [
        PICKED_UP,
        IN_TRANSIT,
        DELIVERED
    ];

    foreach DeliveryStatus next in statuses {

        Delivery updated = {
            deliveryId: current.deliveryId,
            orderId: current.orderId,
            customerId: current.customerId,
            restaurantId: current.restaurantId,
            driverId: current.driverId,
            status: next,
            createdAt: current.createdAt,
            updatedAt: nowStr()
        };

        boolean ok = check updateDeliveryFields(
            current.orderId,
            {
                status: updated.status,
                updatedAt: updated.updatedAt
            }
        );

        if !ok {
            log:printError(
                "Could not update delivery " + current.orderId
            );
            return;
        }

        check publishDeliveryEvent(
            "delivery.status.updated",
            updated
        );

        log:printInfo(
            "Delivery " + current.orderId +
            " progressed to " + next.toString()
        );

        if next == DELIVERED {

            check publishDeliveryEvent(
                "delivery.completed",
                updated
            );

            _ = check updateDriverFields(
                updated.driverId,
                {available: true}
            );

            log:printInfo(
                "Delivery " + current.orderId +
                " completed. Driver " +
                updated.driverId +
                " is available again."
            );
        }

        current = updated;
    }
}

function assignPending() returns error? {
    Delivery[] pending = check findDeliveries({status: PENDING});

    foreach Delivery d in pending {
        check tryAssign(d);
    }
}