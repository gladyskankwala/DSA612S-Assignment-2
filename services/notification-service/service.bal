import ballerina/http;

@http:ServiceConfig {
    cors: {
        allowOrigins: ["http://127.0.0.1:5500", "http://localhost:5500"],
        allowMethods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
        allowHeaders: ["Content-Type"]
    }
}
service /notification on new http:Listener(8087) {

resource function get health() returns json {

    return {
       "service": "notification-service",
       "status" : "running"
   };
}

  resource function get .() returns Notification[]|error {
      return getNotifications();

  }

}

