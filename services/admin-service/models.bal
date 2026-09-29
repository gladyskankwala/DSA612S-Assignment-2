public type AdminStatistics record {|

    int totalOrders = 0;
    int confirmedOrders = 0;
    int preparingOrders = 0;
    int readyOrders = 0;
    int cancelledOrders = 0;

    int completedPayments = 0;
    int failedPayments = 0;

    int assignedDeliveries = 0;
    int completedDeliveries = 0;
|};

public type OrderReport record {|

    int totalOrders;
    int confirmedOrders;
    int preparingOrders;
    int readyOrders;
    int cancelledOrders;

|};

public type DeliveryReport record {|

    int assignedDeliveries;
    int completedDeliveries;

|};
