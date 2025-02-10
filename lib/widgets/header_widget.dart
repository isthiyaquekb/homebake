
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final String trailTitle;
  const HeaderWidget({
    super.key,
    required this.title,
    required this.trailTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(trailTitle),
              const Icon(
                Icons.arrow_forward,
                color: Colors.red,
                size: 16,
              )
            ],
          ),
        ),
      ],
    );
  }
}