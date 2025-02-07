import 'package:flutter/material.dart';
import 'package:home_bake/widgets/common_app_bar.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Order', actionList: []),
      body: Center(
        child: Text("ORDER PAGE"),
      ),
    );
  }
}
