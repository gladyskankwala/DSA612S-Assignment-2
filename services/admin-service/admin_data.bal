int totalOrders = 0;
int completedPayments = 0;
int failedPayments = 0;

public function getStats() returns AdminStats {
    return {
        totalOrders: statistics.totalOrders,
        completedPayments: statistics.completedPayments,
        failedPayment: statistics.failedPayments
    };
}
