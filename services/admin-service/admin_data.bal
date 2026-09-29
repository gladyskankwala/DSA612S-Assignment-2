int totalOrders = 0;
int completedPayments = 0;
int failedPayments = 0;


public function getStats() returns AdminStats {
    return {
        totalOrders: totalOrders,
        completedPayments: completedPayments,
        failedPayment: failedPayments
    };
}