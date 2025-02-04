import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_bake/core/app_keys.dart';
import 'package:home_bake/core/app_routes.dart';

class SplashProvider extends ChangeNotifier{

  Timer? _timer;

  final storageBox=GetStorage();

  void startTimer(BuildContext context) {
    storageBox.writeIfNull(AppKeys.keyIsLoggedIn, false);
    _timer = Timer(const Duration(seconds: 3), navigateToHome(context));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


  navigateToHome(BuildContext context) {
  storageBox.read(AppKeys.keyIsLoggedIn)?Navigator.of(context).pushReplacementNamed(AppRoutes.home):Navigator.of(context).pushReplacementNamed(AppRoutes.onBoard);
  }


}

