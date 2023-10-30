import 'dart:math';

import 'package:flutter/material.dart';

class PaintHolePage extends StatefulWidget {
  @override
  State<PaintHolePage> createState() => _MyAppState();
}

class _MyAppState extends State<PaintHolePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: CustomPaint(
          size: const Size(
            100,
            100,
          ),
          painter: MyPainter(
            20,
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  MyPainter(this.radius);

  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final Paint paint = Paint()..color = Colors.black;
    final double filledCircleRadius = 3;
    final int numberOfDots = 10;
    final double radiantStep = 2 * pi / numberOfDots;
    for (int i = 0; i < numberOfDots; i++) {
      canvas.drawCircle(
        Offset(centerX + sin(i * radiantStep) * radius,
            centerY + cos(i * radiantStep) * radius),
        filledCircleRadius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
