import 'package:flutter/material.dart';
import 'package:home_bake/widgets/common_app_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Profile', actionList: []),
      body: Center(child: Text("PROFILE PAGE"),),
    );
  }
}
