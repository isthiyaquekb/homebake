import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_bake/core/app_assets.dart';
import 'package:home_bake/core/app_colors.dart';
import 'package:home_bake/features/cart/view/cart_screen.dart';
import 'package:home_bake/features/cart/viewmodel/cart_view_model.dart';
import 'package:home_bake/features/dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:home_bake/features/home/view/home_screen.dart';
import 'package:home_bake/features/order/view/order_screen.dart';
import 'package:home_bake/features/profile/view/profile_screen.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
   Provider.of<DashboardViewmodel>(context,listen: false);
    return Consumer<DashboardViewmodel>(builder: (context, dashboardViewModel, child) => Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColor.secondaryColor,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedItemColor: AppColor.darkTextColor,
        items: [
          BottomNavigationBarItem(
            backgroundColor: AppColor.scaffoldBackground,
            icon: SvgPicture.asset(
              AppAssets.home,
              height: 24,
              width: 24,
              fit: BoxFit.scaleDown,
              color: AppColor.darkIndicator,
            ),
            label: "Home",
            activeIcon: SvgPicture.asset(
              AppAssets.homeFilled,
              height: 24,
              width: 24,
              fit: BoxFit.scaleDown,
              color: AppColor.secondaryColor,
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: AppColor.scaffoldBackground,
            icon: SvgPicture.asset(
              AppAssets.bag,
              height: 24,
              width: 24,
              fit: BoxFit.scaleDown,
              color: AppColor.darkIndicator,
            ),
            label: "Orders",
            activeIcon: SvgPicture.asset(
              AppAssets.bagFilled,
              height: 24,
              width: 24,
              fit: BoxFit.scaleDown,
              color: AppColor.secondaryColor,
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: AppColor.scaffoldBackground,
            icon: Badge(
              label: Text(context.watch<CartViewModel>().cartCount.toString()),
              child: SvgPicture.asset(
                AppAssets.cart,
                height: 24,
                width: 24,
                fit: BoxFit.scaleDown,
                color: AppColor.darkIndicator,
              ),
            ),
            label: "Cart",
            activeIcon: Badge(
              label: Text(context.watch<CartViewModel>().cartCount.toString()),
              child: SvgPicture.asset(
                AppAssets.cartFilled,
                height: 24,
                width: 24,
                fit: BoxFit.scaleDown,
                color: AppColor.secondaryColor,
              ),
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: AppColor.scaffoldBackground,
            icon: SvgPicture.asset(
              AppAssets.userProfile,
              height: 24,
              width: 24,
              fit: BoxFit.scaleDown,
              color: AppColor.darkIndicator,
            ),
            label: "Profile",
            activeIcon: SvgPicture.asset(
              AppAssets.userProfileFilled,
              height: 24,
              width: 24,
              fit: BoxFit.scaleDown,
              color: AppColor.secondaryColor,
            ),
          ),
        ],
        onTap: (value) {
          dashboardViewModel.setCurrentIndex(value);
        },
        currentIndex: dashboardViewModel.selectedIndex,
      ),
      body: IndexedStack(
        index: dashboardViewModel.selectedIndex,
        children: const [
          HomeScreen(), //HOME
          OrderScreen(), //ORDERS
          CartScreen(), //CART
          ProfileScreen(), //PAYMENTS
        ],
      ),

    ),);
  }
}
