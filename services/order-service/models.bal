
public type OrderItem record {|
    string menuItemId;
    string itemID;
    string name;
    int quantity;
    decimal price;
|};

public enum OrderStatus {
    CREATED,
    CONFIRMED,
    PREPARING,
    READY,
    OUT_FOR_DELIVERY,
    DELIVERED,
    CANCELLED
}

public type Order record {|
    string orderId;
    string itemID;
    string customerId;
    string restaurantId;
    OrderItem[] items;
    decimal totalAmount;
    OrderStatus status;
|};

public type AdminStatistics record {|
    int totalOrders;
    int completedPayments;
    int failedPayment;
|};

public type OrderReport record {|
    int activeOrdersCount;
    decimal totalRevenue;
|};

public type DeliveryReport record {|
    int activeDispatchesCount;
    int completedDispatchesCount;
|};

public type AdminStats record {|
    int activeUsersCount;
    int activeVendorsCount;
|};
