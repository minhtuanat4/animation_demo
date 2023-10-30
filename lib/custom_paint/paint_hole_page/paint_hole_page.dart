import 'dart:math';

import 'package:flutter/material.dart';

class PaintHolePage extends StatefulWidget {
  @override
  State<PaintHolePage> createState() => _MyAppState();
}

class _MyAppState extends State<PaintHolePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            children: [
              CustomPaint(
                size: Size(
                  size.width,
                  size.height,
                ),
                painter: MyPainter(
                  size.width / 2.5,
                ),
              ),
              const Align(
                  alignment: Alignment.bottomCenter,
                  child: Image(image: AssetImage('assets/images/logo.png')))
            ],
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
    const spaceRadius = 4;
    const spaceRadiusAdditionY = spaceRadius + 10;
    const spaceRadiusAdditionX = spaceRadius - 10;
    final double centerX = size.width / 2;
    final double positionYCircle = size.height / 2.4;
    final Paint paintSmallDot = Paint()..color = Colors.black;
    final Paint paintOval = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const double filledSmallDotRadius = 3;
    const int numberOfDots = 28;
    const double radiantStep = 2 * pi / numberOfDots;
    final paintCombine = Paint();
    paintCombine.color = Colors.green;
    final pathOval = Path()
      ..addOval(Rect.fromLTRB(
        centerX - radius + spaceRadius,
        positionYCircle - radius - spaceRadius,
        centerX + radius - spaceRadius,
        positionYCircle + radius + spaceRadius,
      ));
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()
          ..addRRect(RRect.fromLTRBR(
              0, 0, size.width, size.height, const Radius.circular(0))),
        pathOval..close(),
      ),
      paintCombine,
    );

    // canvas.drawOval(Rect.fromLTRB(50, 100, 250, 200), circlePaint);
    for (int i = 0; i < numberOfDots; i++) {
      canvas.drawCircle(
        Offset(
            centerX + cos(i * radiantStep) * (radius - spaceRadiusAdditionX),
            positionYCircle +
                sin(i * radiantStep) * (radius + spaceRadiusAdditionY)),
        filledSmallDotRadius,
        paintSmallDot,
      );
    }
    canvas.drawPath(pathOval, paintOval);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
