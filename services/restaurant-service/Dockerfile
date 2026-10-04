FROM ballerina/ballerina:2201.13.4
WORKDIR /app
COPY target/bin/restaurant_service.jar .
EXPOSE 8083
CMD ["java", "-jar", "restaurant_service.jar"]
