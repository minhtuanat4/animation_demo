import 'dart:async';
import 'dart:math';

import 'package:animation_demo/getx_demo/common/custom/epos_popup.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

int isWind = 0;
double speedWind = 100;

class LeafFallingUI extends FlameGame {
  LeafFallingUI();
  final world = World();
  late LeafManagement leafManagement;
  @override
  Color backgroundColor() {
    return Colors.transparent;
  }

  final imageAssets = [
    'event_2024/hoamai.png',
    'event_2024/hoadao.png',
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
    countLeaf = Random().nextInt(8);
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

Map<int, Anchor> mapAnchor = {
  0: Anchor.center,
  1: Anchor.topCenter,
  2: Anchor.topLeft,
  3: Anchor.topRight
};
const double fallFlowerExistTime = 24;

class LeafItem extends SpriteComponent with HasGameRef {
  double positionX = Random().nextDouble();
  double speed = 32;

  Timer interval = Timer(fallFlowerExistTime);

  final random = Random().nextInt(4);
  final double randomPositionY = Random().nextInt(100) + 60;
  double rotateSpeed = 2;

  @override
  FutureOr<void> onLoad() {
    anchor = mapAnchor[random]!;
    sprite = Sprite(gameRef.images.fromCache('event_2024/hoamai.png'));
    position.x = positionX * gameRef.size.x;
    size = random % 2 == 0 ? Vector2(8, 8) : Vector2(6, 6);

    position.y = randomPositionY;
    interval.onTick = () {
      removeFromParent();
    };
    interval.current;
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
    if (position.y >= (gameRef.size.y - 10)) {
      interval.update(dt);

      if (interval.current > (fallFlowerExistTime - 3)) {
        opacity = (opacity - dt * 0.5).clamp(0, 1);
      }

      return;
    }

    angle += rotateSpeed * dt;

    position.y += (Random().nextDouble()) * dt + dt * speed;
    if (position.x < -40 || position.x > gameRef.size.x + 40) {
      removeFromParent();
    }
    // if (speedWind > 0) {
    //   speedWind -= dt * (speedWind / 16);
    //   if (isWind == 2) {
    //     position.x += dt * speedWind;
    //   } else if (isWind == 1) {
    //     position.x -= dt * speedWind;
    //   }
    // } else {
    //   speedWind = 0;
    // }

    super.update(dt);
  }
}

class LoginFirebasePage2 extends StatefulWidget {
  const LoginFirebasePage2({super.key});

  @override
  State<LoginFirebasePage2> createState() => _LoginFirebasePage2State();
}

class _LoginFirebasePage2State extends State<LoginFirebasePage2>
    with EposPopup, WidgetsBindingObserver {
  bool isDrop = false;
  Size getSizes(GlobalKey key) {
    try {
      final renderBoxRed = key.currentContext!.findRenderObject() as RenderBox;
      final sizeRed = renderBoxRed.size;
      return sizeRed;
    } catch (e) {
      return Size.zero;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((a) {
      Future.delayed(Duration(milliseconds: 50), () {
        final renderBoxRed =
            keyFlower.currentContext!.findRenderObject() as RenderBox;
        sizeFlower = renderBoxRed.size;

        final x1 = 98 / 430 * sizeFlower.width;
        final y1 = 205 / 495 * sizeFlower.height;
        final x2 = 40 / 430 * sizeFlower.width;
        final y2 = 80 / 495 * sizeFlower.height;
        final x3 = 45 / 430 * sizeFlower.width;
        final y3 = 143 / 495 * sizeFlower.height;
        final x4 = 58 / 430 * sizeFlower.width;
        final y4 = 317 / 495 * sizeFlower.height;
        final x5 = 97 / 430 * sizeFlower.width;
        final y5 = 325 / 495 * sizeFlower.height;
        setState(() {
          position1 = Size(x1, y1);
          position2 = Size(x2, y2);
          position3 = Size(x3, y3);
          position4 = Size(x4, y4);
          position5 = Size(x5, y5);
        });
      });
    });

    super.initState();
  }

  final keyFlower = GlobalKey();

  Offset offsetChange = Offset(0, 0);

  final double heightRopeOne = 24.0;

  final double heightRopeSecond = 30.0;

  final double heightTailLantern = 12.0;

  int conicPointOne = 6;
  int conicPointSecond = 9;

  double paddingTop = 320;
  final x = 430;
  final y = 495;
  Size sizeFlower = Size.zero;

  Size position1 = Size.zero;
  Size position2 = Size.zero;
  Size position3 = Size.zero;
  Size position4 = Size.zero;
  Size position5 = Size.zero;

  double heightFlower = 0;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    heightFlower = height / 1.8;
    return Scaffold(
      appBar: null,
      body: Container(
          child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image(
              image: AssetImage('assets/images/event_2024/bg-mai-dem.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            right: 0,
            left: 0,
            height: height / 4.3,
            child: SafeArea(
              child: Container(
                child: Image(
                  image: AssetImage('assets/images/event_2024/logo.png'),
                ),
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.center,
          //   child: Container(
          //     margin: EdgeInsets.only(top: sizeFlower.height / 2),
          //     height: sizeFlower.height / 2,
          //     width: sizeFlower.width,
          //     child: GameWidget(
          //       game: MainUI(),
          //     ),
          //   ),
          // ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(top: sizeFlower.height + height / 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: height / 23,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/event_2024/soluot.png'),
                            fit: BoxFit.fitHeight)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text.rich(TextSpan(children: [
                          TextSpan(
                            text: 'Số lượt:  ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: '123456',
                            style: TextStyle(
                              color: Colors.yellow.shade700,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ])),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    '''(Lắc điện thoại để hái lì xì)''',
                    style: TextStyle(
                      color: Colors.yellow.shade900,
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              // color: Colors.red,
              height: heightFlower,
              child: Stack(children: [
                Positioned(
                  top: position5.height,
                  left: position5.width - 60 / 4,
                  child: Container(
                    height: 60,
                    child: LongLanternWidget(opacity: 0.6),
                  ),
                ),
                Container(
                  // color: Colors.red,
                  child: Image(
                    // height: heightFlower,
                    // width: double.infinity,
                    key: keyFlower,
                    // fit: BoxFit.fitHeight,
                    image:
                        AssetImage('assets/images/event_2024/hoa_mai_dem.png'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 24, right: 24),
                  height: sizeFlower.height,
                  width: sizeFlower.width,
                  child: GameWidget(
                    game: LeafFallingUI(),
                  ),
                ),
                Positioned(
                  top: position1.height,
                  left: position1.width - 30,
                  child: Container(
                    height: 120,
                    child: LanternWidget(),
                  ),
                ),
                Positioned(
                  top: position2.height,
                  left: position2.width - 25,
                  child: Container(
                    height: 100,
                    child: LanternWidget(),
                  ),
                ),
                Positioned(
                  top: position3.height,
                  right: position3.width - 20,
                  child: Container(
                    height: 80,
                    child: LanternWidget(),
                  ),
                ),
                Positioned(
                  top: position4.height,
                  right: position4.width - 20,
                  child: Container(
                    height: 80,
                    child: LongLanternWidget(),
                  ),
                ),
                // Positioned(
                //   top: heightFlower / 4.3,
                //   left: -width / 3,
                //   right: 0,
                //   height: heightFlower / 15,
                //   child: Transform.rotate(
                //       angle: -pi / 12,
                //       child: MoneyPocket(
                //           image: 'assets/images/event_2024/lixi.png')),
                // ),
                Positioned(
                  top: heightFlower / 1.8,
                  left: -width / 5,
                  right: 0,
                  height: heightFlower / 14,
                  child: Transform.rotate(
                      angle: -pi / 12,
                      child: MoneyPocket(
                          image: 'assets/images/event_2024/lixi.png')),
                ),
                Positioned(
                  top: heightFlower / 6,
                  left: -width / 1.8,
                  right: 0,
                  height: heightFlower / 12,
                  child: Transform.rotate(
                      angle: -pi / 12,
                      child: MoneyPocket(
                          image: 'assets/images/event_2024/lixi.png')),
                ),

                // Positioned(
                //   top: heightFlower / 3,
                //   left: 0,
                //   right: 0,
                //   height: heightFlower / 13,
                //   child: Transform.rotate(
                //     angle: -pi / 12,
                //     child: MoneyPocket(
                //       image: 'assets/images/event_2024/lixi.png',
                //     ),
                //   ),
                // ),
                /// Right
                Positioned(
                  top: heightFlower / 8,
                  left: width / 1.8,
                  right: 0,
                  height: heightFlower / 14,
                  child:
                      MoneyPocket(image: 'assets/images/event_2024/lixi.png'),
                ),

                Positioned(
                  top: heightFlower / 2,
                  left: width / 1.6,
                  right: 0,
                  height: heightFlower / 14,
                  child:
                      MoneyPocket(image: 'assets/images/event_2024/lixi.png'),
                ),
                Positioned(
                  top: heightFlower / 13,
                  left: -width / 6,
                  right: 0,
                  height: heightFlower / 7,
                  child:
                      MoneyPocket(image: 'assets/images/event_2024/lixi1.png'),
                ),

                Positioned(
                  top: heightFlower / 3,
                  left: -width / 4,
                  right: 0,
                  height: heightFlower / 7,
                  child:
                      MoneyPocket(image: 'assets/images/event_2024/lixi2.png'),
                ),
                Positioned(
                  top: heightFlower / 5,
                  left: width / 3.5,
                  right: 0,
                  height: heightFlower / 7,
                  child:
                      MoneyPocket(image: 'assets/images/event_2024/lixi3.png'),
                ),
                Positioned(
                  top: heightFlower / 2,
                  left: width / 4,
                  right: 0,
                  height: heightFlower / 8,
                  child:
                      MoneyPocket(image: 'assets/images/event_2024/lixi4.png'),
                ),
                Positioned(
                  top: heightFlower / 2.8,
                  left: width / 1.8,
                  right: 0,
                  height: heightFlower / 9,
                  child:
                      MoneyPocket(image: 'assets/images/event_2024/lixi5.png'),
                )
              ]),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 16),
              height: height / 9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image(
                    image:
                        AssetImage('assets/images/event_2024/nhiemvu-dem.png'),
                  ),
                  Image(
                    image: AssetImage('assets/images/event_2024/thele-dem.png'),
                  ),
                  Image(
                    image:
                        AssetImage('assets/images/event_2024/vinhdanh-dem.png'),
                  ),
                  Image(
                    image:
                        AssetImage('assets/images/event_2024/lichsu-dem.png'),
                  ),
                  Image(
                    image:
                        AssetImage('assets/images/event_2024/nhiemvu-dem.png'),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}

class MoneyPocket extends StatefulWidget {
  final String image;
  const MoneyPocket({super.key, required this.image});

  @override
  State<MoneyPocket> createState() => _MoneyPocketState();
}

class _MoneyPocketState extends State<MoneyPocket>
    with TickerProviderStateMixin {
  late AnimationController controllerAngle;
  late Animation<num> animationAngle;

  late AnimationController controller;
  late Animation<Offset> animation;
  final time = Random().nextInt(800) + 1000;

  final randomAngle = Random().nextInt(6) + 19;

  final double randomdy = Random().nextInt(10) + 15;
  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: time));
    animation =
        Tween<Offset>(begin: Offset(-25, -randomdy), end: Offset(20, randomdy))
            .animate(controller);
    controllerAngle = AnimationController(
        vsync: this, duration: Duration(milliseconds: time));

    animationAngle =
        Tween<num>(begin: -pi / randomAngle, end: pi / (randomAngle + 1))
            .animate(controllerAngle);
    controller
      ..forward()
      ..repeat(reverse: true);
    controllerAngle
      ..forward()
      ..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    controllerAngle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: (context, _) {
        return AnimatedBuilder(
          builder: (context, _) {
            return Transform(
              alignment: Alignment.topCenter,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(animation.value.dy * pi / 270)
                ..rotateZ(animationAngle.value * pi / 4)
                ..rotateY(animation.value.dx * pi / 270),
              child: Image(
                image: AssetImage(
                  widget.image,
                ),
              ),
            );
          },
          animation: animation,
        );
      },
      animation: animationAngle,
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

  final timeRotate = Random().nextInt(800) + 1200;

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

  final double ropeOnePortionHeight = 0.23;

  final double ropeTwoPortionHeight = 0.27;

  final double tailLanternPortionHeight = 0.08;

  final double lanternPortionHeight = 0.42;

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
                                'assets/images/event_2024/denlong.png',
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
                                                'assets/images/event_2024/day-denlong.png'),
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

class LongLanternWidget extends StatefulWidget {
  final double opacity;
  const LongLanternWidget({super.key, this.opacity = 1.0});

  @override
  State<LongLanternWidget> createState() => _LongLanternWidgetState();
}

class _LongLanternWidgetState extends State<LongLanternWidget>
    with EposPopup, TickerProviderStateMixin {
  @override
  void dispose() {
    controllerRotateRopeOne.dispose();
    controllerLantern.dispose();
    super.dispose();
  }

  late AnimationController controllerRotateRopeOne;
  late Animation<num> animationRotateRopeOne;

  late AnimationController controllerLantern;
  late Animation<Offset> animationLantern;

  bool isDrop = false;

  final timeRotate = Random().nextInt(800) + 1200;

  final rotateRope = Random().nextInt(6) + 24;

  final rotateZ = Random().nextInt(3) + 4;

  @override
  void initState() {
    controllerRotateRopeOne = AnimationController(
        vsync: this, duration: Duration(milliseconds: timeRotate));
    animationRotateRopeOne =
        Tween<num>(begin: -pi / rotateRope, end: pi / (rotateRope + 1))
            .animate(controllerRotateRopeOne);

    controllerLantern = AnimationController(
        vsync: this, duration: Duration(milliseconds: timeRotate + 500));
    animationLantern =
        Tween<Offset>(begin: Offset(-35, -10), end: Offset(30, 10))
            .animate(controllerLantern);
    controllerLantern
      ..forward()
      ..repeat(reverse: true);

    controllerRotateRopeOne
      ..forward()
      ..repeat(reverse: true);
    super.initState();
  }

  final double ropeOnePortionHeight = 0.35;

  final double lanternPortionHeight = 0.65;

  double heightRopeOne = 0;

  double heightLantern = 0;

  int conicPointOne = 4;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      final width = 10.0;

      heightRopeOne = ropeOnePortionHeight * constraint.maxHeight;
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
                  opacity: widget.opacity,
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
                              opacity: AlwaysStoppedAnimation(
                                widget.opacity,
                              ),
                              fit: BoxFit.fitHeight,
                              image: AssetImage(
                                'assets/images/event_2024/denlong_dai.png',
                              ),
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

  final double opacity;
  final int conicPoint;
  PathPainterLineOne(this.valueAnimation, this.conicPoint,
      {this.opacity = 1.0});

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.orange.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.conicTo(size.width / 2, size.height / conicPoint,
        size.width / 2 + valueAnimation, size.height, 2);
    canvas.drawPath(path, paint);
  }
}

class PathPainterLineSecond extends CustomPainter {
  final double valueAnimation;
  final double opacity;
  final int conicPoint;
  PathPainterLineSecond(this.valueAnimation, this.conicPoint,
      {this.opacity = 1.0});

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.orange.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.conicTo(size.width / 2, size.height / conicPoint,
        size.width / 2 + valueAnimation, size.height, 2);
    canvas.drawPath(path, paint);
  }
}

// class CurveLinePath extends CustomPainter {
//   final double height;
//   final int conicPoint;
//   CurveLinePath(this.height, this.conicPoint);

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;

//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = Colors.red
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.5;

//     Path path = Path();
//     path.moveTo(0, 0);

//     path.conicTo(size.width / 2, 0 + height, size.width, 0, 1);
//     canvas.drawPath(path, paint);
//   }
// }

// class CurveLinePath2 extends CustomPainter {
//   final double height;
//   final int conicPoint;
//   CurveLinePath2(this.height, this.conicPoint);

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;

//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = Colors.red
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.5;

//     Path path = Path();
//     path.moveTo(0, 0);

//     path.conicTo(size.width / 2, height, size.width, 0, 1);
//     canvas.drawPath(path, paint);
//   }
// }
