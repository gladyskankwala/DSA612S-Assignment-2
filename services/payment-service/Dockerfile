# Build stage
FROM ballerina/ballerina:2201.10.0 AS build
WORKDIR /app
COPY . .
RUN bal build --offline || bal build

# Run stage
FROM ballerina/jre21:latest
WORKDIR /app
COPY --from=build /app/target/bin/*.jar /app/payment-service.jar

EXPOSE 8084

CMD ["java", "-jar", "payment-service.jar"]