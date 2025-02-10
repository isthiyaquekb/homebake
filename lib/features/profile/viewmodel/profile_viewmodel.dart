import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_bake/core/app_keys.dart';
import 'package:home_bake/core/services/firebase_services.dart';
import 'package:home_bake/features/auth/model/user_model.dart';

class ProfileViewmodel extends ChangeNotifier{
  final storageBox = GetStorage();
  final FirebaseServices _firebaseServices = FirebaseServices();

  final formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();



  TextEditingController get firstController => _firstNameController;
  TextEditingController get lastController => _lastNameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get addressController => _addressController;

  User? _user;

  User? get user => _user;
  String _userId="";

  String get userId => _userId;
  void onInit() async {
    _userId=storageBox.read(AppKeys.keyUserId);
    notifyListeners();
  }
  Stream<UserModel?> getUserDetail(String userId) {
    return _firebaseServices.fireStore
        .collection('Users')
        .where('userId', isEqualTo: userId) // Query by userId field
        .limit(1) // Limit to 1 result since userId should be unique
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return UserModel.fromMap(snapshot.docs.first.data());
      } else {
        return null;
      }
    });
  }

  void setProfileData(UserModel user) {
    _emailController.text=user.email;
    _firstNameController.text=user.firstname;
    _lastNameController.text=user.lastname;
    _phoneController.text=user.phone;
    _addressController.text=user.address;
  }
}