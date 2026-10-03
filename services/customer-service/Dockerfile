FROM ballerina/ballerina:2201.13.4


WORKDIR /app

COPY target/bin/customer_service.jar .
COPY Config.toml . 

EXPOSE 8086


CMD ["bal","run", "customer_service.jar"]
