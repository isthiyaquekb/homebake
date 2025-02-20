import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_bake/core/app_assets.dart';
import 'package:home_bake/core/app_colors.dart';
import 'package:home_bake/core/services/firebase_services.dart';
import 'package:home_bake/features/auth/model/user_model.dart';
import 'package:home_bake/features/profile/model/gender_model.dart';
import 'package:home_bake/utils/date_formatter.dart';
enum GenderEnum {
  male,
  female,
  other,

}

class ProfileViewmodel extends ChangeNotifier{
  final storageBox = GetStorage();
  final FirebaseServices _firebaseServices = FirebaseServices();

  final formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();



  TextEditingController get firstController => _firstNameController;
  TextEditingController get lastController => _lastNameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get addressController => _addressController;
  TextEditingController get dobController => _dobController;

  final bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isEnabled = false;
  bool get isEnabled => _isEnabled;

  User? _user;

  User? get user => _user;
  String _userId="";
  Timestamp _createdDate=Timestamp.now();
  Timestamp get createdDate => _createdDate;

  String get userId => _userId;

  bool _isFemale = false;
  bool get isFemale => _isFemale;
  final List<GenderModel> _genderList = [
    GenderModel(name: "Male", icon: AppAssets.male),
    GenderModel(name: "Female", icon: AppAssets.female),
  ];
  List<GenderModel> get genderList => _genderList;
  late DateTime birthdate;
  DateTime? date;
  // DateFormat? format;
  int _selectedGenderIndex=0;
  int get selectedGenderIndex => _selectedGenderIndex;

  void setGenderIndex(int index){
    _selectedGenderIndex=index;
  }
  void onInit() async {
    _userId=await fetchUserId();
    birthdate=DateTime.now();
    notifyListeners();
  }
  Future<String> fetchUserId() async {
    _user = _firebaseServices.auth.currentUser;
    return _user!.uid;
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

  Future<void> setProfileData(UserModel user)async {
    _emailController.text=user.email;
    _firstNameController.text=user.firstname;
    _lastNameController.text=user.lastname;
    _phoneController.text=user.phone;
    _addressController.text=user.address;
    _createdDate=user.createdAt;
   /* if(!isEnabled){
      birthdate = user.dob == "" ? date ?? DateTime(DateTime.now().year - 16,DateTime.now().month, DateTime.now().day) : DateTime.parse(user.dob);
      log("BIRTHDATE:$birthdate");
    }*/
    if(user.address!=""){
      for (var element in genderList) {
        if(user.gender==element.name){
          setGenderIndex(genderList.indexOf(element));
        }
      }
    }
  }

  Future<DateTime?> dobPicker(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 100,DateTime.now().month, DateTime.now().day),
      initialDate: birthdate,
      keyboardType: TextInputType.datetime,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      lastDate: _calculateLastAllowedDate(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColor.primaryColor, // header background color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColor.accentColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    birthdate=date!;
    log("PICKED DATE:$date");
    _dobController.text=DateFormatter.formatDDYYMM(date);
    notifyListeners();
    return date;
  }

  //CALCULATE DATE FOR AGE RESTRICTION
  DateTime _calculateLastAllowedDate() {
    DateTime today = DateTime.now();
    DateTime lastAllowedDate = DateTime(today.year - 16, today.month, today.day);
    // Handle leap year correction
    if (lastAllowedDate.isAfter(today)) {
      lastAllowedDate = DateTime(today.year - 16, today.month, today.day - 1);
    }
    return lastAllowedDate;
  }

  emailValidator(value, context) {
    if (value.isNotEmpty && RegExp(r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
      return null;
    }
    return "Invalid mail";
  }
  void enableEdit(bool isEnabled) {
    _isEnabled=isEnabled;
    notifyListeners();
  }

  Future<void> updateUserProfile(String userId, UserModel userData) async {
    try{
      await _firebaseServices.fireStore
          .collection('Users')
          .doc(userId)
          .set(userData.toJson(), SetOptions(merge: true)); // Merge new fields without overwriting
      log("PROFILE UPDATE RESPONSE");
      enableEdit(!isEnabled);
    }catch(e){
      log("EXCEPTION:${e.toString()}");
    }
  }

  void updateSession() {
    if(formKey.currentState!.validate()){
      var userData=UserModel(userId: userId,role: 'user', firstname: firstController.text, lastname: lastController.text, email: emailController.text, phone: phoneController.text, address: addressController.text, gender: genderList[selectedGenderIndex].name, dob: birthdate.toString(), createdAt: createdDate,modifiedAt: Timestamp.now(),);
      updateUserProfile(userId, userData);
    }
  }

  void setGender(bool value) {
    _isFemale=value;
    notifyListeners();
  }

}