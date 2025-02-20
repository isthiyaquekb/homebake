import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_bake/core/app_assets.dart';
import 'package:home_bake/core/app_colors.dart';
import 'package:home_bake/core/app_routes.dart';
import 'package:home_bake/features/auth/view_model/auth_view_model.dart';
import 'package:home_bake/features/cart/viewmodel/cart_view_model.dart';
import 'package:home_bake/features/home/view_model/home_view_model.dart';
import 'package:home_bake/widgets/category_item_widget.dart';
import 'package:home_bake/widgets/header_widget.dart';
import 'package:home_bake/widgets/popular_cake_item_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
      final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
      homeViewModel.init();
      cartViewModel.init();
    });

    return Scaffold(
      key: context.read<HomeViewModel>().globalKey,
      body: Consumer<HomeViewModel>(
        builder: (context, value, child) => value.isLocating
            ? Center(
                child: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(AppAssets.locationPinLottie,height:MediaQuery.sizeOf(context).height * 0.50,),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text("Locating...",style: Theme.of(context)
                            .textTheme
                            .labelLarge,),
                      )
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 46.0, bottom: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //widgets for menu and cart
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Consumer<HomeViewModel>(
                              builder: (context, provider, child) => provider
                                      .isLoading
                                  ? SvgPicture.asset(
                                      AppAssets.locationIcon,
                                      height: 24,
                                      width: 24,
                                    )
                                  : provider.area.isNotEmpty
                                      ? Row(
                                          children: [
                                            SvgPicture.asset(
                                              AppAssets.locationIcon,
                                              height: 24,
                                              width: 24,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(
                                                  "${provider.area},${provider.city},${provider.state}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge),
                                            ),
                                          ],
                                        )
                                      : const SizedBox.shrink(),
                            ),
                            Consumer<AuthViewmodel>(
                              builder: (context, provider, child) => InkWell(
                                onTap: () async {
                                  await provider.logout();
                                  if (context.mounted) {
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        AppRoutes.login, (route) => false);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: SvgPicture.asset(
                                    AppAssets.logoutIcon,
                                    height: 24,
                                    width: 24,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //widget to display locations
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: double.maxFinite,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                            alignment: Alignment.centerRight,
                            image: AssetImage(
                              AppAssets.homeBackground,
                            ),
                          )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //widget to headline
                                  Container(
                                      margin: EdgeInsets.only(
                                          top: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.10),
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      child: Text(
                                        "What would you like to eat today?",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                                fontSize:
                                                    MediaQuery.sizeOf(context)
                                                            .height *
                                                        0.035,
                                                fontWeight: FontWeight.w600),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //widget for search
                      Consumer<HomeViewModel>(
                        builder: (context, provider, child) => Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Row(
                            children: [
                              Container(
                                height: 40,
                                margin: const EdgeInsets.only(right: 8),
                                width:
                                    MediaQuery.of(context).size.width - 72 - 16,
                                decoration: BoxDecoration(
                                    color: Colors.green.shade200,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    border:
                                        Border.all(color: AppColor.whiteLight)),
                                child: TextFormField(
                                  controller: provider.searchController,
                                  decoration: const InputDecoration(
                                    hintText: "Search here...",
                                    contentPadding:
                                        EdgeInsets.only(left: 16, bottom: 10),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        borderSide: BorderSide(
                                            color: AppColor.whiteLight)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        borderSide: BorderSide(
                                            color: AppColor.whiteLight)),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        borderSide: BorderSide(
                                            color: AppColor.darkError)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        borderSide: BorderSide(
                                            color: AppColor.darkError)),
                                  ),
                                  onChanged: (value) {
                                    log("SEARCH QUERY:$value");
                                    provider.searchText(value);
                                  },
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  provider.filteredProducts.isNotEmpty
                                      ? provider.clearSearch()
                                      : provider.search(
                                          provider.searchController.text);
                                  FocusScope.of(context).unfocus();
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  margin:
                                      const EdgeInsets.only(left: 4, right: 16),
                                  decoration: BoxDecoration(
                                      color: Colors.red.shade200,
                                      border: Border.all(color: Colors.black26),
                                      borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                      provider.filteredProducts.isNotEmpty
                                          ? AppAssets.closeIcon
                                          : AppAssets.searchIcon,
                                      colorFilter: const ColorFilter.mode(
                                          Colors.white, BlendMode.srcIn),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const HeaderWidget(
                        title: "Discover by category",
                        trailTitle: "See All",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: SizedBox(
                            height: 120,
                            child: Consumer<HomeViewModel>(
                              builder: (context, provider, child) =>
                                  ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: provider.categoryList.length,
                                itemBuilder: (context, index) =>
                                    CategoryItemWidget(
                                  selectedIndex: index,
                                  categoryData: provider.categoryList[index],
                                ),
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const HeaderWidget(
                        title: "Products",
                        trailTitle: "See All",
                      ),
                      SizedBox(
                        height: 250,
                        child: Consumer<HomeViewModel>(
                          builder: (context, homeViewProvider, child) =>
                              ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: homeViewProvider.filteredProducts.isEmpty
                                ? homeViewProvider.productList.length
                                : homeViewProvider.filteredProducts.length,
                            itemBuilder: (context, index) =>
                                PopularCakeItemWidget(
                                    selectedIndex: index,
                                    product: homeViewProvider
                                            .filteredProducts.isEmpty
                                        ? homeViewProvider.productList[index]
                                        : homeViewProvider
                                            .filteredProducts[index]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
