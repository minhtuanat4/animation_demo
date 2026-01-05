import 'dart:math';
import 'dart:ui';

import 'package:animation_demo/widget/confetti/confetti.dart'
    show ConfettiController, ConfettiWidget;
import 'package:animation_demo/widget/confetti/enums/blast_directionality.dart'
    show BlastDirectionality;
import 'package:flutter/material.dart';

class SwirlingLightPainter extends CustomPainter {
  final double animationValue;

  SwirlingLightPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // A gradient that fades from the center outwards to create a light effect
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.yellow, Colors.transparent],
        stops: const [0.1, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius - 10))
      ..style = PaintingStyle.fill;

    // Apply rotation transformation
    canvas.save();
    // Rotate the canvas based on the animation value
    canvas.translate(center.dx, center.dy);
    canvas.rotate(2 * pi * animationValue);
    canvas.translate(-center.dx, -center.dy);

    // Draw the "light" shape (a simple circle here, but can be a more complex path)
    canvas.drawCircle(
        center, radius * (0.5 + 0.1 * sin(2 * pi * animationValue)), paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint on every tick
  }
}

// Source - https://stackoverflow.com/a
// Posted by Vladimir Goldobin
// Retrieved 2025-12-10, License - CC BY-SA 4.0

class LightningPainter2 extends CustomPainter {
  final Color color;
  final double thickness;
  final Random _rand = Random();

