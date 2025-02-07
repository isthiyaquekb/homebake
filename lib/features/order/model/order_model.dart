import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String orderId;
  String userId;
  List<Map<String, dynamic>> items; // List of products in the order
  double totalAmount;
  String status; // e.g., Pending, Completed, Canceled
  String paymentMethod;
  String? qrCodeUrl; // Store QR code if needed
  Timestamp createdAt;

  OrderModel({
    required this.orderId,
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
      "userId": userId,
      "items": items,
      "totalAmount": totalAmount,
      "status": status,
      "paymentMethod": paymentMethod,
      "qrCodeUrl": qrCodeUrl,
      "createdAt": createdAt,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map["orderId"] ?? "",
      userId: map["userId"] ?? "",
      items: List<Map<String, dynamic>>.from(map["items"] ?? []),
      totalAmount: (map["totalAmount"] ?? 0).toDouble(),
      status: map["status"] ?? "Pending",
      paymentMethod: map["paymentMethod"] ?? "Cash on Delivery",
      qrCodeUrl: map["qrCodeUrl"],
      createdAt: map["createdAt"] ?? Timestamp.now(),
    );
  }
}
