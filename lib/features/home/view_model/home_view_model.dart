import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:free_map/free_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:home_bake/core/services/firebase_services.dart';
import 'package:home_bake/features/home/model/category_model.dart';
import 'package:home_bake/features/home/model/product_model.dart';
import 'package:home_bake/utils/app_permissions.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeViewModel extends ChangeNotifier{
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey(); // Create a key
  final FirebaseServices _firebaseServices = FirebaseServices();
  TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;
  var selectedCategoryIndex=0;
  var selectedPopularIndex=0;

  List<CategoryModel> _categoryList=[];
  List<ProductModel> _productList=[];
  List<ProductModel> _filteredProducts = [];
  final List<String> _addressList = [];
  bool _isLoading = false;
  bool _isLocating = false;
  String _area = "";
  String _city = "";
  String _state = "";
  bool _isLocationGranted = false;
  final bool _isLocationDenied = false;
  List<CategoryModel> get categoryList=> _categoryList;
  List<ProductModel> get productList=> _productList;
  List<ProductModel> get filteredProducts => _filteredProducts;
  List<String> get addressList => _addressList;
  GlobalKey<ScaffoldState> get globalKey=> _globalKey;
  bool get isLocationGranted => _isLocationGranted;
  bool get isLoading => _isLoading;
  bool get isLocating => _isLocating;
  String get area => _area;
  String get city => _city;
  String get state => _state;


  void init() async {
   await getCategories();
   await getProducts();
  _isLocating=true;
   if(!isLocationGranted){
     await AppPermissions.instance.requestPermission(Permission.location);
   }
   _isLocationGranted = await AppPermissions.instance.isPermissionGranted(Permission.location);
   if(!await AppPermissions.instance.isPermissionGranted(Permission.location)){
     await AppPermissions.instance.requestPermission(Permission.location);
   }
   final position=  await getCurrentLocation();
   log("POSITION:${position.latitude},${position.longitude}");
   getAddress(LatLng(position.latitude, position.longitude));
   notifyListeners();
  }

  Future<void> getAddress(LatLng pos) async {
    final data = await FmService().getAddress(
      lat: pos.latitude,
      lng: pos.longitude,
    );
    print(data?.address);
    List<String> splitList=[];
    splitList=data!.address.split(",");
    log("SPLIT:$splitList");
    // _addressList.add();
    String address =  correctAddress(splitList);
    _area=address.split(",")[0].toString();
    _city=address.split(",")[1].toString();
    _state=address.split(",")[2].toString();
    print("FINAL ADDRESS:$address");

    _isLocating=false;
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
  /// Filter products by category name
  Future<void> filterProductByCategoryName(String categoryName)async{
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot querySnapshot = await _firebaseServices.fireStore
          .collection('products')
          .where('category', isEqualTo: categoryName) // FireStore filtering
          .get();

      _productList = querySnapshot.docs
          .map((doc) => ProductModel.fromDocumentSnapshot(doc))
          .toList();

      log("PRODUCTS COUNT: ${_productList.length}");
    } catch (e) {
      debugPrint("Error fetching products: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  void search(String searchQuery) async {
    log("SEARCH PRODUCTS QUERY: $searchQuery");
    if (searchQuery.isEmpty) {
      _filteredProducts.clear();
      _productList; // Reset to all products
    } else {
      _filteredProducts = _productList.where((product) {
        return product.name.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
    log("FILTER PRODUCTS: $filteredProducts");
    notifyListeners();
  }

  void clearSearch(){
    _filteredProducts.clear();
    _searchController.clear();
    notifyListeners();
  }
  void searchText(String value) {
    if(value.isEmpty){
      _filteredProducts.clear();
      _searchController=TextEditingController();
    }else{
      _searchController.text=value;
    }
    notifyListeners();
  }

  Future<Position> getCurrentLocation() async {

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

  }

  String correctAddress(List<String> addressList) {
    // Convert list to a Set to check for duplicates
    Set<String> uniqueSet = addressList.toSet();
    // Remove duplicates while preserving order
    List<String> uniqueList = addressList.toSet().toList();

    print("Unique List Before Removal: $uniqueList");

    // Remove 2nd index (index 2) and second-last index (index length - 2) if possible
    if (uniqueSet.length < addressList.length) {
      // Duplicates exist, remove index 2 (third item)
      if (uniqueList.length > 2) uniqueList.removeAt(2);
      if (uniqueList.length > 2) uniqueList.removeAt(uniqueList.length - 2);
    } else {
      // No duplicates, remove index 1 (second item)
      uniqueList.removeAt(uniqueList.length - 2);
    }

    print("Unique List After Removal: $uniqueList");

    // Convert to a formatted address string
    return uniqueList.join(", ");
  }

}