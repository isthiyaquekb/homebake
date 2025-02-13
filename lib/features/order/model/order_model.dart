import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_bake/features/order/model/order_status.dart';

class OrderModel {
  String orderId;
  int orderNo;
  String userId;
  List<Map<String, dynamic>> items; // List of products in the order
  double totalAmount;
  OrderStatus status; // e.g., Pending, Completed, Canceled
  String paymentMethod;
  String? qrCodeUrl; // Store QR code if needed
  Timestamp createdAt;

  OrderModel({
    required this.orderId,
    required this.orderNo,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    this.qrCodeUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "orderId": orderId,
      'orderNo': orderNo,
      "userId": userId,
      "items": items,
      "totalAmount": totalAmount,
      'status': status.name, // Save as string in Fire Store
      "paymentMethod": paymentMethod,
      "qrCodeUrl": qrCodeUrl,
      "createdAt": createdAt,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map,String documentId) {
    return OrderModel(
      orderId: documentId,
      orderNo: map['orderNo'] ?? 0, // Default to 0 if missing
      userId: map["userId"] ?? "",
      items: List<Map<String, dynamic>>.from(map["items"] ?? []),
      totalAmount: (map["totalAmount"] ?? 0).toDouble(),
      status: OrderStatus.values.firstWhere((e) => e.name == map['status'], orElse: () => OrderStatus.newOrder),
      paymentMethod: map["paymentMethod"] ?? "Cash on Delivery",
      qrCodeUrl: map["qrCodeUrl"],
      createdAt: map["createdAt"] ?? Timestamp.now(),
    );
  }

  /// Converts a FireStore document snapshot to a ProductModel instance
  factory OrderModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return OrderModel.fromMap(data, snapshot.id);
  }
}
