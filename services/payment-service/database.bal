public function savePayment(Payment payment) returns error? {
    check paymentCollection->insertOne(payment);
}

public function getPaymentFromDatabase(string orderId) returns Payment|error? {

    map<json> filter = {
        orderId: orderId
    };

    Payment|error? result = check paymentCollection->findOne(
        filter,
        {},
        (),
        Payment
    );

    return result;
}
