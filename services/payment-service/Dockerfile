# Build stage
FROM ballerina/ballerina:2201.10.0 AS build
WORKDIR /app
COPY . .
RUN bal build --offline || bal build

# Run stage
FROM ballerina/jre21:latest
WORKDIR /app
COPY --from=build /app/target/bin/*.jar /app/payment-service.jar

# Set environment variables for MongoDB and Kafka
ENV BAL_CONFIG_VAR_MONGOURL=mongodb://admin:admin123@mongodb:27017/?authSource=admin
ENV BAL_CONFIG_VAR_KAFKAURL=kafka:29092

EXPOSE 8084

CMD ["java", "-jar", "payment-service.jar"]
