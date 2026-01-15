import 'dart:async';
import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:animation_demo/flame_main.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

const durationParam = 3000;

class ShakeCurve extends Curve {
  const ShakeCurve();

  @override
  double transformInternal(double t) {
    // Simulate a spring-like shake
    return -1 * sin(t * 4 * 3.14) * exp(t * 2);
  }
}

class BallAnim extends StatefulWidget {
  // Reference to parent game.
  final MoleGame game;
  final int score;

  const BallAnim({super.key, required this.game, required this.score});

  @override
  State<BallAnim> createState() => _BallAnimState();
}

class _BallAnimState extends State<BallAnim>
    with TickerProviderStateMixin, AfterLayoutMixin {
  // late AnimationController _translateCtrol;
  // late Animation<Offset> _translateAnimation;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  // final _confettiController = ConfettiController(
  //   duration: durationFirework,
  // );

  // late AnimationController _lightAnimation;

  late AnimationController _zController;
  late Animation<double> _zAnimation;

  int countShake = 0;

  @override
  void initState() {
    // _translateCtrol = AnimationController(
    //   vsync: this,
    //   duration:
    //       const Duration(milliseconds: durationParam), // Adjust flash speed
    // );
    // _translateAnimation = Tween<Offset>(
    //         begin:
    //             Offset(widget.game.ballPosition.x, widget.game.ballPosition.y),
    //         end: Offset(widget.game.size.x / 2 - widget.game.ballSize.x / 2,
    //             widget.game.size.y / 2 - widget.game.ballSize.y / 2))
    //     .animate(_translateCtrol);

    _shakeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 140),
    );

    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _shakeController,
        curve: const ShakeCurve(), // Custom curve for a realistic shake
      ),
    );
    _shakeController.addListener(() {
      if (countShake >= 4) {
        // _shakeController.
        widget.game.addScore(widget.score);
        widget.game.overlays.add('Firework');

        widget.game.myWorld.isBallTapped = false;
        widget.game.overlays.remove('BallAnim');
        widget.game.ballNotify.value = 1;
        Future.delayed(Duration(milliseconds: 1400), () {
          widget.game.myWorld.resumeTimer();
        });
        return;
      }
      if (_shakeAnimation.isCompleted) {
        _shakeController.reverse();
        print('_shakeAnimation1');
      } else if (_shakeAnimation.isDismissed) {
        countShake++;
        _shakeController.forward();
        print('_shakeAnimation2');
      }
    });

    // _lightAnimation = AnimationController(
    //   duration: const Duration(milliseconds: 3000), // Adjust the duration
    //   vsync: this,
    // )..repeat();

    _zController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Animate from 0 (initial position) to 100 (translated Z position)
    _zAnimation = Tween<double>(begin: 0.0, end: 11.0).animate(
      CurvedAnimation(
        parent: _zController,
        curve: Curves.linear,
      ),
    );

    // _translateCtrol.forward();
    _zController.repeat(reverse: true);
    _shakeController.forward();
    FlameAudio.play('ball2.wav', volume: 1.7);
    widget.game.myWorld.pauseResetTimer();
    super.initState();
  }

  @override
  void dispose() {
    // _translateCtrol.dispose();
    _shakeController.dispose();
    // _lightAnimation.dispose();
    _zController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black38,
      child: Container(
        width: widget.game.size.x,
        height: widget.game.size.y,
        child: Stack(
          children: [
            Positioned(
              // widget.game.ballPosition.x, widget.game.ballPosition.y
              left: widget.game.ballPosition.x,
              top: widget.game.ballPosition.y,
              child: Stack(
                children: [
                  Transform.scale(
                    scale: 4,
                    child: Container(
                      child: AnimatedBuilder(
                          animation: _zController,
                          builder: (context, child) {
                            final angle = _zAnimation.value *
                                3.14159; // Rotate by PI (180 degrees)
                            final transform = Matrix4.identity()
                              ..setEntry(3, 2, 0.001) // Perspective
                              ..rotateY(angle);
                            return Transform(
                              alignment: Alignment.center,
                              transform: transform,
                              child: SizedBox(
                                height: widget.game.ballSize.y,
                                width: widget.game.ballSize.x + 4,
                                child: Image.asset(
                                    'assets/images/event/event_tet2026/animal/bling_2.png'),
                              ),
                            );
                          }),
                    ),
                  ),
                  Stack(
                    children: [
                      Transform.scale(
                        scale: 1.1,
                        child: CustomPaint(
                          size: Size(
                              widget.game.ballSize.x, widget.game.ballSize.y),
                          painter: RadialCirclePainter(),
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _shakeController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                              _shakeAnimation.value *
                                  Random().nextDouble() *
                                  (2 * (_shakeController.value - 0.5))
                                      .abs(), // Simulate left-right movement
                              _shakeAnimation.value *
                                  Random().nextDouble() *
                                  (2 * (_shakeController.value - 0.5)).abs(),
                            ),
                            child: child,
                          );
                        },
                        child: SizedBox(
                          height: widget.game.ballSize.y,
                          width: widget.game.ballSize.x,
                          child: Image.asset(
                              'assets/images/event/event_tet2026/animal/ball.png'),
                        ),
                      ),
                    ],
                  ),
                  // Transform.scale(
                  //   scale: 4,
                  //   child: Container(
                  //     child: AnimatedBuilder(
                  //         animation: _zController,
                  //         builder: (context, child) {
                  //           final angle = _zAnimation.value *
                  //               3.14159; // Rotate by PI (180 degrees)
                  //           final transform = Matrix4.identity()
                  //             ..setEntry(3, 2, 0.001) // Perspective
                  //             ..rotateY(angle);
                  //           return Transform(
                  //             alignment: Alignment.center,
                  //             transform: transform,
                  //             child: SizedBox(
                  //               height: widget.game.ballSize.y + 8,
                  //               width: widget.game.ballSize.x,
                  //               child: Image.asset(
                  //                   'assets/images/event/event_tet2026/effect/glow.png'),
                  //             ),
                  //           );
                  //         }),
                  //   ),
                  // ),
                ],
              ),

              //  ShakeWidget(
              //   duration: Duration(milliseconds: 200),
              //   child: SizedBox(
              //     height: widget.game.ballSize.y,
              //     width: widget.game.ballSize.x,
              //     child: Image.asset('assets/images/event/ball.png'),
              //   ),
              // ),
            ),

            // Transform.scale(
            //   scale: 2,
            //   child: AnimatedBuilder(
            //       animation: _zController,
            //       builder: (context, child) {
            //         final angle = _zAnimation.value *
            //             3.14159; // Rotate by PI (180 degrees)
            //         final transform = Matrix4.identity()
            //           ..setEntry(3, 2, 0.001) // Perspective
            //           ..rotateX(angle);
            //         return Transform.rotate(
            //           // transform: transform,
            //           alignment: Alignment.center,
            //           angle: angle,
            //           child: SizedBox(
            //             height: widget.game.ballSize.y,
            //             width: widget.game.ballSize.x,
            //             child: Image.asset(
            //                 'assets/images/event/thunder_storm.png'),
            //           ),
            //         );
            //       }),
            // )
          ],
        ),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {}
}

class RadialCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 3);
    final radius = size.width / 2;

    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1,
        colors: const [
          Colors.white,
          Colors.transparent,
        ],
        stops: const [0.3, 0.53],
      ).createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
