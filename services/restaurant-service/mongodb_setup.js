const restaurantDB = db.getSiblingDB("restaurant_service");

restaurantDB.restaurants.createIndex(
    { restaurantID: 1 },
    { unique: true }
);

restaurantDB.menu_items.createIndex(
    { restaurantID: 1, itemID: 1 },
    { unique: true }
);

restaurantDB.inventory.createIndex(
    { restaurantID: 1, itemID: 1 },
    { unique: true }
);

restaurantDB.inventory.createIndex(
    { inventoryID: 1 },
    { unique: true }
);