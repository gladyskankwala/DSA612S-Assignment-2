FROM ballerina/ballerina:2201.13.4

WORKDIR /app

COPY target/bin/admin_service.jar .

COPY Config.toml .

EXPOSE 8088

CMD ["bal","run", "admin_service.jar"]