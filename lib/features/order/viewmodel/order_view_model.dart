import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_bake/core/services/firebase_services.dart';
import 'dart:developer';

import 'package:home_bake/features/order/model/order_model.dart';

class OrderViewModel {
  final FirebaseServices _firebaseServices = FirebaseServices();

  Future<String> createOrder(String userId, List<Map<String, dynamic>> cartItems, double totalAmount) async {
    try {
      // Generate a unique order ID
      DocumentReference orderRef = _firebaseServices.fireStore.collection("orders").doc();

      // Create an order model
      OrderModel order = OrderModel(
        orderId: orderRef.id,
        userId: userId,
        items: cartItems,
        totalAmount: totalAmount,
        status: "Pending",
        paymentMethod: "Cash on Delivery",
        qrCodeUrl: null, // Will generate QR code later
        createdAt: Timestamp.now(),
      );

      // Store order in Firestore
      await orderRef.set(order.toMap());

      log("Order created successfully: ${order.orderId}");
      return order.orderId;
    } catch (e) {
      log("Error creating order: $e");
      return "";
    }
  }

}
