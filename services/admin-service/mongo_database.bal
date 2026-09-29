import ballerinax/mongodb;

final mongodb:Database adminDatabase;
final mongodb:Collection statisticsCollection;

function init() returns error? {
    adminDatabase = check mongoClient->getDatabase("admin_db");
    statisticsCollection = check adminDatabase->getCollection("statistics");

    check loadStatistics();
}