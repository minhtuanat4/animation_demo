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
    with EposPopup {
  bool isDrop = false;

  @override
  void initState() {
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
          height: MediaQuery.sizeOf(context).height,
          color: Colors.blueGrey,
          child: Stack(
            children: [
              SizedBox(
                height: 120,
              ),
              // Row(
              //   children: [
              //     SizedBox(
              //       height: 180,
              //       child: LanternWidget(),
              //     ),
              //     SizedBox(
              //       height: 80,
              //       child: LanternWidget(),
              //     ),
              //   ],
              // ),
              Container(
                margin: EdgeInsets.only(top: 100),
                child: CustomPaint(
                  size: Size(MediaQuery.sizeOf(context).width, 50),
                  painter: CurveLinePath(50, 3),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: 50, left: MediaQuery.sizeOf(context).width / 2),
                child: CustomPaint(
                  size: Size(100, 50),
                  painter: CurveLinePath2(50, 3),
                ),
              ),
              Positioned(
                top: 100,
                left: MediaQuery.sizeOf(context).width / 2 - 25,
                child: Container(
                  // color: Colors.amber,
                  height: 100,
                  child: LanternWidget(),
                ),
              ),
              Positioned(
                top: 100 + 25,
                left: MediaQuery.sizeOf(context).width / 2 - 100,
                child: Container(
                  // color: Colors.amber,
                  height: 130,
                  child: LanternWidget(),
                ),
              ),
            ],
          )),
    );
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

class LanternWidget extends StatefulWidget {
  const LanternWidget({super.key});

  @override
  State<LanternWidget> createState() => _LanternWidgetState();
}

class _LanternWidgetState extends State<LanternWidget>
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

  final timeRotate = Random().nextInt(500) + 1000;

  final rotateRope = Random().nextInt(6) + 19;

  final rotateZ = Random().nextInt(3) + 4;

  @override
  void initState() {
    controllerRotateRopeOne = AnimationController(
        vsync: this, duration: Duration(milliseconds: timeRotate));
    animationRotateRopeOne =
        Tween<num>(begin: -pi / rotateRope, end: pi / (rotateRope + 1))
            .animate(controllerRotateRopeOne);
    controllerRotateRopeSecond = AnimationController(
        vsync: this, duration: Duration(milliseconds: timeRotate));
    animationRotateRopeSecond =
        Tween<num>(begin: -pi / (rotateRope - 6), end: pi / (rotateRope - 5))
            .animate(controllerRotateRopeSecond);
    controllerLantern = AnimationController(
        vsync: this, duration: Duration(milliseconds: timeRotate + 500));
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

  final double ropeOnePortionHeight = 0.18;

  final double ropeTwoPortionHeight = 0.24;

  final double tailLanternPortionHeight = 0.08;

  final double lanternPortionHeight = 0.5;

  double heightRopeOne = 0;

  double heightRopeSecond = 0;

  double heightTailLantern = 0;

  double heightLantern = 0;

  int conicPointOne = 6;

  int conicPointSecond = 6;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      final width = 10.0;

      heightRopeOne = ropeOnePortionHeight * constraint.maxHeight;
      heightRopeSecond = ropeTwoPortionHeight * constraint.maxHeight;
      heightTailLantern = tailLanternPortionHeight * constraint.maxHeight;
      heightLantern = lanternPortionHeight * constraint.maxHeight;
      return AnimatedBuilder(
        builder: (context, valueRotate) {
          return Column(
            children: [
              CustomPaint(
                size: Size(width, heightRopeOne),
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
                            rotateZ)
                        ..rotateY(animationLantern.value.dx * pi / 270),
                      child: Column(
                        children: [
                          SizedBox(
                            height: heightLantern,
                            child: Image(
                              fit: BoxFit.fitHeight,
                              image: AssetImage(
                                'assets/images/denlong.png',
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset: Offset(0, -2),
                            child: AnimatedBuilder(
                              builder: (context, valueRotate) {
                                return Column(
                                  children: [
                                    CustomPaint(
                                      size: Size(width, heightRopeSecond),
                                      painter: PathPainterLineSecond(
                                        tan(animationRotateRopeSecond.value) *
                                            (heightRopeSecond -
                                                heightRopeSecond /
                                                    conicPointSecond),
                                        conicPointSecond,
                                      ),
                                    ),
                                    Transform.rotate(
                                      angle: -animationRotateRopeSecond.value
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
                          ),
                        ],
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
      );
    });
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
      ..strokeWidth = 2.0;

    Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.conicTo(size.width / 2, size.height / conicPoint,
        size.width / 2 + valueAnimation, size.height, 2);
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
      ..strokeWidth = 2.0;

    Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.conicTo(size.width / 2, size.height / conicPoint,
        size.width / 2 + valueAnimation, size.height, 2);
    canvas.drawPath(path, paint);
  }
}

class CurveLinePath extends CustomPainter {
  final double height;
  final int conicPoint;
  CurveLinePath(this.height, this.conicPoint);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    Path path = Path();
    path.moveTo(0, height);

    path.conicTo(
        size.width / 2 / 3 * 2, height, size.width / 2, size.height - 50, 1);
    canvas.drawPath(path, paint);
  }
}

class CurveLinePath2 extends CustomPainter {
  final double height;
  final int conicPoint;
  CurveLinePath2(this.height, this.conicPoint);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    Path path = Path();
    path.moveTo(0, height);

    path.conicTo(size.width / 2, height, size.width / 2 + size.width / 3,
        size.height - 50, 1);
    canvas.drawPath(path, paint);
  }
}