  LightningPainter2({
    this.color = Colors.white,
    this.thickness = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final mainPath = _makeLightning(
      start: Offset(size.width / 2, 0),
      end: Offset(size.width / 2, size.height),
      segments: 18,
      maxOffset: 26,
    );

    final glow = Paint()
      ..strokeWidth = thickness * 3
      ..color = color.withOpacity(0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25)
      ..style = PaintingStyle.stroke;

    final mainPaint = Paint()
      ..strokeWidth = thickness
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Draw glow first
    canvas.drawPath(mainPath, glow);

    // Draw main bolt
    canvas.drawPath(mainPath, mainPaint);

    // Draw branches
    for (int i = 0; i < 6; i++) {
      _drawBranch(canvas, size, mainPath);
    }
  }

  Path _makeLightning({
    required Offset start,
    required Offset end,
    required int segments,
    required double maxOffset,
  }) {
    Path path = Path();
    path.moveTo(start.dx, start.dy);

    for (int i = 1; i < segments; i++) {
      double t = i / segments;
      double dx = lerpDouble(start.dx, end.dx, t)! +
          (_rand.nextDouble() * maxOffset - maxOffset / 2);
      double dy = lerpDouble(start.dy, end.dy, t)!;
      path.lineTo(dx, dy);
    }

    path.lineTo(end.dx, end.dy);
    return path;
  }

  void _drawBranch(Canvas canvas, Size size, Path mainPath) {
    // Extract points from the main path
    final metrics = mainPath.computeMetrics().first;
    double length = metrics.length;
    double startOffset = _rand.nextDouble() * length * 0.7; // branch start

    Tangent? tangent = metrics.getTangentForOffset(startOffset);
    if (tangent == null) return;

    Offset start = tangent.position;
    Offset end = start +
        Offset(
          (_rand.nextDouble() * 80 - 30),
          _rand.nextDouble() * 120,
        );

    final branchPaint = Paint()
      ..strokeWidth = thickness * 0.6
      ..style = PaintingStyle.stroke
      ..color = color.withOpacity(0.65);

    Path branch = _makeLightning(
      start: start,
      end: end,
      segments: 6,
      maxOffset: 10,
    );

    canvas.drawPath(branch, branchPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ThunderBranchPainter extends CustomPainter {
  final Random rnd = Random();

  Offset jitter(Offset p, double amount) {
    return Offset(
      p.dx + (rnd.nextDouble() - 0.5) * amount,
      p.dy + (rnd.nextDouble() - 0.5) * amount,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint branchPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final Paint glowPaint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.4)
      ..strokeWidth = 6
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Starting point of lightning
    final start = Offset(size.width * 0.5, size.height * 0.15);

    // Generate branching
    drawLightningBranch(canvas, start, 12, 10, branchPaint, glowPaint);
  }

  void drawLightningBranch(
    Canvas canvas,
    Offset start,
    int segments,
    double step,
    Paint branchPaint,
    Paint glowPaint,
  ) {
    Offset current = start;
    for (int i = 0; i < segments; i++) {
      double dx = (rnd.nextDouble() - 0.5) * 30;
      double dy = step;

      Offset next = current + Offset(dx, dy);

      // Glow behind the line
      canvas.drawLine(current, next, glowPaint);

      // Main bright branch
      canvas.drawLine(current, next, branchPaint);

      current = next;

      // Small side branches
      if (rnd.nextDouble() < 0.2) {
        drawSideBranch(canvas, current, branchPaint, glowPaint);
      }
    }
  }

  void drawSideBranch(
    Canvas canvas,
    Offset start,
    Paint paint,
    Paint glow,
  ) {
    Offset mid = start + Offset((rnd.nextDouble() - 0.5) * 40, 20);
    Offset end = mid + Offset((rnd.nextDouble() - 0.5) * 20, 20);

    canvas.drawLine(start, mid, glow);
    canvas.drawLine(mid, end, glow);

    canvas.drawLine(start, mid, paint);
    canvas.drawLine(mid, end, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// class SpriteHorse extends PositionComponent {
//   SpriteHorse(Vector2 position)
//       : super(
//           position: position,
//           anchor: Anchor.topLeft,
//         );
//   static final Paint red = BasicPalette.red.paint();
//   static final Paint blue = BasicPalette.blue.paint();

//   @override
//   Future<void> onLoad() async {
//     // transform.y = -20;
//     // position. = 20;
//     position = position;
//     anchor = Anchor.topLeft;

//     super.onLoad();
//   }

//   @override
//   void render(Canvas canvas) {
//     final rect = Rect.fromLTWH(0, 0, 48, 80);
//     final matrix4 = prefix.Matrix4.identity()
//       ..setEntry(2, 2, 0.001)
//       ..rotateX(1.2);
//     canvas.transform(matrix4.storage);
//     final paint = Paint()
//       ..shader = const LinearGradient(
//         colors: [Color(0xFF00416A), Color(0xFFE4E5E6)],
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//       ).createShader(rect);
//     canvas.drawRect(rect, paint);
//   }
// }

// class SpriteHorse2 extends PositionComponent {
//   SpriteHorse2() : super();
//   static final Paint red = BasicPalette.red.paint();
//   static final Paint blue = BasicPalette.blue.paint();

//   @override
//   Future<void> onLoad() async {
//     // transform.y = -20;
//     // position. = 20;
//     anchor = Anchor.center;
//     super.onLoad();
//   }

//   @override
//   void render(Canvas canvas) {
//     final rect = Rect.fromLTWH(50, 300, 40, 50);
//     final matrix4 = prefix.Matrix4.identity()
//       ..setEntry(2, 2, 0.001)
//       ..rotateX(1);
//     // ..rotateY(-0.1);
//     canvas.transform(matrix4.storage);
//     final paint = Paint()
//       ..shader = const LinearGradient(
//         colors: [Color(0xFF00416A), Color(0xFFE4E5E6)],
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//       ).createShader(rect);
//     canvas.drawRect(rect, paint);
//   }
// }

// class SpriteHorseNormal extends PositionComponent {
//   SpriteHorseNormal(Vector2 position) : super(position: position);
//   static final Paint red = BasicPalette.red.paint();
//   static final Paint blue = BasicPalette.blue.paint();

//   @override
//   Future<void> onLoad() async {
//     // transform.y = -20;
//     // position. = 20;
//     position = position;
//     // anchor = Anchor.topLeft;
//     // add(
//     //   RectangleComponent(
//     //       anchor: Anchor.topLeft,
//     //       size: Vector2(40, 54),
//     //       paint: blue,
//     //       position: Vector2(0, 0)),
//     // );

//     super.onLoad();
//   }

//   @override
//   void render(Canvas canvas) {
//     final rect = Rect.fromLTWH(0, 0, 48, 32);

//     final paint = Paint()
//       ..shader = const LinearGradient(
//         colors: [
//           Color.fromRGBO(22, 193, 51, 1),
//           Color.fromARGB(255, 19, 13, 203)
//         ],
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//       ).createShader(rect);
//     canvas.drawRect(rect, paint);
//   }
// }

// class HorseComponent extends SpriteComponent {
//   HorseComponent(Vector2 position)
//       : super(position: position, size: Vector2(40, 54));

//   @override
//   Future<void> onLoad() async {
//     // Load the sprite sheet
//     // final image = await Flame.images.load('horse_walk.png');

//     // Assuming 8 frames in a single row
//     sprite = await Sprite.load('horse_walk.png');

//     size = size; // adjust to your desired render size
//     position = position;
//   }

//   @override
//   void render(Canvas canvas) {
//     final matrix4 = prefix.Matrix4.identity()
//       ..setEntry(3, 2, 0.001)
//       ..rotateY(1);
//     canvas.transform(matrix4.storage);
//     super.render(canvas);
//   }
// }
