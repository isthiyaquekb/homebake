import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonAppBar extends StatelessWidget implements  PreferredSizeWidget{
  final String title;
  final List<Widget> actionList;
  const CommonAppBar({
    super.key,
    required this.title,
    required this.actionList
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
      actions: actionList,
    );
  }
  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(50);
}