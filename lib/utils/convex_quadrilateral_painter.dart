import 'package:flutter/material.dart';

class ConvexQuadrilateralPainter extends CustomPainter {
  final double borderRadius = 12.0;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue.shade100
      ..style = PaintingStyle.fill;

    // Define the points of the quadrilateral
    Path path = Path();
    // Define the points for the quadrilateral
    final topLeft = Offset(size.width * 0.1, 0);
    final topRight = Offset(size.width * 0.9, 0);
    final bottomRight = Offset(size.width * 0.8, size.height);
    final bottomLeft = Offset(size.width * 0.2, size.height);

    // Draw the path with rounded corners
    path.moveTo(topLeft.dx + borderRadius, topLeft.dy);
    path.lineTo(topRight.dx - borderRadius, topRight.dy);
    path.arcToPoint(
      Offset(topRight.dx, topRight.dy + borderRadius),
      radius: Radius.circular(borderRadius),
      clockwise: true,
    );
    path.lineTo(bottomRight.dx, bottomRight.dy - borderRadius);
    path.arcToPoint(
      Offset(bottomRight.dx - borderRadius, bottomRight.dy),
      radius: Radius.circular(borderRadius),
      clockwise: true,
    );
    path.lineTo(bottomLeft.dx + borderRadius, bottomLeft.dy);
    path.arcToPoint(
      Offset(bottomLeft.dx, bottomLeft.dy - borderRadius),
      radius: Radius.circular(borderRadius),
      clockwise: true,
    );
    path.lineTo(topLeft.dx, topLeft.dy + borderRadius);
    path.arcToPoint(
      Offset(topLeft.dx + borderRadius, topLeft.dy),
      radius: Radius.circular(borderRadius),
      clockwise: true,
    );

    path.close();

    // Draw the shape
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}