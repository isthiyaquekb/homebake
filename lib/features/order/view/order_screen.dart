import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_bake/core/app_assets.dart';
import 'package:home_bake/core/app_colors.dart';
import 'package:home_bake/features/order/model/order_status.dart';
import 'package:home_bake/features/order/viewmodel/order_view_model.dart';
import 'package:home_bake/widgets/common_app_bar.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderViewModel =
          Provider.of<OrderViewModel>(context, listen: false);
      orderViewModel.getOrders();
    });
    return Scaffold(
      appBar: const CommonAppBar(title: 'Order', actionList: []),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Consumer<OrderViewModel>(
            builder: (context, provider, child) => ListView.builder(
              itemCount: provider.orderList.length,
              itemBuilder: (context, index) => Container(
                height: 180,
                width: double.maxFinite,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      height: 180,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.borderColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  color: AppColor.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: CachedNetworkImage(imageUrl: provider.orderList[index].items[0]["image"],),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("#${provider.orderList[index].orderId}"),
                                  Text("${provider.orderList[index].items[0]["name"]}"),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("(${provider.orderList[index].items[0]["quantity"]} x ${provider.orderList[index].items[0]["price"]})"),
                                      Text("${provider.orderList[index].totalAmount}"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        top: 20,
                        left: 20,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40)),
                          child: SvgPicture.asset(AppAssets.newOrder),
                        )),
                    Positioned(
                        top: 20,
                        right: 20,
                        child: Container(
                          height: 40,
                          width: 140,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(child: Text(provider.orderList[index].status.displayName),
                        )))
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
