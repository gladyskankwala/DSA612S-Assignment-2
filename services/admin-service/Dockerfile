FROM ballerina/ballerina:2201.13.4
WORKDIR /app
COPY target/bin/admin_service.jar .
COPY config.toml .
EXPOSE 8088
CMD ["java", "-jar", "admin_service.jar"]
