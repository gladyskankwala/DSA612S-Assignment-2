FROM ballerina/ballerina:2201.13.4

WORKDIR /app

COPY target/bin/payment_service.jar .

EXPOSE 8084

CMD ["bal", "run", "payment_service.jar"]