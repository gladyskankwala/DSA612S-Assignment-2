import ballerinax/mongodb;

final mongodb:Database notificationDatabase;
final mongodb:Collection notificationCollection;

function init() returns error? {

    notificationDatabase = check mongoClient->getDatabase("notification_db");

    notificationCollection = check notificationDatabase->getCollection("notifications");

}