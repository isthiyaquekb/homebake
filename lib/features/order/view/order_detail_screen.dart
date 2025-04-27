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
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Consumer<OrderViewModel>(
              builder: (context, viewmodel, child) {
                return FutureBuilder<File?>(
                  future: viewmodel.fetchImage(orderItem.orderNo.toString()), // 👈 fetch based on order number
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                      return const Center(child: Text('QR Code not found'));
                    } else {
                      final file = snapshot.data!;
                      return Container(
                        height: MediaQuery.sizeOf(context).height * 0.35,
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          border: Border.all(color: AppColor.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Image.file(file), // 👈 show QR image
                        ),
                      );
                    }
                  },
                );
              },
            ),
              //WIDGET FOR QR CODE
            const SizedBox(
              height: 10,
            ), //
            Expanded(
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
            ))
          ],
        ),
      ),
    );
  }
}
