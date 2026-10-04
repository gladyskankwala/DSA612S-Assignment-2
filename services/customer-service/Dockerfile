FROM ballerina/ballerina:2201.13.4
WORKDIR /app
COPY target/bin/customer_service.jar .
COPY config.toml .
EXPOSE 8086
CMD ["java", "-jar", "customer_service.jar"]
