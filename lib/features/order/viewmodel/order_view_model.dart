import 'dart:convert';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:home_bake/core/app_assets.dart';
import 'package:home_bake/core/app_keys.dart';
import 'package:home_bake/core/services/firebase_services.dart';
import 'package:home_bake/features/cart/model/cart_model.dart';
import 'package:home_bake/features/cart/viewmodel/cart_view_model.dart';
import 'dart:developer';

import 'package:home_bake/features/order/model/order_model.dart';
import 'package:home_bake/features/order/model/order_status.dart';
import 'package:http/http.dart' as https;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;

import '../../../core/services/local_notification_services.dart';

class OrderViewModel extends ChangeNotifier{
  final FirebaseServices _firebaseServices = FirebaseServices();
  final  storageBox = GetStorage();
  final bool _isLoading = false;
  final List<OrderModel> _orderList=[];
  User? _user;
  User? get user => _user;
  bool get isLoading => _isLoading;
  List<OrderModel> get orderList=> _orderList;

  String _userId="";
  String get userId => _userId;

  void onInit() async {
    _userId=await fetchUserId();
    notifyListeners();
  }
  Future<String> fetchUserId() async {
    _user = _firebaseServices.auth.currentUser;
    return _user!.uid;
  }

  void placeOrder(String userId, List<CartModel> cartItems) async {
    List<Map<String, dynamic>> cartItemsMap = cartItems.map((item) => item.toMap()).toList();
    double totalAmount = cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    String orderId = await createOrder(userId, cartItemsMap, totalAmount);

    if (orderId.isNotEmpty) {
      print("Order placed successfully with ID: $orderId");
      await CartViewModel().clearUserCart(userId);
      getOrdersStream(userId);
      sendPushNotification(storageBox.read(AppKeys.keyFcmToken),OrderStatus.newOrder.displayName);
      // Redirect user to order confirmation screen
    } else {
      print("Failed to place order");
    }
  }

  Future<int> generateUniqueOrderNo() async {
    final math.Random random = math.Random();
    int orderNo;

    // Loop until a unique order number is found
    while (true) {
      orderNo = 1000 + random.nextInt(9000); // Generates a random number between 1000-9999

      // Check Firestore if this order number already exists
      var querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('orderNo', isEqualTo: orderNo)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return orderNo; // Found a unique number, return it
      }
    }
  }
  Future<String> createOrder(String userId,List<Map<String, dynamic>> cartItems, double totalAmount) async {
    log("CART ITEM MAP: $cartItems");
    int orderNo = await generateUniqueOrderNo();
    try {
      // Generate a unique order ID
      DocumentReference orderRef = _firebaseServices.fireStore.collection("orders").doc();

      // Create an order model
      OrderModel order = OrderModel(
        orderId: orderRef.id,
        orderNo: orderNo, // New 4-digit order number
        userId: userId,
        items: cartItems,
        totalAmount: totalAmount,
        status: OrderStatus.newOrder,
        paymentMethod: "Cash on Delivery",
        qrCodeUrl: null, // Will generate QR code later
          fcmToken:storageBox.read(AppKeys.keyFcmToken),
        createdAt: Timestamp.now(),
      );

      // Store order in Firestore
      await orderRef.set(order.toMap());

      log("Order created successfully: ${order.orderId}");

      // Generate QR code
      await generateAndStoreQRData(order.orderNo.toString(),order.orderId);


      return order.orderId;
    } catch (e) {
      log("Error creating order: $e");
      return "";
    }
  }

  /// Generate QR Code and Upload to Firebase Storage

  Future<void> generateAndStoreQRData(String orderNo, String orderId) async {
    String qrData = "$orderNo:${orderNo}_orderId:$orderId";

    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'qrData': qrData, // Store as text
    });

    print("QR Data stored successfully!");
  }


  //STREAM ORDER FROM FIREBASE

  Stream<List<OrderModel>> getOrdersStream(String userId) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId) // Fetch only this user's orders
        .orderBy('createdAt', descending: true) // Sort latest orders first
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderModel.fromDocumentSnapshot(doc))
          .toList();
    });
  }

  Color getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.newOrder:
        return Colors.yellow.shade200;
      case OrderStatus.accepted:
        return Colors.blue.shade200;
      case OrderStatus.rejected:
        return Colors.red.shade200;
      case OrderStatus.readyForPickup:
        return Colors.indigo.shade200;
      case OrderStatus.completed:
        return Colors.green.shade200;
      default:
        return Colors.grey.shade200; // Fallback color
    }
  }

  String getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.newOrder:
        return AppAssets.newOrder;
      case OrderStatus.accepted:
        return AppAssets.accepted;
      case OrderStatus.rejected:
        return AppAssets.rejected;
      case OrderStatus.readyForPickup:
        return AppAssets.readyForPickup;
      case OrderStatus.completed:
        return AppAssets.orderReceived;
      default:
        return AppAssets.newOrder; // Fallback color
    }
  }

  Future<void> sendPushNotification(String fcmToken, String status) async {
    try {
      const String projectId = 'home-back-admin'; // Replace with your Firebase project ID

      final Uri url = Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$projectId/messages:send');

      final String accessToken = await getAccessToken(); // Get OAuth token

      await https.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          "message": {
            "token": fcmToken,
            "notification": {
              "title": "Order Status Updated",
              "body": "Your order status is now $status",
            },
            "data": {
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "status": "done",
            }
          }
        }),
      );

      log("NOTIFICATION SENT to FCM token: $fcmToken");

    } catch (e) {
      log('Error sending push notification: $e');
    }
  }

  Future<String> getAccessToken() async {
    final credentials = auth.ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "project_id": dotenv.env['FIREBASE_PROJECT_ID'],
      "private_key_id": dotenv.env['FIREBASE_PRIVATE_KEY_ID'],
      "private_key": dotenv.env['FIREBASE_PRIVATE_KEY']!.replaceAll(r'\n', '\n'),
      "client_email": dotenv.env['FIREBASE_CLIENT_EMAIL'],
      "client_id": dotenv.env['FIREBASE_CLIENT_ID'],
      "auth_uri": dotenv.env['FIREBASE_AUTH_URI'],
      "token_uri": dotenv.env['FIREBASE_TOKEN_URI'],
      "auth_provider_x509_cert_url": dotenv.env['FIREBASE_AUTH_PROVIDER_CERT_URL'],
      "client_x509_cert_url": dotenv.env['FIREBASE_CLIENT_CERT_URL'],
    });

    final client = await clientViaServiceAccount(credentials, ['https://www.googleapis.com/auth/firebase.messaging']);
    return (client.credentials).accessToken.data;
  }

}
