FROM ballerina/ballerina:2201.13.4

WORKDIR /app

COPY target/bin/notification_service.jar .

COPY Config.toml .

EXPOSE 8087 

CMD [ "bal", "run","notification_service.jar" ]