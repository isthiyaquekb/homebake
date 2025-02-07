enum OrderStatus {
  newOrder,    // When order is placed
  accepted,    // When accepted by admin
  readyForPickup, // When it's ready for pickup
  pickedUp,    // When picked up
  received,    // When received by the customer
}

extension OrderStatusExtension on OrderStatus {
  String get displayName  {
    switch (this) {
      case OrderStatus.newOrder:
        return "New";
      case OrderStatus.accepted:
        return "Accepted";
      case OrderStatus.readyForPickup:
        return "Ready for Pickup";
      case OrderStatus.pickedUp:
        return "Picked Up";
      case OrderStatus.received:
        return "Received";
    }
  }
}
