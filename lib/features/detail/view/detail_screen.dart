import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_bake/core/app_assets.dart';
import 'package:home_bake/core/app_colors.dart';
import 'package:home_bake/features/detail/view_model/detail_view_model.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(height: MediaQuery.of(context).size.height*0.3,width: double.maxFinite,decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child:  Align(
                          alignment: Alignment.center,
                          child:  Container(height: MediaQuery.of(context).size.height*0.5,width: MediaQuery.of(context).size.width*0.5,decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),child: const Image(image: AssetImage(AppAssets.homeMade),),),
                        ),),
                        Align(
                          alignment: Alignment.centerRight,
                          child:  Container(
                              margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.05,horizontal: 16),height: MediaQuery.of(context).size.height*0.5,width: MediaQuery.of(context).size.width*0.08,decoration: BoxDecoration(
                              color: Colors.blue.shade300,
                              borderRadius: BorderRadius.circular(20)
                          ),child: Consumer<DetailViewModel>(builder: (context, provider, child) => Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              for(int i=0;i<provider.sizeList.length;i++)
                                InkWell(
                                  onTap: (){
                                    provider.setSize(i);
                                  },
                                  child: Container(height: 20,width: double.maxFinite,decoration: BoxDecoration(
                                      color: provider.selectedSizeIndex==i?Colors.black:Colors.transparent,
                                      borderRadius: BorderRadius.circular(20)
                                  ),child: Center(child: Text(provider.sizeList[i],style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 12),))),
                                ),
                            ],
                          ),)),
                        )
                      ],
                    ),),
                    Container(margin: const EdgeInsets.only(top: 16),height: 40,decoration: BoxDecoration(
                        color: Colors.orange.shade300,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15),bottomRight: Radius.circular(15))
                    ),child: Consumer<DetailViewModel>(builder: (context, provider, child) => Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: InkWell(
                            onTap: (){
                              provider.incrementCount();
                            },
                            child: Container(decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),child: const Icon(Icons.add),),
                          ),
                        ),
                        Text(provider.count.toString(),style: const TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w400),),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: InkWell(
                            onTap: (){
                              provider.decrementCount();
                            },
                            child: Container(decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),child: Icon(Icons.remove),),
                          ),
                        )
                      ],
                    ),)),
                    const Text("Birthday Cake",style: TextStyle(color: Colors.black,fontSize: 24,fontWeight: FontWeight.w600),),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RatingBarIndicator(
                          rating: 2.75,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 24.0,
                          direction: Axis.horizontal,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: const Text("(47 Reviews)",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w400),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.local_fire_department),
                          Text("130 calories",style: TextStyle(
                            color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600
                          ),),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.timer),
                          Text("40-60 min",style: TextStyle(
                              color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600
                          ),),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.monitor_weight_outlined),
                          Text("3 kg",style: TextStyle(
                              color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600
                          ),),
                        ],
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
  }
}
