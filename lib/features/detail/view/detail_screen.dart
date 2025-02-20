
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_bake/core/app_assets.dart';
import 'package:home_bake/core/app_colors.dart';
import 'package:home_bake/features/cart/model/cart_model.dart';
import 'package:home_bake/features/cart/viewmodel/cart_view_model.dart';
import 'package:home_bake/features/detail/view_model/detail_view_model.dart';
import 'package:home_bake/utils/snackbars.dart';
import 'package:home_bake/widgets/build_curved_button.dart';
import 'package:home_bake/widgets/glass_morphic_container.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';

class DetailScreen extends StatelessWidget {
  final dynamic product;
  const DetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    product.businessDesc.toString().split(",")[0],
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 24,fontWeight: FontWeight.w600),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(AppAssets.backArrow),
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.6,
                width: MediaQuery.sizeOf(context).width,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 30),
                          height: MediaQuery.sizeOf(context).height * 0.45,
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            color: AppColor.blackLight.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(36.0),
                            child: CachedNetworkImage(
                              imageUrl: product.image,
                              fit: BoxFit.contain,
                            ),
                          )),
                    ),
                    Positioned(
                      left: MediaQuery.sizeOf(context).width * 0.15,
                      right: MediaQuery.sizeOf(context).width * 0.15,
                      bottom: 0,
                      child: GlassMorphicContainer(productModel: product,),
                    )
                  ],
                ),
              ),
              Consumer<DetailViewModel>(builder: (context, provider, child) => Container(
                width: double.maxFinite,
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: InkWell(
                            onTap: (){
                              provider.decrementCount();
                            },
                            child: buildCurvedButton(icon: AppAssets.minus,alignment: Alignment.center,)),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            provider.count.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                fontSize: 42, fontWeight: FontWeight.w600),
                          ),
                          Container(
                            height: 40,
                            width: 120,
                            decoration:  BoxDecoration(
                                color: AppColor.darkError,
                                borderRadius: BorderRadius.circular(6)
                            ),
                            child: Center(
                                child: Text("\u{20B9} ${product.price}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,color: AppColor.white))),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child:  InkWell(
                            onTap: (){
                              provider.incrementCount();
                            },
                            child: buildCurvedButton(icon: AppAssets.add,alignment: Alignment.center,)),
                      ),
                    ],
                  ),
                ),
              ),),
              Consumer<CartViewModel>(builder: (context, cartProvider, child) => Container(height: 40,width: double.maxFinite,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColor.secondaryColor)
                ),child: SlideAction(
                    key: cartProvider.slideKey,
                    borderRadius: 10,
                    outerColor: AppColor.secondaryColor,
                    onSubmit: () async {
                      ///Do something here OnSlide
                      var cartItem=CartModel(productId: product.id, name: product.name, image: product.image, price: product.price, quantity: context.read<DetailViewModel>().count);
                      await cartProvider.addToCart(cartProvider.user!.uid.toString(), cartItem);
                      if(context.mounted)  successSnackBar(context,"Added to cart successfully");
                      Navigator.pop(context);
                      Future.delayed(
                        Duration(seconds: 1),
                            () => cartProvider.slideKey.currentState!.reset(),
                      );
                    },
                    alignment: Alignment.centerRight,
                    sliderButtonIcon: SvgPicture.asset(AppAssets.cart,color: AppColor.secondaryColor,height: 24,width: 24,fit: BoxFit.fill,),
                    child: Text(
                      'Add to cart',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,color: AppColor.white)
                    ),
                  ),
                /*child: SliderButton(
                  action: () async{
                    ///Do something here OnSlide
                    var cartItem=CartModel(productId: product.id, name: product.name, image: product.image, price: product.price, quantity: context.read<DetailViewModel>().count);
                    await cartProvider.addToCart(cartProvider.user!.uid.toString(), cartItem);
                    if(context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product.name} added to cart')));
                    Navigator.pop(context);
                    return true;
                  },

                  ///Put label over here
                  label: Text(
                      "Add to cart",
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,color: AppColor.white)
                  ),
                  icon: Center(
                      child:SvgPicture.asset(AppAssets.cart,color: AppColor.secondaryColor,)),

                  ///Change All the color and size from here.
                  width: 230,
                  radius: 10,
                  shimmer: false,
                  buttonColor: AppColor.white,
                  backgroundColor: AppColor.secondaryColor,
                  highlightedColor: Colors.white,
                  baseColor: Colors.red,

                ),*/),),
            ],
          ),
        ),
      ),
    );
  }
}
