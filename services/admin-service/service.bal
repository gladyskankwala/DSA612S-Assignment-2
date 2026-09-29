import ballerina/http;

<<<<<<< HEAD

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

=======
service /admin on new http:Listener(8085) {

    resource function get stats() returns AdminStats {
        return  getStats();
        
    }
>>>>>>> 7b27d0f4ce21753f6be1b29a9801588f24baa9d7
}