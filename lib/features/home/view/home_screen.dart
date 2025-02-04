import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_bake/core/app_assets.dart';
import 'package:home_bake/features/home/view_model/home_view_model.dart';
import 'package:home_bake/widgets/category_item_widget.dart';
import 'package:home_bake/widgets/header_widget.dart';
import 'package:home_bake/widgets/popular_cake_item_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    homeViewModel.getProducts();
    return Scaffold(
      drawer: Drawer(
          child: Column(
            children: [
              Container(
                height: 40,
                color: Colors.grey.shade400,
              ),
              Container(
                height: 40,
                color: Colors.grey.shade500,
              ),
              Container(
                height: 40,
                color: Colors.grey.shade600,
              ),
              const Divider(
                height: 0.5,
                thickness: 0.6,
                color: Colors.red,
              ),
              Container(
                height: 40,
                color: Colors.grey.shade700,
              ),
            ],
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 46.0, left: 16.0, bottom: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //widgets for menu and cart
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(AppAssets.menu),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SvgPicture.asset(AppAssets.cart),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              //widget to display locations
              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.25,
                width: double.maxFinite,
                decoration: const BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                      alignment: Alignment.centerRight,
                      image:  AssetImage(
                        AppAssets.homeBackground,
                      ),

                    )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              AppAssets.locationIcon,
                              height: 24,
                              width: 24,
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                              child: const Text("Minicoy Island,Lakshadweep"),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //widget to headline
                        Text("What would you like \nto eat today?"),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //widget for search
              Row(
                children: [
                  Container(
                    height: 40,
                    margin: const EdgeInsets.only(right: 8),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width - 72 - 16,
                    decoration: BoxDecoration(
                        color: Colors.green.shade200,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        border: Border.all(color: Colors.black26)),
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: "Search here...",
                          enabledBorder: InputBorder.none,
                          contentPadding:
                          EdgeInsets.only(left: 16, bottom: 10)),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    margin: EdgeInsets.only(left: 4, right: 16),
                    decoration: BoxDecoration(
                        color: Colors.red.shade200,
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        AppAssets.searchIcon,
                        colorFilter:
                        ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const HeaderWidget(
                title: "Discover by category", trailTitle: "See All",),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  height: 120,
                  child: Consumer<HomeViewModel>(
                    builder: (context, provider, child) =>
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: provider.categoryList.length,
                          itemBuilder: (context, index) =>
                              CategoryItemWidget(selectedIndex:index, categoryData: provider.categoryList[index],),
                        ),)),
              const SizedBox(
                height: 20,
              ),
              const HeaderWidget(
                title: "Popular cakes", trailTitle: "See All",),
              SizedBox(
                height: 250,
                child: Consumer<HomeViewModel>(
                  builder: (context, homeViewProvider, child) =>
                      ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: homeViewProvider.productList.length,
                        itemBuilder: (context, index) =>
                            PopularCakeItemWidget(selectedIndex:index,product: homeViewProvider
                                .productList[index]),
                      ),),),
            ],
          ),
        ),
      ),
    );
  }
}



