public type Customer record {|
    string customerId;
    string name;
    string email;
    string phone;
    Address[] addresses = [];
    OrderHistory[] orderHistory = [];

|};

public type Address record {|
    string addressId;
    string label;
    string street;
    string city;
    string province;
    string postalCode;
|};


public type OrderHistory record {|
    string orderId;
    string restaurantId;
    decimal totalAmount;
    string status;
    string orderDate;

|};

