import ballerina/log;


function createOrderNotification(string eventType, string eventData

      ) {
        string message = "";

        if eventType == "orders.created" {
            message = "Your order has been created.";
        } else if eventType == "orders.confirmed" {
            message = "Your order has been confirmed.";
        } else if eventType == "orders.preparing" {
            message = "Your order is being prepared.";
        } else if eventType == "orders.ready" {
            message = "Your order is ready.";
        } else if eventType == "orders.cancelled" {
            message = "Your order has been cancelled";
        } else if eventType == "payments.completed" {
            message = "Your payments has been completed successfully.";
        } else if  eventType == "payments.failed" {
            message = "Your payment could not be completed.";
        } else if eventType == "delivery.assigned" {
            message = "A delivery driver has een assigned to your order.";
        } else if eventType == "delivery.completed" {
            message = "Your order has been delivered.";
        }

        json eventJson = checkpanic eventData.fromJsonString();

          string recipientId = "";
          string orderId = "";

          if eventJson is map<json> {

            if eventJson["customerId"] is string {

              recipientId = <string>eventJson["customerId"];

            }

            if eventJson ["orderId"] is string {
              orderId = <string> eventJson["orderId"];
            }
          }

          Notification notification = {
            recipientId: recipientId,
            recipientType: "CUSTOMER",
            message: message,
            eventType: eventType,
            orderId: orderId
          };

          error? saveResult = saveNotification(notification);

          if saveResult is error {

            log:printError(
              "Failed to save notification",
              saveResult
            );
          }

        log:printInfo(
          "---------------------------------------------"
          );

          log:printInfo("CUSTOMER NOTIFICATION"
          );

          log:printInfo("Recipient: "+ notification.recipientId);

          log:printInfo(
            "Recipient Type: " + notification.recipientType);
          log:printInfo("Event: " + notification.eventType);

          log:printInfo(
            "Message:" + notification.message );

          log:printInfo(
            "Order ID: "+ notification.orderId
          );

          log:printInfo(
            "-----------------------------------------"
            );
    }