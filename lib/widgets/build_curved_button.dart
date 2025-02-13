import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget buildCurvedButton({
  required String icon,
  required Alignment alignment,
}) {
  return Container(
      width: 60,
      height: 60,
      alignment: alignment,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.3),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child:SvgPicture.asset(icon)
  );
}