import 'package:flutter/material.dart';
import 'package:home_bake/core/app_colors.dart';

class AppButton extends StatelessWidget {
  final String title;
  final double width;
  final VoidCallback onTap;
  const AppButton({
    super.key,
    required this.title,
    required this.width,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(height: 40,width: width,decoration: BoxDecoration(
          color: AppColor.primaryColor,
          borderRadius: BorderRadius.circular(8)
      ),child: Center(
        child: Text(title,style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColor.white),),
      ),),
    );
  }
}
