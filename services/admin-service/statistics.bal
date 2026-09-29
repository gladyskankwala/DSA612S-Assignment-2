import ballerina/log;


AdminStatistics statistics = {};

    public function updateStatistics(string eventType) {

        if eventType == "orders.created" {

            statistics.totalOrders += 1;

        } else if eventType == "orders.confirmed" {

            statistics.confirmedOrders += 1;

        } else if eventType == "orders.preparing" {

            statistics.preparingOrders += 1;

        } else if eventType == "orders.ready" {

            statistics.readyOrders += 1;
        } else if eventType =="orders.cancelled" {

            statistics.cancelledOrders += 1;
        } else if eventType == "payments.completed" {

            statistics.completedPayments += 1;

        } else if eventType == "payments.failed" {

            statistics.failedPayments += 1;

        } else if eventType == "assignedDeliveries" {

            statistics.assignedDeliveries += 1 ;
        } else if eventType == "completedDeliveries" {

            statistics.completedDeliveries += 1;
        }

        log:printInfo (
            "Statistics updated for event:" + eventType
        );

    }

    public function loadStatistics() returns error?{
        AdminStatistics|error? saved = getSavedStatistics();

        if saved is error {
            return saved;
        }

        if saved is AdminStatistics {
            statistics = saved;

            log:printInfo("Saved statistics loaded from MongoDB.");

        } else {
            log:printInfo("No saved statistics found. Starting with empty statistics.");
        }

        return;
    }

            public function getStatistics() returns AdminStatistics{
                return statistics;
            }


    public function getOrderReport() returns OrderReport {
        return{
            totalOrders:statistics.totalOrders,
            confirmedOrders:statistics.confirmedOrders,
            preparingOrders:statistics.preparingOrders,
            readyOrders:statistics.readyOrders,
            cancelledOrders:statistics.cancelledOrders
        };
    }


    public function getDeliveryReport() returns DeliveryReport {
        return {
            assignedDeliveries:statistics.assignedDeliveries,
            completedDeliveries:statistics.completedDeliveries
        };
    }
