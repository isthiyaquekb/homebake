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
  String _uid = "";

  List<CartModel> get cartItemsList => _cartItems;
  int get cartCount => _cartCount;
  double get totalAmount => _totalAmount;
  String get uid => _uid;

  User? _user;

  User? get user => _user;

  void init() async{
   _uid=await fetchUserId();
    notifyListeners();
    log("USER ID cart: $uid");
    fetchCart(uid).listen((cartItems) {
      if (_cartCount != cartItems.length) {
        setCartCount(cartItems.length,cartItems);
      }
    });
  }
  Future<String> fetchUserId() async {
    _user = _firebaseServices.auth.currentUser;
    return _user!.uid;
  }

  /// Stream to listen for cart updates in real-time
  Stream<List<CartModel>> fetchCart(String userId) {
   try {
    return _firebaseServices.fireStore
        .collection('carts')
        .doc(userId)
        .collection('items')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => CartModel.fromMap(doc.data())).toList();
        });
  } catch (e) {
    print('Error fetching cart stream: $e');
    return Stream.value([]);  // Return an empty stream on error
  }

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

  //CLEAR CART
  Future<void> clearUserCart(String userId) async {
    try {
      var cartRef = _firebaseServices.fireStore.collection('carts').doc(userId);
      var itemsRef = cartRef.collection('items');

      // Get all cart items
      var itemsSnapshot = await itemsRef.get();

      // Delete each item document inside 'items' subcollection
      for (var doc in itemsSnapshot.docs) {
        await doc.reference.delete();
      }

      // Now delete the cart document itself
      await cartRef.delete();
      log("Cart cleared successfully for user: $userId");
    } catch (e) {
      log("Error clearing cart: $e");
    }
  }

  //UPDATE INVENTORY
  Future<void> updateInventory(List<CartModel> cartItems) async {
    try {

      for (var item in cartItems) {
        var productRef = _firebaseServices.fireStore.collection('products').doc(item.productId);

        await _firebaseServices.fireStore.runTransaction((transaction) async {
          var snapshot = await transaction.get(productRef);

          if (!snapshot.exists) return;

          int currentStock = snapshot['stock'] ?? 0;
          int updatedStock = currentStock - item.quantity;

          transaction.update(productRef, {'stock': updatedStock});
        });
      }

      log("Inventory updated successfully");
    } catch (e) {
      log("Error updating inventory: $e");
    }
  }
}