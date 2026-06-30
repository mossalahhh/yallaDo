import 'package:flutter/material.dart';

class BubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xfff5efd6)
      ..style = PaintingStyle.fill;

    final radius = 16.0;
    final bool showButton;

    final rect = RRect.fromLTRBR(0, 0, size.width - 20, size.height, Radius.circular(radius));
    canvas.drawRRect(rect, paint);
    final path = Path();
    final arrowHeight = 20.0;
    final arrowWidth = 25.0;
    path.moveTo(size.width - 20, size.height - 30);
    path.lineTo(size.width - 0, size.height);
    path.lineTo(size.width - 20, size.height - 10);
    path.close();

    canvas.drawPath(path, paint);

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.0)
      ..maskFilter =  MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawRRect(rect, shadowPaint);
    canvas.drawPath(path, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

}