import 'package:animation_demo/ball_anim.dart';
import 'package:animation_demo/ball_bottom.dart';
import 'package:animation_demo/ball_intro.dart';
import 'package:animation_demo/firework.dart';
import 'package:animation_demo/flame_main.dart';
import 'package:animation_demo/game_over.dart';
import 'package:animation_demo/hud_game.dart';
import 'package:animation_demo/ready_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(IntroGame());
}

class IntroGame extends StatefulWidget {
  const IntroGame({super.key});

  @override
  State<IntroGame> createState() => _IntroGameState();
}

class _IntroGameState extends State<IntroGame> with TickerProviderStateMixin {
  final animStatus = ValueNotifier<bool>(false);
  final reloadPosition = ValueNotifier<bool>(false);
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  Offset position = Offset.zero;
  Offset sizeBall = Offset.zero;
  late AnimationController _controller2;
  late Animation<double> _colorAnimation2;

  late AnimationController _shakeCtrol;
  late Animation<double> _shakeAnim;
  @override
  void initState() {
    super.initState();
    _shakeCtrol = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Create a curved animation for a more natural shake effect
    _shakeAnim = Tween<double>(begin: -10.0, end: 10.0)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(_shakeCtrol);
    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200), // Adjust flash speed
    );

    _colorAnimation2 = Tween<double>(
      begin: 6,
      end: 36,
    ).animate(
      CurvedAnimation(
        parent: _controller2,
        curve: Curves.easeIn, // Choose your desired curve
      ),
    );

    // _controller2.forward();
    _controller2.addListener(() {});
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Adjust flash speed
    );

    _colorAnimation = ColorTween(
      begin: Colors.white.withValues(alpha: 1),
      end: Colors.black.withValues(alpha: 0.3),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn, // Choose your desired curve
      ),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // When animation completes playing forward, reverse it
        // _controller.reverse();
        animStatus.value = false;
        _controller.reset();
      } else if (status == AnimationStatus.dismissed) {
        // When animation completes playing in reverse, play it forward again
        animStatus.value = false;
        _controller.reset();
      }
    });
    // Start flashing
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GestureDetector(
        onTap: () {
          _shakeCtrol
            ..reset()
            ..forward();
        },
        child: Scaffold(
          appBar: null,
          backgroundColor: Colors.black,
          body: Transform.translate(
            offset: Offset(0, 0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Align(
                //     alignment: Alignment.center,
                //     child: AnimatedBuilder(
                //       builder: (context, __) {
                //         return Stack(
                //           alignment: Alignment.center,
                //           children: [
                //             Transform.scale(
                //               scale: 1.8,
                //               child: CustomPaint(
                //                 size: Size(100, 100),
                //                 painter: RadialCirclePainter(),
                //               ),
                //             ),
                //             SizedBox(
                //               height: 100,
                //               width: 100,
                //               child: Image.asset(
                //                   'assets/images/event/event_tet2026/animal/ball.png'),
                //             )
                //           ],
                //         );
                //       },
                //       animation: _colorAnimation2,
                //     )),
                GameWidget<MoleGame>(
                  game: MoleGame(
                    onBallTapped: (p0, size) {
                      reloadPosition.value = !reloadPosition.value;
                      position = Offset(p0.x, p0.y);
                      sizeBall = Offset(size.x, p0.y);

                      animStatus.value = true;

                      _controller.forward();
                    },
                    onBallExist: () {},
                    hasSecret: true,
                    totalTimePlay: 60,
                  ),
                  overlayBuilderMap: {
                    'BallAnim': (_, game) => BallAnim(
                          game: game,
                          score: 200,
                        ),
                    'GameOver': (_, game) => GameOver(game: game),
                    'Firework': (_, game) => Firework(
                          game: game,
                        ),
                    'HUDGame': (_, game) => HUDGame(
                          game: game,
                          time: 60,
                        ),
                    'ReadyGame': (_, game) => ReadyGame(
                          game: game,
                        ),
                    'BallIntro': (_, game) => BallIntro(
                          game: game,
                        ),
                    'BallBottom': (_, game) => BallBottom(
                          game: game,
                        ),
                  },
                  // initialActiveOverlays: const ['MainMenu'],
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: animStatus,
                  builder: (context, value, __) {
                    return value
                        ? Positioned.fill(
                            child: AnimatedBuilder(
                            builder: (context, child) {
                              return Stack(
                                children: [
                                  Container(
                                    color: _colorAnimation.value,
                                  ),
                                  child ?? const SizedBox(),
                                ],
                              );
                            },
                            // child: Container(
                            //   margin: EdgeInsets.only(
                            //       top: position.y, left: position.x),
                            //   child: SizedBox(
                            //       height: 64,
                            //       width: 64,
                            //       child:
                            //           Image.asset('assets/images/event/ball.png')),
                            // ),
                            animation: _controller,
                          ))
                        : const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
