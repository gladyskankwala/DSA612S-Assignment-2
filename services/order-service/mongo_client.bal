import ballerinax/mongodb;

configurable string mongoHost = ?;
configurable int mongoPort = ?;
configurable string mongoDatabase = ?;

final mongodb:Client mongoClient = check new ({
    connection: {
        serverAddress: {
            host: mongoHost,
            port: mongoPort
        }
    }
});