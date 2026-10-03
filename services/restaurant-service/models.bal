public type Restaurant record {|
    int restaurantID;
    string name;
    string address;
    string openingTime;
    string closingTime;
    boolean isOpen;
|};
public type menuItem record {|
    int itemID;
    string name;
    int restaurantID;
    decimal price;
    string description;
    boolean isAvailable;
|};
public type itemInventory record {|
    int itemID;
    int inventoryID;
    int restaurantID;
    string name;
    int quantity;
|};
