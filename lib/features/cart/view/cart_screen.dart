import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_bake/core/app_assets.dart';
import 'package:home_bake/core/app_colors.dart';
import 'package:home_bake/features/cart/model/cart_model.dart';
import 'package:home_bake/features/cart/viewmodel/cart_view_model.dart';
import 'package:home_bake/widgets/common_app_bar.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Add Your Code here.
      final cartViewmodel = Provider.of<CartViewModel>(context, listen: false);
      cartViewmodel.init();
    });
    return Scaffold(
      appBar: const CommonAppBar(title: 'Cart', actionList: []),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Consumer<CartViewModel>(
                    builder: (context, cartProvider, child) =>
                        StreamBuilder<List<CartModel>>(
                          stream:
                              cartProvider.fetchCart(cartProvider.user!.uid),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Text("CART IS EMPTY");
                            }
                            final cartItems = snapshot.data!;

                            return ListView.builder(
                              itemCount: cartItems.length,
                              itemBuilder: (context, index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Container(
                                  height: 80,
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: AppColor.darkBorder),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Colors.indigo.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: const Image(
                                            image:
                                                AssetImage(AppAssets.appLogo),
                                          )),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cartItems[index].name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                              Text(
                                                  '\u{20B9}${cartItems[index].price.toStringAsFixed(2)}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall), //u20B9 rupee symbol
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Container(
                                          height: 40,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  cartProvider.decrementCart(
                                                      cartProvider.user!.uid,
                                                      cartItems[index]);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 2.0),
                                                  child: SvgPicture.asset(
                                                      AppAssets.minus),
                                                ),
                                              ),
                                              Text(cartItems[index].quantity
                                                  .toString()),
                                              InkWell(
                                                onTap: () {
                                                  cartProvider.incrementCart(
                                                      cartProvider.user!.uid,
                                                      cartItems[index]);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 2.0),
                                                  child: SvgPicture.asset(
                                                      AppAssets.add),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ))),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              height: 40,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  "Proceed to checkout",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
