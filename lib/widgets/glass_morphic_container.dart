import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:home_bake/features/home/model/product_model.dart';

class GlassMorphicContainer extends StatelessWidget {
  final ProductModel productModel;
  const GlassMorphicContainer({super.key,required this.productModel});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 120,
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                productModel.name,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 20,fontWeight: FontWeight.w600),
              ),
              Text(
                "140 g",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 14,fontWeight: FontWeight.w400),
              ),
              Text(
                productModel.businessDesc,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 14,fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }


}