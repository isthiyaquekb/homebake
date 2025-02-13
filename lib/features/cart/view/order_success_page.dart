import 'package:flutter/material.dart';
import 'package:home_bake/core/app_assets.dart';
import 'package:home_bake/core/app_colors.dart';
import 'package:home_bake/core/app_routes.dart';
import 'package:home_bake/features/dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Lottie.asset(AppAssets.successLottie),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48.0),
              child: Text("Order placed",textAlign: TextAlign.center,style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 24,fontWeight: FontWeight.w500),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Text("Your order has been successfully placed, order status will be changed shortly, once accepted",textAlign: TextAlign.center,style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 14,fontWeight: FontWeight.w400),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: ElevatedButton(onPressed: () {
                // Navigate back to Dashboard and set the Orders tab as active
                Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.dashboard, (route) => false);
                context.read<DashboardViewmodel>().setCurrentIndex(1);
              }, child: const Center(child: Text("Go to home"),)),
            ),
          ],
        ),
      ),
    );
  }
}
