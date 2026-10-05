import ballerinax/mongodb;

configurable string mongoHost = ?;
configurable int mongoPort = ?;

final mongodb:Client mongoClient = check new ({
    connection: string `mongodb://admin:admin123@${mongoHost}:${mongoPort}/?authSource=admin`
});
