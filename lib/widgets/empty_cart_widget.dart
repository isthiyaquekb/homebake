import 'package:flutter/material.dart';
import 'package:home_bake/core/app_assets.dart';
import 'package:lottie/lottie.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(
          AppAssets.emptyCartLottie,
          fit: BoxFit.cover,
          repeat: true,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("Your cart is empty, please add product to continue your shopping",textAlign: TextAlign.center,style: Theme.of(context).textTheme.labelMedium,),
        )
      ],
    );
  }
}
