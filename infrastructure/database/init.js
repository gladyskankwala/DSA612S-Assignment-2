db = db.getSiblingDB("food_delivery");

db.createCollection("customers");

db.customers.createIndex(
    { customerId: 1 },
    { unique: true }
);

db.createCollection("restaurants");

db.restaurants.createIndex(
    { restaurantId: 1 },
    { unique: true }
);

db.createCollection("orders");

db.orders.createIndex(
    { orderId: 1 },
    { unique: true }
);

print("======================================");
print("MongoDB initialization completed");
print("Database: food_delivery");
print("Collections:");
print("- customers");
print("- restaurants");
print("- orders");
print("======================================");