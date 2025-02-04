import 'package:flutter/material.dart';
import 'package:home_bake/core/app_assets.dart';
import 'package:home_bake/core/app_colors.dart';
import 'package:home_bake/core/app_routes.dart';
import 'package:home_bake/features/home/model/popular_cake_model.dart';
import 'package:home_bake/features/home/model/product_model.dart';
import 'package:home_bake/features/home/view_model/home_view_model.dart';
import 'package:provider/provider.dart';

class PopularCakeItemWidget extends StatelessWidget {
  final ProductModel product;
  final int selectedIndex;
  const PopularCakeItemWidget({
    super.key,
    required this.product,
    required this.selectedIndex
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Stack(
        children: [
          InkWell(
            onTap: (){
              Navigator.pushNamed(context, AppRoutes.details);
              context.read<HomeViewModel>().setPopular(selectedIndex);
            },
            child: Container(margin: const EdgeInsets.only(top: 40),width: 120,decoration: BoxDecoration(
              color: context.watch<HomeViewModel>().selectedPopularIndex==selectedIndex?AppColor.blackLight.withOpacity(0.6):AppColor.white,
              borderRadius: BorderRadius.circular(10),
            ),child: Column(
              children: [
                Container(height: MediaQuery.of(context).size.height*0.08,decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
                ),),
                Container(height: MediaQuery.of(context).size.height*0.18,decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                ),child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name,maxLines: 2,style: const TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w600),),
                          Flexible(
                            child: Text("Desc: ${product.description}",style: TextStyle(color: Colors.black38,fontSize: 10,fontWeight: FontWeight.w400),),
                          ),
                        ],
                      ),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("\$ ${product.price}",style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.w700),),

                        ],
                      ),
                    ],
                  ),
                ),),
              ],
            ),),
          ),
          Positioned(top: 0,left: 0,right: 0,child: Image(image: AssetImage(AppAssets.appLogo),height: 80,width: 110,),),
          Positioned(bottom: 0,right: 0,child:ClipRRect(
    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),),
            child: Container(decoration: BoxDecoration(
                color: Colors.red.shade300,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5),)
            ),child: Icon(Icons.add,size: 20,)),
          ),)
        ],
      ),
    );
  }
}
