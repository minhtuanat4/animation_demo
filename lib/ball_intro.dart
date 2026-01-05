import 'dart:async';
import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:animation_demo/flame_main.dart';
import 'package:flutter/material.dart';

class BallIntro extends StatefulWidget {
  // Reference to parent game.
  final MoleGame game;
  const BallIntro({super.key, required this.game});

  @override
  State<BallIntro> createState() => _BallIntroState();
}

class _BallIntroState extends State<BallIntro>
    with TickerProviderStateMixin, AfterLayoutMixin {
  late AnimationController ctrol;
  late Animation<double> ballAnim;
  late Animation<double> shadowSizeAnim;

  late AnimationController ctrolText;
  late Animation<double> aniText;

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {}

  Offset sizeBall = Offset(0, 0);

  double padding = 800;

  final bgNotify = ValueNotifier<bool>(false);

  @override
  void initState() {
    ctrolText =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    aniText = Tween<double>(begin: 0.1, end: 1).animate(ctrolText);
    sizeBall = Offset(widget.game.size.x / (ratioSizeChau + 0.3),
        widget.game.size.x / (ratioSizeChau + 0.3));

    ctrol = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1400));
    ballAnim = Tween<double>(begin: 0, end: -padding).animate(
      CurvedAnimation(
        parent: ctrol,
        curve: Curves.bounceOut,
      ),
    );
    shadowSizeAnim = Tween<double>(begin: 0.5, end: 1.3).animate(
      CurvedAnimation(
        parent: ctrol,
        curve: Curves.bounceOut,
      ),
    );

    ctrol.forward();
    ctrol.addListener(() {
      if (ballAnim.isCompleted) {
        bgNotify.value = true;
      }
    });
    bgNotify.addListener(() {
      Future.delayed(Duration(milliseconds: 800), () {
        widget.game.overlays.remove('BallIntro');
        widget.game.overlays.add('ReadyGame');
      });
    });
    ctrolText.forward();
    super.initState();
  }

  @override
  void dispose() {
    ctrol.dispose();
    ctrolText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final angle = pi / 3; // Rotate by PI (180 degrees)
    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.001) // Perspective
      ..rotateX(angle);
    return Material(
      color: Colors.black87,
      child: Container(
        // margin: EdgeInsets.only(bottom: 100),
        width: widget.game.size.x,
        height: widget.game.size.y,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: widget.game.size.y / 2 + sizeBall.dx / 3 - 20,
              left: 12,
              right: 12,
              child: Column(
                children: [
                  ValueListenableBuilder(
                    valueListenable: bgNotify,
                    builder: (context, __, _) {
                      return Transform(
                        transform: transform,
                        child: AnimatedBuilder(
                          builder: (context, __) {
                            return bgNotify.value
                                ? const SizedBox()
                                : Transform.scale(
                                    scale: shadowSizeAnim.value,
                                    child: CustomPaint(
                                      size: Size(
                                        sizeBall.dx,
                                        sizeBall.dx,
                                      ),
                                      painter: RadialCirclePainter2(),
                                    ),
                                  );
                          },
                          animation: shadowSizeAnim,
                        ),
                      );
                    },
                  ),
                  ValueListenableBuilder(
                      valueListenable: bgNotify,
                      builder: (context, __, _) {
                        return SizedBox(
                          height: bgNotify.value ? 48 : 0,
                        );
                      }),
                  AnimatedBuilder(
                      animation: aniText,
                      builder: (context, value) {
                        return Transform.scale(
                          scale: aniText.value,
                          child: Text(
                            textBallIntro,
                            style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 28,
                              fontFamily: fontGame,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      })
                ],
              ),
            ),
            AnimatedBuilder(
              builder: (context, __) {
                return Container(
                  margin:
                      EdgeInsets.only(bottom: ballAnim.value + padding + 30),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: sizeBall.dx,
                        width: sizeBall.dx,
                        child: Image.asset(
                            'assets/images/event/event_tet2026/animal/ball.png'),
                      ),
                      ValueListenableBuilder(
                          valueListenable: bgNotify,
                          builder: (context, __, _) {
                            return bgNotify.value
                                ? Transform.scale(
                                    scale: 1.25,
                                    child: CustomPaint(
                                      size: Size(
                                        sizeBall.dx,
                                        sizeBall.dx,
                                      ),
                                      painter: RadialCirclePainter(),
                                    ),
                                  )
                                : const SizedBox();
                          }),
                    ],
                  ),
                );
              },
              animation: ballAnim,
            ),
          ],
        ),
      ),
    );
  }
}

class RadialCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1,
        colors: [
          Colors.white24,
          Colors.white,
        ],
        stops: const [0.35, 0.5],
      ).createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RadialCirclePainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.8,
        colors: [
          Colors.transparent,
          Colors.white,
        ],
        stops: const [0, 0.56],
      ).createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
