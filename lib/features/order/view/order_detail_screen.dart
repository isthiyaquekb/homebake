import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:home_bake/core/app_colors.dart';
import 'package:home_bake/features/order/viewmodel/order_view_model.dart';
import 'package:home_bake/widgets/common_app_bar.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatelessWidget {
  final dynamic orderItem;
  const OrderDetailScreen({
    super.key,
    required this.orderItem,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const CommonAppBar(title: "Order detail", actionList: []),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Expanded(
            child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: orderItem.items.length,
          itemBuilder: (context, index) => Container(
            height: MediaQuery.sizeOf(context).height * 0.18,
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
                color: Colors.amber.shade200,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black)),
            // child: Center(child: Text(orderItem.items[index]["name"]),),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
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
                    child: CachedNetworkImage(
                      imageUrl: orderItem.items[index]["image"],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "#${orderItem.orderNo}",
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "${orderItem.items[index]["name"]}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                "(${orderItem.items[index]["quantity"]} x ${orderItem.items[index]["price"]})"),
                            Text("${orderItem.totalAmount}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
