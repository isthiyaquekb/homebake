import 'package:flutter/material.dart';
import 'package:home_bake/core/app_colors.dart';

class SeeAllScreen extends StatelessWidget {
  const SeeAllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: Column(
        children: [
          Text("ROW BACK BUTTON AND TITLE"),
          Text("HERE WILL BE UI FOR GRID"),
        ],
      ),
    );
  }
}
