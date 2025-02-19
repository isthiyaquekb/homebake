enum OrderStatus {
  newOrder,    // When order is placed
  accepted,    // When accepted by admin
  rejected,    // When rejected by admin
  readyForPickup, // When it's ready for pickup
  pickedUp,    // When picked up
  completed,    // When received by the customer

}

extension OrderStatusExtension on OrderStatus {
  String get displayName  {
    switch (this) {
      case OrderStatus.newOrder:
        return "New";
      case OrderStatus.accepted:
        return "Accepted";
      case OrderStatus.rejected:
        return "Rejected";
      case OrderStatus.readyForPickup:
        return "Ready for Pickup";
      case OrderStatus.pickedUp:
        return "Picked Up";
      case OrderStatus.completed:
        return "completed";
    }
  }
}
