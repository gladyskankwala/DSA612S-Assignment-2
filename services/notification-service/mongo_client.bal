import ballerinax/mongodb;

configurable string mongoUrl = ?;

final mongodb:Client mongoClient = check new ({

    connection:mongoUrl
});