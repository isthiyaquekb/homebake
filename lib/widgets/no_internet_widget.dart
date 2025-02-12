import 'package:flutter/material.dart';
import 'package:home_bake/core/app_assets.dart';
import 'package:lottie/lottie.dart';

class NotInternetWidget extends StatelessWidget {
  const NotInternetWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        AppAssets.noInternetLottie,
        fit: BoxFit.cover,
        repeat: true,
      ),
    );
  }
}