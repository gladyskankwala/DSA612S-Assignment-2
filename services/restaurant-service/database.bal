import ballerinax/mongodb;

configurable string DB_HOST = "dsa612s-mongodb";
configurable int DB_PORT = 27017;
configurable string DB_NAME = "restaurant_service";


final mongodb:Client mongoClient = check new ({
    connection: {
        serverAddress: {
            host: DB_HOST,
            port: DB_PORT
        },
        auth: <mongodb:ScramSha256AuthCredential>{
            username: "admin",
            password: "admin123",
            database: "admin"
        }
    }
});


mongodb:Database restaurantDB;
mongodb:Collection restaurantsCollection;
mongodb:Collection menuCollection;
mongodb:Collection inventoryCollection;

function init() returns error? {

    restaurantDB = check mongoClient->getDatabase(DB_NAME);

    restaurantsCollection =
        check restaurantDB->getCollection("restaurants");

    menuCollection =
        check restaurantDB->getCollection("menu_items");

    inventoryCollection =
        check restaurantDB->getCollection("inventory");
}
