import ballerina/http;

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

