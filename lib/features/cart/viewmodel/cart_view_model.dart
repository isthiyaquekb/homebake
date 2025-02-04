import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_bake/core/services/firebase_services.dart';
import 'package:home_bake/features/cart/model/cart_model.dart';

class CartViewModel extends ChangeNotifier{

  final FirebaseServices _firebaseServices = FirebaseServices();
  List<CartModel> _cartItems = [];

  List<CartModel> get cartItems => _cartItems;

  User? _user;

  User? get user => _user;

  void init() async{
    var uid=await fetchUserId();
    print("USER ID cart: $uid");
    fetchCart(uid);
  }
  Future<String> fetchUserId() async {
    _user = _firebaseServices.auth.currentUser;
    notifyListeners();
    return _user!.uid;
  }

  /// Stream to listen for cart updates in real-time
  Stream<List<CartModel>> fetchCart(String userId) {
    return _firebaseServices.fireStore
        .collection('carts')
        .doc(userId)
        .collection('items')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => CartModel.fromMap(doc.data())).toList());
  }

  // Future<void> fetchCart(String userId) async {
  //   try {
  //     final snapshot = await _firebaseServices.fireStore.collection('carts').doc(userId).collection('items').get();
  //     _cartItems = snapshot.docs.map((doc) => CartModel.fromMap(doc.data())).toList();
  //     log("CART LENGTH:${_cartItems.length}");
  //     notifyListeners();
  //   } catch (e) {
  //     print("Error fetching cart: $e");
  //   }
  // }

  Future<void> addToCart(String userId, CartModel item) async {
    try {
      final docRef = _firebaseServices.fireStore.collection('carts').doc(userId).collection('items').doc(item.productId);
      final doc = await docRef.get();

      if (doc.exists) {
        await docRef.update({'quantity': FieldValue.increment(1)});
      } else {
        await docRef.set(item.toMap());
      }

      fetchCart(userId);
    } catch (e) {
      print("Error adding to cart: $e");
    }
  }

  ///INCREMENT CART
  Future<void> incrementCart(String userId, CartModel item) async {
    log("INCREMENT CART IS CALLED");
    try {
      final docRef = _firebaseServices.fireStore.collection('carts').doc(userId).collection('items').doc(item.productId);
      final doc = await docRef.get();

      if (doc.exists) {
        await docRef.update({'quantity': item.quantity++});
      } else {
        await docRef.set(item.toMap());
      }

      fetchCart(userId);
    } catch (e) {
      print("Error adding to cart: $e");
    }
  }

  ///DECREMENT CART
  Future<void> decrementCart(String userId, CartModel item) async {
    log("DECREMENT CART IS CALLED");
    try {
      final docRef = _firebaseServices.fireStore.collection('carts').doc(userId).collection('items').doc(item.productId);
      final doc = await docRef.get();

      if (doc.exists) {
        await docRef.update({'quantity': item.quantity--});
      } else {
        await docRef.set(item.toMap());
      }

      fetchCart(userId);
    } catch (e) {
      print("Error adding to cart: $e");
    }
  }



}