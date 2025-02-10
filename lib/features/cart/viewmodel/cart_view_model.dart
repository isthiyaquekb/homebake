import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_bake/core/services/firebase_services.dart';
import 'package:home_bake/features/cart/model/cart_model.dart';

class CartViewModel extends ChangeNotifier{

  final FirebaseServices _firebaseServices = FirebaseServices();
  List<CartModel> _cartItems = [];
  int _cartCount = 0;
  double _totalAmount = 0;

  List<CartModel> get cartItemsList => _cartItems;
  int get cartCount => _cartCount;
  double get totalAmount => _totalAmount;

  User? _user;

  User? get user => _user;

  void init() async{
    var uid=await fetchUserId();
    log("USER ID cart: $uid");
    fetchCart(uid).listen((cartItems) {
      if (_cartCount != cartItems.length) {
        setCartCount(cartItems.length,cartItems);
      }
    });
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
        .map((snapshot) {
      return snapshot.docs.map((doc) => CartModel.fromMap(doc.data())).toList();
    });

  }

  void setCartCount(int count, List<CartModel> cartList,){
    _totalAmount=0;
    _cartItems=cartList;
    _cartCount=count;
    log("SET CART COUNT:${cartCount}");
   for (var element in cartList) {
     _totalAmount+=(element.quantity*element.price);
   }
  }

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
      init();
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
        await docRef.update({'quantity': item.quantity + 1});
      } else {
        await docRef.set(item.toMap());
      }

      fetchCart(userId);
      init();
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
        await docRef.update({'quantity': item.quantity-1});
      } else {
        item.quantity = 1;
        await docRef.set(item.toMap());
      }

      fetchCart(userId);
      init();
    } catch (e) {
      print("Error adding to cart: $e");
    }
  }


  ///DELETE CART
  Future<void> deleteCartItem(String userId, String productId) async {
    try {
      await _firebaseServices.fireStore
          .collection('carts')
          .doc(userId)
          .collection('items')
          .doc(productId)
          .delete();

      print("Cart item deleted: $productId");
    } catch (e) {
      print("Error deleting cart item: $e");
    }
  }

}