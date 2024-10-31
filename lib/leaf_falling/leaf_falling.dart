import 'dart:async';
import 'dart:math';

import 'package:animation_demo/getx_demo/common/custom/epos_popup.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

// Container(
//         height: 400,
//         width: MediaQuery.sizeOf(context).width,
//         child: GameWidget(game: MainUI()),
//       ),
int isWind = 0;
double speedWind = 100;

class MainUI extends FlameGame {
  MainUI();
  final world = World();
  late LeafManagement leafManagement;

  final imageAssets = [
    'lixi.png',
    'canh_hoa_4.png',
    'canh_hoa_5.png',
    'canh_hoa_6.png',
    'canh_hoa_7.png',
    'canh_hoa_8.png',
  ];
  @override
  Future<FutureOr<void>> onLoad() async {
    await super.onLoad();
    await images.loadAll(imageAssets);
    addAll([
      world,
      CameraComponent.withFixedResolution(
        world: world,
        width: 1080,
        height: 1920,
      )
    ]);
    leafManagement = LeafManagement();
  }

  @override
  void onMount() {
    add(leafManagement);
    // add(LeafItem());
    super.onMount();
  }
}

class LeafManagement extends PositionComponent {
  Timer interval = Timer(1, repeat: true);
  int countLeaf = Random().nextInt(4);
  @override
  FutureOr<void> onLoad() {
    interval
      ..start()
      ..onTick = spawnFallingLeaf;
    return super.onLoad();
  }

  void spawnFallingLeaf() {
    interval.limit = Random().nextDouble() * 5;
    countLeaf = Random().nextInt(5);
    for (var i = 0; i < countLeaf; i++) {
      add(LeafItem());
    }
  }

  @override
  void onRemove() {
    interval
      ..pause()
      ..stop();
    super.onRemove();
  }

  @override
  void update(double dt) {
    interval.update(dt);
    super.update(dt);
  }
}

class LeafItem extends SpriteComponent with HasGameRef {
  double positionX = Random().nextDouble();
  double speed = 28;

  Timer interval = Timer(5);

  final random = Random().nextInt(4) + 4;

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
    sprite = Sprite(gameRef.images.fromCache('canh_hoa_$random.png'));
    position.x = positionX * gameRef.size.x;
    // size = Vector2(24, 16);
    scale = random == 6 ? Vector2(0.08, 0.08) : Vector2(0.18, 0.18);
    position.y = -50;
    interval.onTick = () {
      removeFromParent();
    };
    return super.onLoad();
  }

  @override
  void onRemove() {
    interval
      ..pause()
      ..stop();
    super.onRemove();
  }

  @override
  void update(double dt) {
    if (position.y >= positionLand) {
      interval.update(dt);
      opacity = (opacity - dt * 0.2).clamp(0, 1);
      return;
    }

    position.y += (Random().nextDouble()) * dt + dt * speed;
    if (position.x < -40 || position.x > gameRef.size.x + 40) {
      removeFromParent();
    }
    if (speedWind > 0) {
      speedWind -= dt * (speedWind / 16);
      if (isWind == 2) {
        position.x += dt * speedWind;
      } else if (isWind == 1) {
        position.x -= dt * speedWind;
      }
    } else {
      speedWind = 0;
    }

    // print(position.y);
    super.update(dt);
  }
}

const double positionLand = 400;

class LoginFirebasePage2 extends StatefulWidget {
  const LoginFirebasePage2({super.key});

  @override
  State<LoginFirebasePage2> createState() => _LoginFirebasePage2State();
}

