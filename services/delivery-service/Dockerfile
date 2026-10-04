FROM ballerina/ballerina:2201.13.4

WORKDIR /app

COPY target/bin/delivery_service.jar .

EXPOSE 8085

CMD ["bal", "run", "delivery_service.jar"]