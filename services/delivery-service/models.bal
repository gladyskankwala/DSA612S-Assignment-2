public enum DeliveryStatus {
    PENDING,
    ASSIGNED,
    PICKED_UP,
    IN_TRANSIT,
    DELIVERED,
    FAILED
}

public type Driver record {|
    string driverId;
    string name;
    boolean available;
    float latitude = 0.0;
    float longitude = 0.0;
|};

public type Delivery record {|
    string deliveryId;
    string orderId;
    string customerId;
    string restaurantId;
    string driverId;
    DeliveryStatus status;
    string createdAt;
    string updatedAt;
|};

public type OrderEvent record {
    string orderId;
    string customerId;
    string restaurantId = "";
};

public type DeliveryEvent record {|
    string deliveryId;
    string orderId;
    string customerId;
    string restaurantId;
    string driverId;
    string status;
    string timestamp;
|};

public type NewDriver record {|
    string name;
    float latitude = 0.0;
    float longitude = 0.0;
|};

public type StatusUpdate record {|
    DeliveryStatus status;
|};

public type LocationUpdate record {|
    float latitude;
    float longitude;
|};
