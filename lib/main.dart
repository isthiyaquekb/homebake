import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_bake/core/app_routes.dart';
import 'package:home_bake/features/auth/view_model/auth_view_model.dart';
import 'package:home_bake/features/cart/viewmodel/cart_view_model.dart';
import 'package:home_bake/features/dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:home_bake/features/detail/view_model/detail_view_model.dart';
import 'package:home_bake/features/home/view_model/home_view_model.dart';
import 'package:home_bake/features/onboarding/view_model/onboarding_view_model.dart';
import 'package:home_bake/features/order/viewmodel/order_view_model.dart';
import 'package:home_bake/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:home_bake/features/splash/view_model/splash_provider.dart';
import 'package:home_bake/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => SplashProvider()),
    ChangeNotifierProvider(create: (_) => AuthViewmodel()),
    ChangeNotifierProvider(create: (_) => OnboardingViewModel()),
    ChangeNotifierProvider(create: (_) => DashboardViewmodel()),
    ChangeNotifierProvider(create: (_) => HomeViewModel()),
    ChangeNotifierProvider(create: (_) => DetailViewModel()),
    ChangeNotifierProvider(create: (_) => CartViewModel()),
    ChangeNotifierProvider(create: (_) => OrderViewModel()),
    ChangeNotifierProvider(create: (_) {
      final viewModel = ProfileViewmodel();
      viewModel.onInit(); // Initialize immediately
      return viewModel;
  }),
    // ChangeNotifierProvider(create: (_) {
    //   final viewModel = OrderViewModel();
    //   viewModel.onInit(); // Initialize immediately
    //   return viewModel;
    // }),
  ],child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'H O M E  B A K E',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.splash,
      onGenerateRoute:AppRoutes.generatedRoutes,
    );
  }
}

