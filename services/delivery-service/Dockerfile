# Build stage: compiles the Ballerina code
FROM ballerina/ballerina:2201.13.4 AS build
WORKDIR /app
COPY --chown=ballerina:ballerina . .
RUN bal build

# Run stage: just Java is needed to run the compiled jar
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/bin/delivery_service.jar /app/delivery-service.jar
EXPOSE 8085
CMD ["java", "-jar", "delivery-service.jar"]