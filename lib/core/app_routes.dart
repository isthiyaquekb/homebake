
import 'package:flutter/material.dart';
import 'package:home_bake/features/auth/view/forgot_password_screen.dart';
import 'package:home_bake/features/auth/view/signup_screen.dart';
import 'package:home_bake/features/cart/view/cart_screen.dart';
import 'package:home_bake/features/cart/view/order_success_page.dart';
import 'package:home_bake/features/dashboard/view/dashboard_screen.dart';
import 'package:home_bake/features/detail/view/detail_screen.dart';
import 'package:home_bake/features/home/view/home_screen.dart';
import 'package:home_bake/features/auth/view/login_screen.dart';
import 'package:home_bake/features/onboarding/view/onboarding_screen.dart';
import 'package:home_bake/features/order/view/order_detail_screen.dart';
import 'package:home_bake/features/profile/view/profile_screen.dart';
import 'package:home_bake/features/seeall/view/see_all_screen.dart';
import 'package:home_bake/features/splash/view/splash_screen.dart';

abstract class AppRoutes {
  static const splash = '/';
  static const onBoard = '/on-board';
  static const login = '/login';
  static const signUp = '/sign-up';
  static const forgotPassword = '/forgot-password';
  static const dashboard = '/dashboard';
  static const home = '/home';
  static const details = '/details';
  static const seeAll = '/see-all';
  static const search = '/search';
  static const permission = '/permission';
  static const cart = '/cart';
  static const success = '/success';
  static const failure = '/failure';
  static const profile = '/profile';
  static const orderDetails = '/order-details';


  static Route<dynamic> generatedRoutes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(builder: (context) => const SplashScreen());

      case onBoard:
        return MaterialPageRoute(builder: (context) => const OnboardingScreen());

      case login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());

      case signUp:
        return MaterialPageRoute(builder: (context) => const SignupScreen());

      case forgotPassword:
        return MaterialPageRoute(builder: (context) => const ForgotPasswordScreen());

      case dashboard:
        return MaterialPageRoute(builder: (context) => const DashboardScreen());

      case home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case success:
        return MaterialPageRoute(builder: (context) => const OrderSuccessPage());
      case failure:
        return MaterialPageRoute(builder: (context) => const DashboardScreen());

      case details:
        return MaterialPageRoute(
          builder: (context) {
            var argument = routeSettings.arguments;
            final productData = argument;
            return DetailScreen(product: productData);
          },
        );
      case seeAll:
        return MaterialPageRoute(builder: (context) => const SeeAllScreen());

      case cart:
        return MaterialPageRoute(builder: (context) => const CartScreen());
         case profile:
        return MaterialPageRoute(builder: (context) => const ProfileScreen());
      case orderDetails:
        return MaterialPageRoute(builder: (context) {
          var argument = routeSettings.arguments;
          return  OrderDetailScreen(orderItem:argument);
        });
      default:
        throw const FormatException("Route not found!, check routes again");
    }
  }
}
