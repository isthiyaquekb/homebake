import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_bake/core/services/firebase_services.dart';
import 'package:home_bake/features/cart/model/cart_model.dart';
import 'dart:developer';

import 'package:home_bake/features/order/model/order_model.dart';
import 'package:home_bake/features/order/model/order_status.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OrderViewModel extends ChangeNotifier{
  final FirebaseServices _firebaseServices = FirebaseServices();
  bool _isLoading = false;
  List<OrderModel> _orderList=[];

  bool get isLoading => _isLoading;
  List<OrderModel> get orderList=> _orderList;
  void placeOrder(String userId, List<CartModel> cartItems) async {
    List<Map<String, dynamic>> cartItemsMap = cartItems.map((item) => item.toMap()).toList();
    double totalAmount = cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    String orderId = await OrderViewModel().createOrder(userId, cartItemsMap, totalAmount);

    if (orderId.isNotEmpty) {
      print("Order placed successfully with ID: $orderId");
      getOrders();
      // Redirect user to order confirmation screen
    } else {
      print("Failed to place order");
    }
  }


  Future<String> createOrder(String userId,List<Map<String, dynamic>> cartItems, double totalAmount) async {
    log("CART ITEM MAP: ${cartItems}");

    try {
      // Generate a unique order ID
      DocumentReference orderRef = _firebaseServices.fireStore.collection("orders").doc();

      // Create an order model
      OrderModel order = OrderModel(
        orderId: orderRef.id,
        userId: userId,
        items: cartItems,
        totalAmount: totalAmount,
        status: OrderStatus.newOrder,
        paymentMethod: "Cash on Delivery",
        qrCodeUrl: null, // Will generate QR code later
        createdAt: Timestamp.now(),
      );

      // Store order in Firestore
      await orderRef.set(order.toMap());

      log("Order created successfully: ${order.orderId}");

      // Generate QR code
      String qrCodeUrl = await _generateAndUploadQRCode(order.orderId);

      // Update order with QR code URL
      await orderRef.update({"qrCodeUrl": qrCodeUrl});
      return order.orderId;
    } catch (e) {
      log("Error creating order: $e");
      return "";
    }
  }

  /// Generate QR Code and Upload to Firebase Storage
  Future<String> _generateAndUploadQRCode(String orderId) async {
    try {
      // Generate QR code image
      final qrValidationResult = QrValidator.validate(
        data: orderId,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.L,
      );

      if (qrValidationResult.status == QrValidationStatus.error) {
        throw Exception("QR Code generation failed");
      }

      final qrCode = qrValidationResult.qrCode;
      log("Generated QR: $qrCode");
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/$orderId.png';

      final painter = QrPainter(
        data: orderId,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.L,
      );

      final file = File(filePath);
      final pic = await painter.toImageData(300);
      await file.writeAsBytes(pic!.buffer.asUint8List());
      //
      // // Upload QR code image to Firebase Storage
      // String storagePath = 'qr_codes/$orderId.png';
      // TaskSnapshot uploadTask = await _storage.ref(storagePath).putFile(file);
      // String qrUrl = await uploadTask.ref.getDownloadURL();

      return file.path;
    } catch (e) {
      log("Error generating/uploading QR: $e");
      return "";
    }
  }

  ///FETCH ORDER FROM ORDER COLLECTIONS
  Future<void> getOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot querySnapshot = await _firebaseServices.fireStore.collection('orders').get();
      _orderList = querySnapshot.docs.map((doc) => OrderModel.fromDocumentSnapshot(doc)).toList();
      log("TOTAL AMOUNT:${orderList[0].totalAmount}");
    } catch (e) {
      debugPrint("Error fetching orders: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

}
