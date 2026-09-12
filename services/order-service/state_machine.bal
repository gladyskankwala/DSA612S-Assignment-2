public function isValidTransition(OrderStatus current, OrderStatus next) returns boolean {
 match current {
    CREATED => {
        return  next == CONFIRMED || next == CANCELLED;
    }
    CONFIRMED => {
        return next == PREPARING || next == CANCELLED;
    }
    PREPARING => {
        return next == READY || next == CANCELLED;
    }
    READY => {
        return next == OUT_FOR_DELIVERY || next == CANCELLED;
    }
    OUT_FOR_DELIVERY => {
        return  next == DELIVERED;
    }
    DELIVERED => {
        return false;
    }
    CANCELLED => {
        return false;
    }

 }
 return false;

}