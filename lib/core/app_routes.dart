
import 'package:flutter/material.dart';
import 'package:home_bake/features/auth/view/signup_screen.dart';
import 'package:home_bake/features/cart/view/cart_screen.dart';
import 'package:home_bake/features/dashboard/view/dashboard_screen.dart';
import 'package:home_bake/features/detail/view/detail_screen.dart';
import 'package:home_bake/features/home/model/product_model.dart';
import 'package:home_bake/features/home/view/home_screen.dart';
import 'package:home_bake/features/auth/view/login_screen.dart';
import 'package:home_bake/features/onboarding/view/onboarding_screen.dart';
import 'package:home_bake/features/seeall/view/see_all_screen.dart';
import 'package:home_bake/features/splash/view/splash_screen.dart';

abstract class AppRoutes {
  static const splash = '/';
  static const onBoard = '/on-board';
  static const login = '/login';
  static const signUp = '/sign-up';
  static const dashboard = '/dashboard';
  static const home = '/home';
  static const details = '/details';
  static const seeAll = '/see-all';
  static const search = '/search';
  static const permission = '/permission';
  static const cart = '/cart';


  static Route<dynamic> generatedRoutes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(builder: (context) => const SplashScreen());

      case onBoard:
        return MaterialPageRoute(builder: (context) => OnboardingScreen());

      case login:
        return MaterialPageRoute(builder: (context) => LoginScreen());

      case signUp:
        return MaterialPageRoute(builder: (context) => SignupScreen());
      case home:
        return MaterialPageRoute(builder: (context) => HomeScreen());
      case dashboard:
        return MaterialPageRoute(builder: (context) => DashboardScreen());
      case details:
        return MaterialPageRoute(
          builder: (context) {
            var argument = routeSettings.arguments;
            final productData = argument;
            return DetailScreen(product: productData);
          },
        );
      case seeAll:
        return MaterialPageRoute(builder: (context) => SeeAllScreen());

      case cart:
        return MaterialPageRoute(builder: (context) => CartScreen());
      default:
        throw const FormatException("Route not found!, check routes again");
    }
  }
}
