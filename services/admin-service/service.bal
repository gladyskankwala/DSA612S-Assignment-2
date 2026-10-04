import ballerina/http;



listener http:Listener adminSharedListener = new (8088);


@http:ServiceConfig {
    cors: {
        allowOrigins: ["http://127.0.0.1:5500", "http://localhost:5500"],
        allowMethods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
        allowHeaders: ["Content-Type"]
    }
}

service /admin on adminSharedListener {

    resource function get statistics() returns AdminStatistics {
        return getStatistics();
    }    

    resource function get reports/orders() returns OrderReport {
        return getOrderReport();
    }
    resource function get reports/deliveries() returns DeliveryReport {
        return getDeliveryReport();
    }
    resource function get stats() returns AdminStats {
        return getStats();
    }
}