class _LoginFirebasePage2State extends State<LoginFirebasePage2>
    with EposPopup, TickerProviderStateMixin {
  @override
  void dispose() {
    controllerRotateRopeOne.dispose();
    controllerLantern.dispose();
    controllerRotateRopeSecond.dispose();
    super.dispose();
  }

  late AnimationController controllerRotateRopeOne;
  late Animation<num> animationRotateRopeOne;

  late AnimationController controllerRotateRopeSecond;
  late Animation<num> animationRotateRopeSecond;

  late AnimationController controllerLantern;
  late Animation<Offset> animationLantern;

  bool isDrop = false;

  @override
  void initState() {
    controllerRotateRopeOne = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animationRotateRopeOne = Tween<num>(begin: -pi / 20, end: pi / 21)
        .animate(controllerRotateRopeOne);
    controllerRotateRopeSecond = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animationRotateRopeSecond = Tween<num>(begin: -pi / 8, end: pi / 9)
        .animate(controllerRotateRopeSecond);
    controllerLantern =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    animationLantern =
        Tween<Offset>(begin: Offset(-25, -10), end: Offset(20, 5))
            .animate(controllerLantern);
    controllerLantern
      ..forward()
      ..repeat(reverse: true);
    controllerRotateRopeSecond
      ..forward()
      ..repeat(reverse: true);
    controllerRotateRopeOne
      ..forward()
      ..repeat(reverse: true);
    super.initState();
  }

  Offset offsetChange = Offset(0, 0);

  final double heightRopeOne = 24.0;

  final double heightRopeSecond = 30.0;

  final double heightTailLantern = 12.0;

  int conicPointOne = 6;
  int conicPointSecond = 9;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        color: Colors.blueGrey,
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(48.0),
        child: SizedBox(
          width: 50,
          height: 122,
          child: AnimatedBuilder(
            builder: (context, valueRotate) {
              return Column(
                children: [
                  CustomPaint(
                    size: Size(50, heightRopeOne),
                    painter: PathPainterLineOne(
                      tan(animationRotateRopeOne.value) *
                          (heightRopeOne - heightRopeOne / conicPointOne),
                      conicPointOne,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(
                        tan(animationRotateRopeOne.value) *
                            (heightRopeOne - heightRopeOne / conicPointOne),
                        -5),
                    child: AnimatedBuilder(
                      builder: (context, value) {
                        return Transform(
                          alignment: Alignment.topCenter,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateX(animationLantern.value.dy * pi / 270)
                            ..rotateZ(-animationRotateRopeOne.value.toDouble() *
                                pi /
                                3)
                            ..rotateY(animationLantern.value.dx * pi / 270),
                          child: Container(
                            child: Column(
                              // alignment: Alignment.topCenter,
                              children: [
                                Container(
                                  // height: 50,
                                  // width: 50,
                                  child: Image(
                                    image:
                                        AssetImage('assets/images/denlong.png'),
                                  ),
                                ),
                                AnimatedBuilder(
                                  builder: (context, valueRotate) {
                                    return Column(
                                      children: [
                                        CustomPaint(
                                          size: Size(80, heightRopeSecond),
                                          painter: PathPainterLineSecond(
                                            tan(animationRotateRopeSecond
                                                    .value) *
                                                (heightRopeSecond -
                                                    heightRopeSecond /
                                                        conicPointSecond),
                                            conicPointSecond,
                                          ),
                                        ),
                                        Transform.rotate(
                                          angle: -animationRotateRopeSecond
                                              .value
                                              .toDouble(),
                                          alignment: Alignment.topCenter,
                                          child: Transform.translate(
                                            offset: Offset(
                                                tan(animationRotateRopeSecond
                                                        .value) *
                                                    (heightRopeSecond -
                                                        heightRopeSecond /
                                                            conicPointSecond),
                                                -2),
                                            child: Container(
                                              alignment: Alignment.topCenter,
                                              height: heightTailLantern,
                                              width: heightTailLantern,
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/images/day-denlong.png'),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                  animation: animationRotateRopeSecond,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      animation: animationLantern,
                    ),
                  ),
                ],
              );
            },
            animation: animationRotateRopeOne,
          ),
        ),
      ),
    );
  }
}

class PathPainterLineOne extends CustomPainter {
  final double valueAnimation;
  final int conicPoint;
  PathPainterLineOne(this.valueAnimation, this.conicPoint);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.conicTo(size.width / 2, size.height / conicPoint,
        size.width / 2 + valueAnimation, size.height, 2);
    // path.cubicTo(size.width / 2, 3 * size.height / 4, 3 * size.width / 4,
    //     size.height / 4, size.width, size.height);
    canvas.drawPath(path, paint);
  }
}

class PathPainterLineSecond extends CustomPainter {
  final double valueAnimation;
  final int conicPoint;
  PathPainterLineSecond(this.valueAnimation, this.conicPoint);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.conicTo(size.width / 2, size.height / conicPoint,
        size.width / 2 + valueAnimation, size.height, 2);
    // path.cubicTo(size.width / 2, 3 * size.height / 4, 3 * size.width / 4,
    //     size.height / 4, size.width, size.height);
    canvas.drawPath(path, paint);
  }
}

class PathPainter extends CustomPainter {
  Path path;
  PathPainter({required this.path});

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    // paint the line
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(path, paint);
  }
}
