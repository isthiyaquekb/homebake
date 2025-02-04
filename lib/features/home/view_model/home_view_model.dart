import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_bake/core/app_assets.dart';
import 'package:home_bake/core/services/firebase_services.dart';
import 'package:home_bake/features/home/model/category_model.dart';
import 'package:home_bake/features/home/model/popular_cake_model.dart';
import 'package:home_bake/features/home/model/product_model.dart';

class HomeViewModel extends ChangeNotifier{

  final FirebaseServices _firebaseServices = FirebaseServices();

  var selectedCategoryIndex=0;
  var selectedPopularIndex=0;

  List<CategoryModel> _categoryList=[];
  List<ProductModel> _productList=[];
  bool _isLoading = false;
  List<CategoryModel> get categoryList=> _categoryList;
  List<ProductModel> get productList=> _productList;
  bool get isLoading => _isLoading;


  void init() async {
   await getCategories();
   await getProducts();
   notifyListeners();
  }

  void setIsLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }


  void setCategory(int index){
    selectedCategoryIndex=index;
    log("CATEGORY TAP INDEX:$index");
    notifyListeners();
  }

  void setPopular(int index){
    selectedPopularIndex=index;
    notifyListeners();
  }

  /// Fetch category from FireStore
  Future<void> getCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot querySnapshot = await _firebaseServices.fireStore.collection('categories').get();
      _categoryList = querySnapshot.docs.map((doc) => CategoryModel.fromDocumentSnapshot(doc)).toList();
      log("CATEGORY IMAGE:${_categoryList[0].image}");
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching products: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Fetch products from FireStore
  Future<void> getProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot querySnapshot = await _firebaseServices.fireStore.collection('products').get();
      _productList = querySnapshot.docs.map((doc) => ProductModel.fromDocumentSnapshot(doc)).toList();
      log("PRODUCTS:${productList[0].image}");
    } catch (e) {
      debugPrint("Error fetching products: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

}