import ballerina/http;
import ballerinax/mongodb;
listener http:Listener resturantListener = new (8083);

//    ---------CHECKING FUNCTIONS-------------

function getRestaurant(int restaurantID) returns Restaurant|error? {
    return restaurantsCollection->findOne(
    {restaurantID: restaurantID}, targetType = Restaurant);
}

function ValidRestaurant(Restaurant restaurant) returns boolean {

    return

    restaurant.name.trim() != "" &&
    restaurant.address.trim() != "" &&
    restaurant.openingTime.trim() != "" &&
    restaurant.closingTime.trim() != "" ;
}

function ValidMenuItem(menuItem item ) returns boolean{
    return
    item.itemID>0 &&
    item.name.trim() != "" &&
    item.price > 0d  &&
    item.description.trim() != "";

}

function ValidInventory(itemInventory inventory) returns boolean{
    return
    inventory.inventoryID > 0 &&
    inventory.itemID > 0 &&
    inventory.name.trim() != "" &&
    inventory.quantity >= 0 &&
    inventory.restaurantID > 0;

}

@http:ServiceConfig {
    cors: {
        allowOrigins: ["http://127.0.0.1:5500", "http://localhost:5500"],
        allowMethods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
        allowHeaders: ["Content-Type"]
    }
}

service /restaurant on resturantListener{

    //RESTAURANT ENDPOINT START

    //----------GET RESTAURANT-----

    resource function get .() returns Restaurant[]|error {

        stream<Restaurant, error?> result = check restaurantsCollection->find(
        {}, targetType = Restaurant);

        Restaurant[] restaurantList = [];

        do {
            check from Restaurant restaurant in result
            do {
                restaurantList.push(restaurant);
            };
        } on fail error err {
    return err;
}

        check result.close();

        return restaurantList;
    }

    // -------GET SPECIFIC RESTAUARNT------
    resource function get [int restaurantID]()
        returns Restaurant|http:NotFound|error {

        Restaurant? restaurant = check getRestaurant(restaurantID);

        if restaurant is () {
            return http:NOT_FOUND;
        }

        return restaurant;
    }

    //----------POST ENDPOINT-------------

    resource function post .(@http:Payload Restaurant restaurant)
        returns Restaurant|http:BadRequest|error {

        if !ValidRestaurant(restaurant) {
            return http:BAD_REQUEST;
        }

        check restaurantsCollection->insertOne(restaurant);

        return restaurant;
    }

    //-----------PUT ENDPOINT----------------
    resource function put [int restaurantID](@http:Payload Restaurant restaurant)
        returns Restaurant|http:NotFound|http:BadRequest|error {

        if !ValidRestaurant(restaurant) {
            return http:BAD_REQUEST;
        }

        mongodb:UpdateResult result = check restaurantsCollection->updateOne(
        {restaurantID: restaurantID},
        {set: {
                name: restaurant.name,
                address: restaurant.address,
                openingTime: restaurant.openingTime,
                closingTime: restaurant.closingTime,
                isOpen: restaurant.isOpen
        }});

        if result.matchedCount == 0 {
            return http:NOT_FOUND;
        }

        restaurant.restaurantID = restaurantID;

        return restaurant;
    }

    resource function delete [int restaurantID]()
        returns http:NotFound|http:Ok|error {

        mongodb:DeleteResult result = check restaurantsCollection->deleteOne(
        {restaurantID: restaurantID});

        if result.deletedCount == 0 {
            return http:NOT_FOUND;
        }

        return http:OK;
    }
    // --------RESTAURANT ENDPOINTS END----------------

    // --------MENU ENDPOINTS START------------------

    //       ---------PUT MENU-------------
    resource function put [int restaurantID]/menuItem/[int itemID](@http:Payload menuItem item)
        returns menuItem|http:BadRequest|http:NotFound|error {

        Restaurant? restaurant = check getRestaurant(restaurantID);

        if restaurant is () {
            return http:NOT_FOUND;
        }
        item.itemID = itemID;
        item.restaurantID = restaurantID;

        if !ValidMenuItem(item) {
            return http:BAD_REQUEST;
        }

        mongodb:UpdateResult result = check menuCollection->updateOne(
        {itemID: itemID, restaurantID: restaurantID},
        {set: {
                name: item.name,
                price: item.price,
                description: item.description,
                isAvailable: item.isAvailable
        }});

        if result.matchedCount == 0 {
            return http:NOT_FOUND;
        }

        return item;
    }

    //  --------POST MENU-------------
    resource function post [int restaurantID]/menuItem(@http:Payload menuItem item)
        returns menuItem|http:NotFound|http:BadRequest|error {

        Restaurant? restaurant = check getRestaurant(restaurantID);

        if restaurant is () {
            return http:NOT_FOUND;
        }

        item.restaurantID = restaurantID;

        if !ValidMenuItem(item) {
            return http:BAD_REQUEST;
        }

        check menuCollection->insertOne(item);
        return item;
    }

    // ------DELETE MENU--------

    resource function delete [int restaurantID]/menuItem/[int itemID]()
        returns http:NotFound|http:Ok|error {

        mongodb:DeleteResult result = check menuCollection->deleteOne(
        {itemID: itemID, restaurantID: restaurantID});

        if result.deletedCount == 0 {
            return http:NOT_FOUND;
        }

        return http:OK;
    }

    //  ---------GET MENU-----------

    resource function get [int restaurantID]/menuItem()
        returns menuItem[]|http:NotFound|error {

        Restaurant? restaurant = check getRestaurant(restaurantID);

        if restaurant is () {
            return http:NOT_FOUND;
        }
        stream<menuItem, error?> result = check menuCollection->find(
        {restaurantID: restaurantID}, targetType = menuItem);

        menuItem[] restaurantMenu = [];

        do {
            check from menuItem item in result
            do {
                restaurantMenu.push(item);
            };
       } on fail error err {
    return err;
}

        check result.close();

        return restaurantMenu;
    }

    //     ---------- MENU END ------------

    // -------------INVENTORY START------------

    // -------------GET ALL INVENTORY--------------
    resource function get [int restaurantID]/inventory()
        returns itemInventory[]|http:NotFound|error {

        Restaurant? restaurant = check getRestaurant(restaurantID);

        if restaurant is () {
            return http:NOT_FOUND;
        }

        stream<itemInventory, error?> result = check inventoryCollection->find(
        {restaurantID: restaurantID}, targetType = itemInventory);

        itemInventory[] restaurantInventory = [];

        do {
            check from itemInventory inventoryItem in result
            do {
                restaurantInventory.push(inventoryItem);
            };
       } on fail error err {
    return err;
}
        check result.close();

        return restaurantInventory;
    }

    // -------------GET SPECIFIC INVENTORY--------------

    resource function get [int restaurantID]/inventory/[int itemID]()
        returns itemInventory|http:NotFound|error {

        itemInventory? inventoryItem = check inventoryCollection->findOne(
        {restaurantID: restaurantID, itemID: itemID}, targetType = itemInventory);

        if inventoryItem is () {
            return http:NOT_FOUND;
        }

        return inventoryItem;
    }

    // --------DELETE INVENTORY ----------
    resource function delete [int restaurantID]/inventory/[int itemID]()
        returns http:NotFound|http:Ok|error {

        mongodb:DeleteResult result = check inventoryCollection->deleteOne(
        {restaurantID: restaurantID, itemID: itemID});

        if result.deletedCount == 0 {
            return http:NOT_FOUND;
        }

        return http:OK;
    }

    // ---------POST INVENTORY-------------

    resource function post [int restaurantID]/inventory/[int itemID](
    @http:Payload itemInventory inventory)
        returns itemInventory|http:NotFound|http:BadRequest|error {

        Restaurant? restaurant = check getRestaurant(restaurantID);

        if restaurant is () {
            return http:NOT_FOUND;
        }

        inventory.itemID = itemID;
        inventory.restaurantID = restaurantID;

        if !ValidInventory(inventory) {
            return http:BAD_REQUEST;
        }

        check inventoryCollection->insertOne(inventory);

        return inventory;
    }

    // -------PUT INVENTORY---------
    resource function put [int restaurantID]/inventory/[int itemID](
    @http:Payload itemInventory inventory)
        returns itemInventory|http:NotFound|http:BadRequest|error {

        Restaurant? restaurant = check getRestaurant(restaurantID);

        if restaurant is () {
            return http:NOT_FOUND;
        }
        inventory.itemID = itemID;
        inventory.restaurantID = restaurantID;

        if !ValidInventory(inventory) {
            return http:BAD_REQUEST;
        }

        mongodb:UpdateResult result = check inventoryCollection->updateOne(
        {restaurantID: restaurantID, itemID: itemID},
        {set: {
                inventoryID: inventory.inventoryID,
                name: inventory.name,
                quantity: inventory.quantity
        }});

        if result.matchedCount == 0 {
            return http:NOT_FOUND;
        }

        return inventory;
    }

}
