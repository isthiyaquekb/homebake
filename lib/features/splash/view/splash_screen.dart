import 'package:flutter/material.dart';
import 'package:home_bake/core/app_assets.dart';
import 'package:home_bake/features/splash/view_model/splash_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final splashViewmodel=context.read<SplashProvider>();
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      splashViewmodel.startTimer(context);
    });
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: Center(
            child: Hero(
              tag: AppAssets.appLogo,
              child: Image(
                height: MediaQuery.sizeOf(context).height*0.45,
                width: MediaQuery.sizeOf(context).width
                ,image: const AssetImage(AppAssets.appLogo),fit: BoxFit.contain,),
            ),
          ),),
          const Center(
            child: Text("Copyright@2025"),
          ),
          const SizedBox(height: 40,),
        ],
      ),
    );
  }
}
