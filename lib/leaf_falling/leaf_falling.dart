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

class LoginFirebasePage extends StatefulWidget {
  const LoginFirebasePage({super.key});

  @override
  State<LoginFirebasePage> createState() => _LoginFirebasePageState();
}

class _LoginFirebasePageState extends State<LoginFirebasePage>
    with EposPopup, TickerProviderStateMixin {
  final accountController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    accountController.dispose();
    passController.dispose();
    controllerRotate.dispose();
    controller.dispose();
    super.dispose();
  }

  late AnimationController controllerRotate;
  late Animation<num> animationRotate;

  late AnimationController controller;

  late Animation<Offset> animation;

  bool isDrop = false;
  @override
  void initState() {
    controllerRotate =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animationRotate =
        Tween<num>(begin: -pi / 17, end: pi / 18).animate(controllerRotate);
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    animation = Tween<Offset>(begin: Offset(-25, -10), end: Offset(20, 5))
        .animate(controller);
    controller
      ..forward()
      ..repeat(reverse: true);
    controllerRotate
      ..forward()
      ..repeat(reverse: true);
    super.initState();
  }

  Offset offsetChange = Offset(0, 0);
  final heightRope = 30.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        color: Colors.blueGrey,
        padding: const EdgeInsets.all(24.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedBuilder(
                builder: (context, valueRotate) {
                  return CustomPaint(
                    size: Size(MediaQuery.sizeOf(context).width, heightRope),
                    painter: PathPainter2(
                      tan(animationRotate.value) *
                          (heightRope - heightRope / 7),
                    ),
                  );
                },
                animation: animationRotate,
              ),
              GestureDetector(
                onPanUpdate: (details) {
                  // setState(() {
                  //   offsetChange += details.delta;
                  // });
                  print(offsetChange);
                },
                child: AnimatedBuilder(
                  builder: (context, valueRotate) {
                    return Transform.translate(
                      offset: Offset(
                          tan(animationRotate.value) *
                              (heightRope - heightRope / 7),
                          -5),
                      child: AnimatedBuilder(
                        builder: (
                          context,
                          value,
                        ) {
                          return Transform(
                            alignment: Alignment.topCenter,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateX(animation.value.dy * pi / 180)
                              ..rotateZ(
                                -animationRotate.value.toDouble() * pi / 3,
                              )
                              ..rotateY(animation.value.dx * pi / 180),
                            child: Transform.rotate(
                              angle: -pi / 18,
                              child: Container(
                                height: 40,
                                width: 40,
                                child: Image(
                                  image: AssetImage('assets/images/lixi.png'),
                                ),
                              ),
                            ),
                          );
                        },
                        animation: animation,
                      ),
                    );
                  },
                  animation: animationRotate,
                ),
              ),
            ],
          ),
        ]),
      ),
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

class PathPainter2 extends CustomPainter {
  final double valueAnimation;
  PathPainter2(this.valueAnimation);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.conicTo(size.width / 2, size.height / 7,
        size.width / 2 + valueAnimation, size.height, 2);
    // path.cubicTo(size.width / 2, 3 * size.height / 4, 3 * size.width / 4,
    //     size.height / 4, size.width, size.height);
    canvas.drawPath(path, paint);
  }
}
