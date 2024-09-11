import 'package:flutter/material.dart';

class CardPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.blue;

    Path path = Path()
      ..lineTo(size.width * .7, 0)
      ..lineTo(size.width * .6, size.height * .6)
      ..lineTo(size.width * .8, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}