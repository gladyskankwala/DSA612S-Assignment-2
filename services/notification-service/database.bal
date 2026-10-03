
public function saveNotification(Notification notification) returns error? {

    map<json> document = {
        recipientId: notification.recipientId,
        recipientType: notification.recipientType,
        message: notification.message,
        eventType: notification.eventType,
        orderId: notification.orderId
    };

    check notificationCollection->insertOne(document);

    return;
}

public function getNotifications() returns Notification[]|error {

    Notification[] notifications = [];


        
     var result = notificationCollection->find({}, {}, (), Notification);

    if result is error {
        return result;
    }

    check from Notification notification in result 
        do {
            notifications.push(notification);
        };

        check result.close();

        return notifications;
}