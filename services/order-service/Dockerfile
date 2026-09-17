FROM ballerina/ballerina:2201.13.4

WORKDIR /app

COPY target/bin/order_service.jar .
COPY Config.toml .

EXPOSE 9091

CMD ["bal", "run", "order_service.jar"]