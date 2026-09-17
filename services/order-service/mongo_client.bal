import ballerinax/mongodb;

configurable string mongoHost = ?;
configurable int mongoPort = ?;
configurable string mongoUser = ?;
configurable string mongoPassword = ?;
configurable string mongoDatabase = ?;

final mongodb:Client mongoClient = check new ({
    connection: {
        serverAddress: {
            host: mongoHost,
            port: mongoPort
        },
        auth: <mongodb:ScramSha256AuthCredential>{
            username: mongoUser,
            password: mongoPassword,
            database: "admin"
        }
    }
});
