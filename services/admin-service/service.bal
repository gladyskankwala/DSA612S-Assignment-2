import ballerina/http;

service /admin on new http:Listener(8085) {

    resource function get stats() returns AdminStats {
        return  getStats();
        
    }
}