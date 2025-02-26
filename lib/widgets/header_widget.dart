
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final String trailTitle;
  final VoidCallback onTap;
  const HeaderWidget({
    super.key,
    required this.title,
    required this.trailTitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: onTap,
              child: trailTitle!=""?Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(trailTitle),
                  const Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 16,
                  )
                ],
              ):SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}