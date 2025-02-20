import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_bake/core/app_keys.dart';
import 'package:home_bake/core/services/firebase_services.dart';
import 'package:home_bake/features/auth/model/user_model.dart';
import 'package:home_bake/utils/snackbars.dart';

class AuthViewmodel extends ChangeNotifier {
  final storageBox = GetStorage();
  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();
  final forgotFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  ///SIGN UP CONTROLLER
  TextEditingController _signupEmailController = TextEditingController();
  TextEditingController _signupPasswordController =
      TextEditingController();
  TextEditingController _signupFirstNameController =
      TextEditingController();
  TextEditingController _signupLastNameController =
      TextEditingController();
  final TextEditingController _signupDobController = TextEditingController();
  final TextEditingController _signupGenderController = TextEditingController();
  final TextEditingController _signupPhoneController = TextEditingController();
  final TextEditingController _signupAddressController = TextEditingController();
  bool _isLoading = false;
  bool _isSignUpValid = false;

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get signupEmailController => _signupEmailController;
  TextEditingController get signupPasswordController =>
      _signupPasswordController;
  TextEditingController get signupFirstNameController =>
      _signupFirstNameController;
  TextEditingController get signupLastNameController =>
      _signupLastNameController;
  TextEditingController get signupDobController => _signupDobController;
  TextEditingController get signupGenderController => _signupGenderController;
  TextEditingController get signupPhoneController => _signupPhoneController;
  TextEditingController get signupAddressController => _signupAddressController;
  bool get isLoading => _isLoading;
  bool get isSignUpValid => _isSignUpValid;
  final FirebaseServices _firebaseServices = FirebaseServices();

  User? _user;

  User? get user => _user;

  Future<bool> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseServices.auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      storageBox.write(AppKeys.keyIsLoggedIn, true);
      storageBox.write(AppKeys.keyUserId, _user?.uid);
      notifyListeners();
      return true;
    } catch (e) {
      print("Login Error: $e");
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await _firebaseServices.auth.signOut();
      _user = null;
      _emailController.clear();
      _passwordController.clear();
      storageBox.write(AppKeys.keyIsLoggedIn, false);
      notifyListeners();

      return true;
    } catch (e) {
      log("Logout exception:${e.toString()}");
      return false;
    }
  }

  void setIsLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

// Dispose controllers to prevent memory leaks
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? firstnameValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter a name.';
    }
    return null;
  }

  String? lastnameValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter a name.';
    }
    return null;
  }

  String? emailValidator(String value) {
    if (value.isEmpty || !value.contains('@')) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? passwordValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter a valid password';
    } else if (value.length < 8) {
      return 'Password requires 8 characters or more';
    }
    return null;
  }

  void sessionSignup(BuildContext context) async {
    _isSignUpValid = signupFormKey.currentState!.validate();
    // Get.focusScope!.unfocus();
    if (_isSignUpValid) {
      log("ON SAVED FIRST: ${_signupFirstNameController.text}");
      log("ON SAVED LAST: ${_signupLastNameController.text}");
      log("ON SAVED EMAIL: ${_signupEmailController.text}");
      log("ON SAVED PASSWORD: ${_signupPasswordController.text}");
      signUpApi(
          context,
          _signupEmailController.text,
          _signupPasswordController.text,
          _signupFirstNameController.text,
          _signupLastNameController.text,
          _signupGenderController.text,
          _signupDobController.text,
          _signupPhoneController.text,
          _signupAddressController.text,
      );
    }
  }

  Future<bool> signUpApi(BuildContext context, String email, String password,
      String firstname, String lastname, String gender, String dob,String phone,String address) async {
    try {
      var response = await _firebaseServices.auth
          .createUserWithEmailAndPassword(email: email, password: password);
      log("CREATED SIGNUP RESPONSE:${response.toString()}");
      _user = _firebaseServices.auth.currentUser;
      log("FIREBASE USER VALUE RESPONSE:${_user.toString()}");
      if (_user != null) {
        // isLoading.value=false;
        final userData = UserModel(
          role: 'user',
          firstname: firstname,
          lastname: lastname,
          email: email,
          userId: _user!.uid,
          gender: gender,
          phone: phone,
          address: address,
          dob: dob,
          createdAt: Timestamp.now(),
          modifiedAt: Timestamp.now(),
        );
        if (context.mounted) createUser(context, userData);
        notifyListeners();
        return true;
      } else {
        // isLoading.value=false;
        notifyListeners();
        return false;
      }
    } on FirebaseAuthException catch (firebaseException) {
      // isLoading.value=false;
      if (firebaseException.code == 'network-request-failed') {
        warningSnackBar(context, 'No Interner Connection');
      } else if (firebaseException.code == "wrong-password") {
        failureSnackBar(context, 'Please Enter correct password');
        //devtools.log('Please Enter correct password');
        //print('Please Enter correct password');
      } else if (firebaseException.code == 'user-not-found') {
        warningSnackBar(context, 'Email not found');
        // print('Email not found');
      }  else if (firebaseException.code == 'too-many-requests') {
         failureSnackBar(context, 'Too many attempts please try later');
        //print('Too many attempts please try later');
      } else if (firebaseException.code == 'unknwon') {

        warningSnackBar(context, 'Email and password field are required');
        //print('Email and password field are required');
      } else if (firebaseException.code == 'email-already-in-use') {

        warningSnackBar(context, 'Email already in use, sign in');
        Navigator.pop(context);

        clearField();

      } else {
        print(firebaseException.code);
      }
      rethrow;
    } catch (e) {
      // isLoading.value=false;
      throw e.toString();
    }
  }

  void clearField(){
    _signupFirstNameController=TextEditingController();
    _signupLastNameController=TextEditingController();
    _signupEmailController=TextEditingController();
    _signupPasswordController=TextEditingController();

  }
  void createUser(BuildContext context, UserModel userData) async {
    try{
      // Determine collection based on role
      String collection = (userData.role == "admin") ? "Admins" : "Users";

      await _firebaseServices.fireStore
          .collection(collection)
          .add(userData.toJson())
          .whenComplete(() => successSnackBar(context,"Your account has been created successfully")
      )
          .catchError((error, stackTrace) {
        failureSnackBar(context,"Something went wrong");
      });
      Navigator.of(context).pop();
    }on FirebaseAuthException catch (e){
      if (e.code == 'network-request-failed') {
        warningSnackBar(context, 'No Interner Connection');
      } else if (e.code == "wrong-password") {
        return failureSnackBar(context, 'Please Enter correct password');
        //devtools.log('Please Enter correct password');
        //print('Please Enter correct password');
      } else if (e.code == 'user-not-found') {
        warningSnackBar(context, 'Email not found');
        // print('Email not found');
      }  else if (e.code == 'too-many-requests') {
        return failureSnackBar(context, 'Too many attempts please try later');
        //print('Too many attempts please try later');
      } else if (e.code == 'unknwon') {

        warningSnackBar(context, 'Email and password field are required');
        //print('Email and password field are required');
      } else if (e.code == 'unknown') {
        warningSnackBar(context, 'Email and password field are required');
        //print(e.code);
      } else {
        print(e.code);
      }
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(BuildContext context,String email) async {
    try {
      await _firebaseServices.auth.sendPasswordResetEmail(email: email);
      print("Password reset email sent to $email");
      successSnackBar(context, 'Password reset email sent to $email');
    } catch (e) {
      print("Error sending password reset email: $e");
      rethrow;
    }
  }
}
