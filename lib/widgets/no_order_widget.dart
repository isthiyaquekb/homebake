import 'package:flutter/material.dart';
import 'package:home_bake/core/app_assets.dart';
import 'package:lottie/lottie.dart';

class NoOrderWidget extends StatelessWidget {
  const NoOrderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(
          AppAssets.noOrdersLottie,
          fit: BoxFit.cover,
          repeat: true,
        ),
        Text("No order available",style: Theme.of(context).textTheme.labelMedium,)
      ],
    );
  }
}
