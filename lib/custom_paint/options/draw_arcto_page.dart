import 'dart:math';

import 'package:flutter/material.dart';

class DrawArcToPage extends StatelessWidget {
  const DrawArcToPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DrawArcToPage')),
      body: SizedBox.expand(
          child: Center(
        child: CustomPaint(
          painter: DrawArcTo(),
          child: SizedBox(
            // child: ColoredBox(color: Colors.green),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
          ),
        ),
      )),
    );
  }
}

class DrawArcTo extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;
    Path path = Path();
    path.moveTo(0, size.height / 2);
    path.arcTo(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: size.width,
            height: size.height),
        0,
        pi,
        true);
    path.lineTo(0, -1000);
    path.lineTo(size.width, -1000);
    path.close();
    // path.addRect(
    //   Rect.fromCenter(
    //       center: Offset(size.width / 2, size.height / 2),
    //       width: size.width,
    //       height: size.height),
    // );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  // @override
  // getClip(Size size) {
  //   Paint paint = Paint()
  //     ..color = Colors.red
  //     ..style = PaintingStyle.stroke
  //     ..strokeWidth = 8.0;
  //   Path path = Path();
  //   path.moveTo(0, size.height / 2);
  //   path.arcTo(
  //       Rect.fromCenter(
  //           center: Offset(size.width / 2, size.height / 2),
  //           width: size.width,
  //           height: size.height),
  //       0,
  //       pi,
  //       true);
  //   path.lineTo(0, -1000);
  //   path.lineTo(size.width, -1000);
  //   path.close();
  //   // path.addRect(
  //   //   Rect.fromCenter(
  //   //       center: Offset(size.width / 2, size.height / 2),
  //   //       width: size.width,
  //   //       height: size.height),
  //   // );
  //   return path;
  // }

  // @override
  // bool shouldReclip(covariant CustomClipper oldClipper) {
  //   return false;
  // }
}
