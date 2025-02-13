import 'package:flutter/material.dart';
import 'package:home_bake/core/app_assets.dart';
import 'package:home_bake/core/app_colors.dart';
import 'package:lottie/lottie.dart';

class OrderCompletePage extends StatelessWidget {

  const OrderCompletePage({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.successColor,
      body: Column(
        children: [
          Lottie.asset(AppAssets.successLottie),
          const Text("Your order has been successfully placed"),
        ],
      ),
    );
  }
}
