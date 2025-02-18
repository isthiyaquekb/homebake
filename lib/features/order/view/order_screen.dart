import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_bake/core/app_colors.dart';
import 'package:home_bake/core/app_routes.dart';
import 'package:home_bake/features/order/model/order_model.dart';
import 'package:home_bake/features/order/model/order_status.dart';
import 'package:home_bake/features/order/viewmodel/order_view_model.dart';
import 'package:home_bake/utils/date_formatter.dart';
import 'package:home_bake/widgets/common_app_bar.dart';
import 'package:home_bake/widgets/no_order_widget.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderViewModel =
          Provider.of<OrderViewModel>(context, listen: false);
      orderViewModel.onInit();
    });
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: const CommonAppBar(title: 'Order', actionList: []),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Consumer<OrderViewModel>(
            builder: (context, provider, child) => StreamBuilder<List<OrderModel>>(
              stream: provider.getOrdersStream(provider.userId),
              builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const NoOrderWidget();
              }
              final orderList = snapshot.data!;
              return ListView.builder(
                itemCount: orderList.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, AppRoutes.orderDetails,arguments: orderList[index]);
                  },
                  child: Container(
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
                                  child: CachedNetworkImage(imageUrl: orderList[index].items[0]["image"],),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("#${orderList[index].orderNo}",style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),),
                                      Text("${orderList[index].items[0]["name"]}",style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400,fontSize: 14),),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Text("(${orderList[index].items[0]["quantity"]} x ${orderList[index].items[0]["price"]})"),
                                          Text("${orderList[index].totalAmount}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Text("${DateFormatter.dateTimeFromFirebase(orderList[index].createdAt)}",style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),),
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
                              child: SvgPicture.asset(provider.getStatusIcon(orderList[index].status)),
                            )),
                        Positioned(
                            top: 20,
                            right: 20,
                            child: Container(
                                height: 40,
                                width: 140,
                                decoration: BoxDecoration(
                                    color: provider.getStatusColor(orderList[index].status),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(child: Text(orderList[index].status.displayName),
                                )))
                      ],
                    ),
                  ),
                ),
              );
            },),
          )),
    );
  }
}
