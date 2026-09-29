import ballerina/http;


service /admin on new http:Listener(8088) {
    
        // Complete Admin Statistics

        resource function get statistics() returns AdminStatistics {

            return getStatistics();
        }    

    resource function get reports/orders() returns OrderReport {

        return getOrderReport();
    }

    resource function get reports/deliveries() returns DeliveryReport {

        return getDeliveryReport();
    }

}