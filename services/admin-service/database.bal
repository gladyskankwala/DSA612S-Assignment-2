import ballerinax/mongodb;

public function saveStatistics(AdminStatistics stats) returns error?{

  map<json> filter = {
    _id: "current"
  };

    AdminStatistics|error? existing = statisticsCollection->findOne(
      filter,
      {},
      (),
      AdminStatistics
    );

    if existing is error {
      return existing;
    }

    if existing is () {
      map<json> document = {
        _id:"current",
        totalOrders: stats.totalOrders,
        confirmedOrders: stats.confirmedOrders,
        preparingOrders: stats.preparingOrders,
        readyOrders: stats.readyOrders,
        cancelledOrders: stats.cancelledOrders,
        completedPayments: stats.completedPayments,
        failedPayments: stats.failedPayments,
        assignedDeliveries: stats.assignedDeliveries,
        completedDeliveries: stats.completedDeliveries
      };
  
      check statisticsCollection->insertOne(document);

  } else {
      mongodb:Update update = {
        set: stats
      };

      mongodb:UpdateResult result = check statisticsCollection->updateOne(
        filter,
        update,
        {}
      );

    }

    return ;
}

public function getSavedStatistics() returns AdminStatistics|error?{
  map<json> filter = {
    _id: "current"
  };

  AdminStatistics|error? result = statisticsCollection->findOne(
    filter,
    {},
    (),
    AdminStatistics
  );

  return result;
}
