import 'package:flutter/material.dart';
import 'package:home_bake/core/app_assets.dart';
import 'package:home_bake/core/app_colors.dart';
import 'package:home_bake/features/home/model/category_model.dart';
import 'package:home_bake/features/home/view_model/home_view_model.dart';
import 'package:provider/provider.dart';

class CategoryItemWidget extends StatelessWidget {
  final CategoryModel categoryData;
  final int selectedIndex;
  const CategoryItemWidget({
    super.key,
    required this.categoryData,
    required this.selectedIndex
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(35),
        onTap:() {
          context.read<HomeViewModel>().setCategory(selectedIndex);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: Container(height: 80,width: 60,decoration: BoxDecoration(
              color: context.watch<HomeViewModel>().selectedCategoryIndex==selectedIndex?AppColor.secondaryColor:AppColor.blackLight.withOpacity(0.2),
              borderRadius: BorderRadius.circular(35)
          ),child: Column(
            children: [
              const SizedBox(height: 10,),
              Container(
                height: 50,width: 50,
                decoration: BoxDecoration(
                  color: context.watch<HomeViewModel>().selectedCategoryIndex==selectedIndex?AppColor.white:AppColor.blackLight.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ClipRRect(borderRadius: BorderRadius.circular(60),child: Image(image: AssetImage(categoryData.image),fit: BoxFit.cover,)),
                ),
              ),
              const SizedBox(height: 10,),
              Text(categoryData.name,style: TextStyle(fontSize: 14,color: context.watch<HomeViewModel>().selectedCategoryIndex==selectedIndex?AppColor.white:AppColor.black),)
            ],
          ),),
        ),
      ),
    );
  }
}