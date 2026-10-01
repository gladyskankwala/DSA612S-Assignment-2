import ballerinax/mongodb;

configurable string mongoUrl = "mongodb://admin:admin123@localhost:27017/?authSource=admin";

final mongodb:Client mongoClient = check new ({connection: mongoUrl});
