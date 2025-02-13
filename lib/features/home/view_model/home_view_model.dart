import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
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
  bool _isLoading = false;
  String _area = "";
  String _city = "";
  String _state = "";
  bool _isLocationGranted = false;
  List<CategoryModel> get categoryList=> _categoryList;
  List<ProductModel> get productList=> _productList;
  List<ProductModel> get filteredProducts => _filteredProducts;
  GlobalKey<ScaffoldState> get globalKey=> _globalKey;
  bool get isLocationGranted => _isLocationGranted;
  String get area => _area;
  String get city => _city;
  String get state => _state;


  void init() async {
   await getCategories();
   await getProducts();
   if(!isLocationGranted){
     await AppPermissions.instance.requestPermission(Permission.location);
   }
   _isLocationGranted = await AppPermissions.instance.isPermissionGranted(Permission.location);
   if(isLocationGranted){
     final position=  await getCurrentLocation();
     getLocationByPosition(position);

   }
   notifyListeners();
  }


  getLocationByPosition(Position position)async{
    // log("LAT:${position.latitude},LON:${position.longitude}");
    log("LAT:${8.2833322},LON:${73.0333332}");
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      var output = placemarks;
      Placemark place = placemarks.first;

      _area=placemarks[0].locality.toString();
      _city=placemarks[0].subLocality.toString();
      _state=placemarks[0].administrativeArea.toString();

      log("""
      Name: ${place.name}
      Street: ${place.street}
      ISO Country Code: ${place.isoCountryCode}
      Country: ${place.country}
      Postal Code: ${place.postalCode}
      Administrative Area (State): ${place.administrativeArea}
      Subadministrative Area: ${place.subAdministrativeArea}
      Locality (City): ${place.locality}
      Sublocality: ${place.subLocality}
      Thoroughfare: ${place.thoroughfare}
      Subthoroughfare: ${place.subThoroughfare}
      """);
    }
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
    log("SEARCH PRODUCTS QUERY: ${searchQuery}");
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

}