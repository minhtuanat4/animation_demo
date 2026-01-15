import 'dart:async';
import 'dart:math' as math;
import 'dart:math';

import 'package:animation_demo/hud_in_game.dart';
import 'package:animation_demo/model_game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame/text.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

/// This example simply adds a rotating white square on the screen.
/// If you press on a square, it will be removed.
/// If you press anywhere else, another square will be added.

List<double> durations = [0.1, 0.8, 0.15, 0.15, 0.25, 1];
List<double> ballDurations = [0.1, 0.8, 0.1, 2];
List<double> iconDurations = [0.5, 0.5];
List<double> randomDurations = [3, 1];
List<double> textSize = [28, 24];
Offset resolution = const Offset(944, 2048);
int startRandomMode = 15;
bool isRepeat = true;
double ratioSizeChau = 4.65;
double woodBarX = 10.8;
double animalMoveApart = 0.5;
double _accumulator = 0;
String fontGame = 'DVN';
String textBallIntro = 'Xuất hiện bóng Pickball đặc biệt!!!';
Vector2 goldHud = Vector2.all(0);
const double fixedDt = 1 / 60;

// class ThunderPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paintMain = Paint()
//       ..color = Colors.yellowAccent
//       ..style = PaintingStyle.fill;

//     Path p = Path();

//     // Main bolt (⚡ shape)
//     p.moveTo(size.width * 0.4, 0);
//     p.lineTo(size.width * 0.6, 0);
//     p.lineTo(size.width * 0.5, size.height * 0.4);
//     p.lineTo(size.width * 0.7, size.height * 0.4);
//     p.lineTo(size.width * 0.3, size.height);
//     p.lineTo(size.width * 0.4, size.height * 0.55);
//     p.lineTo(size.width * 0.2, size.height * 0.55);
//     p.close();

//     canvas.drawPath(p, paintMain);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

class MoleGame extends FlameGame
    with SingleGameInstance, HasCollisionDetection {
  late final CameraComponent cameraComponent;
  late final MoleWorld myWorld;
  List<String> imagePaths = [
    ...lstMole,
    ...lstVase,
    ...lstIcon,
    ...lstEffect,
  ];

  final Function(Vector2, Vector2) onBallTapped;

  final Function() onBallExist;

  Vector2 ballPosition = Vector2.all(0);

  Vector2 ballSize = Vector2.all(0);

  // Vector2 ballAnchor = Vector2.all(0);

  double paddingTop = 0;

  Vector2 staticPointPosi = Vector2.all(0);
  Vector2 staticStarPosi = Vector2.all(0);

  final ValueNotifier<int> scoreNotify = ValueNotifier<int>(0);

  final ValueNotifier<int> normalNotify = ValueNotifier<int>(0);
  final ValueNotifier<int> goldNotify = ValueNotifier<int>(0);
  final ValueNotifier<int> boomNotify = ValueNotifier<int>(0);
  final ValueNotifier<int> ballNotify = ValueNotifier<int>(0);

  final ValueNotifier<bool> startNotify = ValueNotifier<bool>(false);

  final ValueNotifier<int> countPerfectNotify = ValueNotifier<int>(0);

  late ValueNotifier<String> timerNotify;

  int scoreItem = 0;

  int countClick = 0;

  void addScore(int delta) {
    final currentScore = scoreNotify.value + delta;
    if (currentScore <= 0) {
      scoreNotify.value = 0;
      scoreItem = scoreNotify.value;
    } else {
      scoreNotify.value = currentScore;
      scoreItem = delta;
    }
  }

  int countBall = 1;

  bool isChangedMode = false;

  bool isBallAppear = false;

  final bool isRandomTime;

  int randomTime = 0;
  @override
  void onDispose() {
    Flame.images.clearCache();
    FlameAudio.audioCache.clearAll();
    super.onDispose();
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    super.lifecycleStateChange(state); // Always call the super method
    if (state == AppLifecycleState.paused) {
      FlameAudio.bgm.pause();
    } else if (state == AppLifecycleState.resumed) {
      FlameAudio.bgm.resume();
    }
  }

  @override
  void onRemove() {
    scoreNotify.dispose();
    normalNotify.dispose();
    goldNotify.dispose();
    boomNotify.dispose();
    startNotify.dispose();
    super.onRemove();
  }

  final int totalTimePlay;
  final bool hasSecret;
  MoleGame({
    required this.onBallTapped,
    required this.onBallExist,
    required this.hasSecret,
    required this.totalTimePlay,
    required this.isRandomTime,
    super.children,
    super.world,
    super.camera,
  }) {
    if (isRandomTime) {
      randomTime = startRandomMode;
    }
  }

  @override
  Future<void> onLoad() async {
    countBall = hasSecret ? 1 : 0;
    timerNotify = ValueNotifier<String>(totalTimePlay.toString());
    myWorld = MoleWorld(onBallTapped: onBallTapped);
    final int index = rnd.nextInt(2) + 1;
    cameraComponent = CameraComponent.withFixedResolution(
      world: myWorld,
      width: size.x,
      height: size.y,
    )..viewfinder.anchor = Anchor.topLeft;
    await Flame.images.loadAll(imagePaths);
    await FlameAudio.audioCache.loadAll([
      'normal.mp3',
      'gold.mp3',
      'boom.mp3',
      'ball.mp3',
      // 'xtime.mp3',
      // 'background1.mp3',
      'background2.mp3',
      'background3.mp3',

      'ball2.wav',
      'otc.mp3',
      // 'perfect1.wav',
      // 'perfect2.wav',
      // 'perfect3.wav',
      'perfect4.mp3',
      // 'event2026/win.mp3',
      // 'event2026/lose.mp3',
    ]);

    await FlameAudio.bgm.play('background${index + 1}.mp3', volume: 0.3);
    add(
      SpriteComponent(
        sprite: Sprite(
          Flame.images.fromCache('event/event_tet2026/bg_game.jpg'),
        ),
        size: size,
      ),
    );
    overlays
      ..add('HUDGame')
      ..add('ReadyGame');

    await addAll([myWorld, cameraComponent]);
    add(HudInGame(size));
  }
}

final rnd = Random();
Vector2 randomVector2() => (Vector2.random(rnd) - Vector2.random(rnd)) * 100;

class MoleWorld extends World
    with TapCallbacks, HasGameReference<MoleGame>, HasCollisionDetection {
  double ratioWoodBarPosi = 920 / resolution.dy;
  double horseDistanceX = 16 + 4;
  List<bool> occupiedPositions = [];
  List<VaseComponent> vaseWidgets = [];
  List<Animal> animals = [];
  // int duration = 1;
  bool newTurn = false;

  late Timer loopTimer;

  bool isHavingBall = true;

  final Function(Vector2, Vector2) onBallTapped;

  bool processingTap = false;
  bool getBall = false;
  double delayTime = 0.15;
  double delayTimer = 0.15;

  MoleWorld({
    required this.onBallTapped,
    super.children,
    super.priority,
    super.key,
  });

  @override
  Future<void> onLoad() async {
    await Flame.device.fullScreen();
    await Flame.device.setPortrait();
    occupiedPositions = List.filled(9, false);

    row1 = WoodBarComponent(Vector2(0, ratioWoodBarPosi * game.size.y), 0);
    row2 = WoodBarComponent(Vector2(0, ratioWoodBarPosi * game.size.y), 1);
    row3 = WoodBarComponent(Vector2(0, ratioWoodBarPosi * game.size.y), 2);

    add(row1);
    add(row2);
    add(row3);
    loopTimer = Timer(
        durations[0] +
            durations[1] +
            durations[2] +
            durations[3] +
            durations[4] +
            durations[5], onTick: () {
      if (game.isChangedMode) {
        stopTimer();
        changeMode();
      } else {
        randomOccupiedPositions();
      }
    }, repeat: isRepeat, autoStart: false);
  }

  late WoodBarComponent row1;
  late WoodBarComponent row2;
  late WoodBarComponent row3;
  void pauseResetTimer() {
    // print(animals.toList().toString());
    // final animalsTmp = animals
    //   ..removeWhere((e) => e.moleModel.type == MoleType.ball);
    for (final element in animals) {
      element.removeFromParent();
    }

    loopTimer
      ..stop()
      ..reset();
  }

  void resumeTimer() {
    isBallTapped = false;
    randomOccupiedPositions();
    loopTimer.start();
  }

  void stopTimer() {
    loopTimer.stop();
  }

  void startGame() {
    loopTimer.start();
    randomOccupiedPositions();
  }

  @override
  void onMount() {
    vaseWidgets.addAll(row1.vaseWidgets);
    vaseWidgets.addAll(row2.vaseWidgets);
    vaseWidgets.addAll(row3.vaseWidgets);
    // randomOccupiedPositions();
    // add(StarComponent(Vector2(50, 250)));
    // add(BoomComponent(Vector2(40, 40), Vector2(50, 250)));
    // add(GoldComponent(
    //     Vector2(60, 30), Vector2(50, 250), Vector2(0.08, 0.08), 20));
    // add(StaticGoldComponent(
    //     Vector2(60, 30), Vector2(100, 900), Vector2.all(0)));

    super.onMount();
  }

  @override
  void update(double dt) {
    super.update(dt);

    _accumulator += dt;

    while (_accumulator >= fixedDt) {
      fixedUpdate(fixedDt);
      _accumulator -= fixedDt;
    }
  }

  Vector2 getRandomVector() {
    return (Vector2.random(rnd) - Vector2(0.5, -1)) * 200;
  }

  void fixedUpdate(double dt) {
    loopTimer.update(dt);
    if (processingTap) {
      delayTime -= dt;
      if (delayTime <= 0) {
        processingTap = false;
        delayTime = delayTimer;
      }
    }
  }

  bool isBallTapped = false;
  final random = math.Random();
  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    if (!game.startNotify.value) {
      return;
    }
    if (processingTap) {
      return;
    }
    processingTap = true;
    if (isBallTapped) {
      return;
    }

    if (!event.handled) {
      final touchPoint = event.localPosition;

      for (final animal in animals) {
        final rect = Rect.fromLTWH(
          animal.absolutePosition.x - animal.size.x * animal.anchor.x,
          animal.absolutePosition.y - animal.size.y * animal.anchor.y,
          animal.size.x,
          animal.size.y,
        );
        if (animal.isEnableTap &&
            rect.contains(Offset(touchPoint.x, touchPoint.y))) {
          game.countClick++;
          // Vibration.vibrate(duration: 200);
          animal.onCollision(animal.index);
        } else {
          add(TouchComponent(event.localPosition));
        }
      }
    }
  }

  int getRandomElement(List<int> list) {
    // Create a new Random object (consider reusing for performance if calling frequently)
    // Generate a random index based on the list length
    final i = game.myWorld.random.nextInt(list.length);
    final result = list[i];
    list.removeAt(i);
    // Return the element at the random index
    return result + 1;
  }

  void randomOccupiedPositions() {
    animals.clear();

    final defaults = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
    final int count = random.nextInt(3) + 4;
    final occupiedPositions1 = List.filled(count, true);

    final occupiedPositions2 =
        List.filled(occupiedPositions.length - count, false);
    occupiedPositions = [...occupiedPositions1, ...occupiedPositions2];
    occupiedPositions.shuffle();

    final orders = List.filled(count, MoleType.normal);
    final randomBoom = Random().nextInt(10);
    if (randomBoom < 9) {
      orders[0] = MoleType.bomber;
    }
    final randomGold = Random().nextInt(10);

    if (randomGold < 7) {
      orders[1] = MoleType.gold;
    }
    orders.shuffle();

    int index = 0;

    for (var i = 0; i < occupiedPositions.length; i++) {
      if (occupiedPositions[i]) {
        final num = getRandomElement(defaults);
        final moleModel = MoleModel()..makeMoleModel(orders[index], num);
        index++;
        final vase = vaseWidgets[i];
        final indexMole = vase.indexRow * 3 + vase.indexVase;

        // MoleType type = occupiedPositions[i].type;
        if (game.countBall > 0 && game.isBallAppear) {
          game.isBallAppear = false;
          // vase.shake();
          moleModel.ballData();
          game.countBall--;
        }
        final animal = Animal(vase.size, indexMole, () {
          // vase.setColor(Colors.black);
          // print("Animal completed");
        }, () {
          // vase.setColor(Colors.black);

          // print("Animal Removed");
        }, vase, moleModel..index = indexMole);
        animals.add(animal);
        vase.add(animal);
      }
    }
  }

  void changeMode() {
    animals.clear();
    for (var i = 0; i < occupiedPositions.length; i++) {
      final moleModel = MoleModel()..randomGoodData();
      final vase = vaseWidgets[i];
      final indexMole = vase.indexRow * 3 + vase.indexVase;

      // MoleType type = occupiedPositions[i].type;
      final animalTimer = AnimalTimer(null, vase.size, indexMole, () {
        // vase.setColor(Colors.black);
      }, () {
        // vase.setColor(Colors.black);
      }, vase, moleModel..index = indexMole,
          isAnimal: math.Random().nextBool());
      vase.add(animalTimer);
    }
  }
}

class TouchComponent extends PositionComponent {
  TouchComponent(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(12),
          anchor: Anchor.center,
        );
  @override
  FutureOr<void> onLoad() {
    add(ScaleEffect.by(
        Vector2(2.1, 2.1),
        EffectController(
          duration: 0.05,
        ), onComplete: () {
      removeFromParent();
    }));
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    final radius = size.x / 2;

    final paint = Paint()
      ..shader = const RadialGradient(
        center: Alignment.center,
        radius: 1,
        colors: [
          Colors.white,
          Colors.transparent,
        ],
        stops: [0.18, 0.5],
      ).createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    canvas.drawCircle(center, radius, paint);
    super.render(canvas);
  }
}

class WoodBarComponent extends SpriteComponent with HasGameReference {
  final int indexRow;
  WoodBarComponent(Vector2 position, this.indexRow) : super(position: position);
  List<VaseComponent> vaseWidgets = [];
  List<VaseComponent3> vaseWidgets3 = [];

  @override
  Future<void> onLoad() async {
    // Load the sprite sheet
    // Assuming 8 frames in a single row
    sprite = Sprite(Flame.images.fromCache(
      'event/event_tet2026/wood_bar.png',
    ));
    size = Vector2(game.size.x, game.size.x / woodBarX);
    position = Vector2(position.x,
        position.y + (340 / 2048 * game.size.y + size.y) * indexRow);
    final sizeChauX = game.size.x / ratioSizeChau;
    final spaceSize = (size.x - sizeChauX * 3) / 4;
    // add(ExpandLight(Vector2(size.x, size.y * 3), size, 3, indexRow, spaceSize));

    vaseWidgets3 = [
      VaseComponent3(
        Vector2(sizeChauX, sizeChauX),
        size,
        0,
        spaceSize,
      ),
      VaseComponent3(
        Vector2(sizeChauX, sizeChauX),
        size,
        1,
        spaceSize,
      ),
      VaseComponent3(
        Vector2(sizeChauX, sizeChauX),
        size,
        2,
        spaceSize,
      ),
    ];
    vaseWidgets = [
      VaseComponent(
        Vector2(sizeChauX, sizeChauX),
        size,
        0,
        indexRow,
        spaceSize,
        vaseWidgets3[0],
      ),
      VaseComponent(
        Vector2(sizeChauX, sizeChauX),
        size,
        1,
        indexRow,
        spaceSize,
        vaseWidgets3[1],
      ),
      VaseComponent(
        Vector2(sizeChauX, sizeChauX),
        size,
        2,
        indexRow,
        spaceSize,
        vaseWidgets3[2],
      ),
    ];
    for (var i = 0; i < vaseWidgets.length; i++) {
      add(vaseWidgets3[i]);
      add(vaseWidgets[i]);
    }
    anchor = Anchor.topLeft;
  }
}

class ExpandLight extends SpriteComponent {
  final Vector2 sizeParent;
  final int indexVase;
  final int indexRow;
  final double spaceSize;
  ExpandLight(Vector2 size, this.sizeParent, this.indexVase, this.indexRow,
      this.spaceSize)
      : super(
          size: size,
          priority: -3,
          sprite: Sprite(
              Flame.images.fromCache('event/event_tet2026/expand_light.jpg')),
          anchor: Anchor.bottomCenter,
        );
}

class VaseComponent extends SpriteComponent with HasGameReference<MoleGame> {
  final Vector2 sizeParent;
  final int indexVase;
  final int indexRow;
  final double spaceSize;
  final VaseComponent3 vaseComponent3;
  VaseComponent(Vector2 size, this.sizeParent, this.indexVase, this.indexRow,
      this.spaceSize, this.vaseComponent3)
      : super(
          size: size,
          priority: -2,
          sprite: Sprite(
              Flame.images.fromCache('event/event_tet2026/chau_vang1.png')),
          anchor: Anchor.bottomCenter,
        );

  double duration = 1;
  VaseComponent2? vase2;
  BottomLight? bottomLight;
  AnimalBackground? animalBackground;
  @override
  Future<void> onLoad() async {
    position.y = game.size.x / woodBarX / 2;
    position.x = size.x * indexVase + spaceSize * (indexVase + 1) + size.x / 2;
    vase2 = VaseComponent2(
        Vector2(game.size.x / ratioSizeChau, game.size.x / ratioSizeChau),
        size,
        indexVase);
    bottomLight = BottomLight(
      size,
      sizeParent,
      indexVase,
    );
    add(bottomLight!);
    add(vase2!);
  }

  void shake() {
    final effect = RotateEffect.by(
        math.pi / 24, // Rotate by a small amount (radians)
        EffectController(
          duration: 0.05, // Speed of the flutter
          repeatCount: 6,
          alternate: true,

          //
          // // Go back and forth
        ), onComplete: () {
      vaseComponent3.show();
    });
    vaseComponent3.hide();
    add(effect);
    vase2!.add(effect);

    // final effect2 = RotateEffect.by(
    //   -math.pi / 28, // Rotate by a small amount (radians)
    //   EffectController(
    //     duration: 0.08, // Speed of the flutter
    //     repeatCount: 4,
    //     alternate: true,
    //     //
    //     // // Go back and forth
    //   ),
    // );
    // // vase2?.add(effect);
    // add(effect2);
  }

  void addBling(Vector2 sizeBall) {
    this.bottomLight?.show();
    animalBackground = AnimalBackground(sizeBall, size, () {
      this.bottomLight?.hide();
    });
    add(animalBackground!);
  }
}

class BottomLight extends SpriteComponent with HasGameReference {
  final Vector2 sizeParent;
  final int index;
  BottomLight(Vector2 size, this.sizeParent, this.index)
      : super(
          size: size,
          priority: 1,
          anchor: Anchor.bottomCenter,
          sprite: Sprite(Flame.images
              .fromCache('event/event_tet2026/animal/bottom_bling.png')),
        );

  @override
  Future<void> onLoad() async {
    position.y = position.y + size.y / 1.7;
    position.x = position.x + size.x / 2;
    hide();
  }

  void hide() {
    setColor(Colors.transparent);
  }

  void show() {
    setColor(Colors.black);
  }

  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);
  //   // Ensure the component size is set correctly
  //   final paint = Paint()..color = const Color.fromARGB(255, 204, 191, 0);
  //   canvas.drawRect(size.toRect(), paint);
  // }
}

class VaseComponent2 extends SpriteComponent with HasGameReference {
  final Vector2 sizeParent;
  final int index;
  VaseComponent2(Vector2 size, this.sizeParent, this.index)
      : super(
          size: size,
          priority: 2,
          sprite: Sprite(
              Flame.images.fromCache('event/event_tet2026/chau_vang2.png')),
          anchor: Anchor.bottomCenter,
        );

  @override
  Future<void> onLoad() async {
    position.y = position.y + size.y;
    position.x = position.x + size.x / 2;
    add(BlingComponent(size));
    add(BlingComponent(size));
    add(BlingComponent(size));
    add(BlingComponent(size));
  }

  void hide() {
    setColor(Colors.transparent);
  }

  void show() {
    setColor(Colors.black);
  }
}

class VaseComponent3 extends SpriteComponent with HasGameReference {
  final Vector2 sizeParent;
  final int indexVase;
  final double spaceSize;
  VaseComponent3(Vector2 size, this.sizeParent, this.indexVase, this.spaceSize)
      : super(
          size: size,
          priority: -3,
          anchor: Anchor.bottomLeft,
          sprite: Sprite(
              Flame.images.fromCache('event/event_tet2026/chau_vang3.png')),
        );

  @override
  FutureOr<void> onLoad() {
    position.y = game.size.x / woodBarX / 2;
    position.x = size.x * indexVase + spaceSize * (indexVase + 1);

    return super.onLoad();
  }

  void hide() {
    setColor(Colors.transparent);
  }

  void show() {
    setColor(Colors.black);
  }
}

class AnimalTimer extends PositionComponent with HasGameReference<MoleGame> {
  final Vector2 sizeParent;
  final int index;
  final Function() onComplete;
  final Function() onRemoveCall;
  final VaseComponent vase;
  final MoleModel moleModel;
  final bool isAnimal;

  final Animal? animalObj;
  AnimalTimer(
    this.animalObj,
    this.sizeParent,
    this.index,
    this.onComplete,
    this.onRemoveCall,
    this.vase,
    this.moleModel, {
    this.isAnimal = false,
  }) : super();
  Timer? countdown;
  @override
  FutureOr<void> onLoad() {
    if (isAnimal) {
      addAnimal();
      removeFromParent();
    } else {
      final double duration =
          math.Random().nextDouble() * randomDurations[0] + randomDurations[1];

      countdown = Timer(duration, autoStart: true, onTick: () {
        addAnimal();
        removeFromParent();
      });
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _accumulator += dt;

    while (_accumulator >= fixedDt) {
      fixedUpdate(fixedDt);
      _accumulator -= fixedDt;
    }
  }

  void fixedUpdate(double dt) {
    countdown?.update(dt);
  }

  void addAnimal() {
    if (animalObj != null) {
      game.myWorld.animals.remove(animalObj);
    }
    final animal = Animal(vase.size, index, () {
      // vase.setColor(Colors.black);
      // print("Animal completed");
    }, () {
      // vase.setColor(Colors.black);

      // print("Animal Removed");
    }, vase, moleModel..index = index, isAuto: true);
    // vase.setColor(Colors.transparent);
    vase.add(animal);
    game.myWorld.animals.add(animal);
  }
}

class Animal extends SpriteComponent with HasGameReference<MoleGame> {
  final Vector2 sizeParent;
  final int index;
  final Function() onComplete;
  final Function() onRemoveCall;
  final VaseComponent vase;
  final MoleModel moleModel;
  final bool isAuto;
  Animal(
    this.sizeParent,
    this.index,
    this.onComplete,
    this.onRemoveCall,
    this.vase,
    this.moleModel, {
    this.isAuto = false,
  }) : super(priority: 0);

  Timer? interval2;

  bool isEnableTap = true;

  // AnimalBackground? animalBackground;
  bool isBallTapped = false;

  MoveEffect? effect1;
  MoveEffect? effect2;

  StaticGoldComponent? goldComponentStatic;
  StaticBoomComponent? boomComponentStatic;

  Vector2 boomEffectPosi = Vector2.all(0);
  Vector2 goldEffectPosi = Vector2.all(0);

  bool onCollide = false;

  double minPositionY = 0;

  PaddleEffect? padddeEffectt;
  @override
  Future<void> onLoad() async {
    // Load the sprite sheet
    // Assuming 8 frames in a single row

    anchor = Anchor.center;
    position.x = sizeParent.x / 2;

    if (isAuto) {
      _initAnimal();
    } else {
      if (moleModel.type != MoleType.ball) {
        _initAnimal();
      } else {
        _initBall();
      }
    }
  }

  @override
  void onMount() {
    vase.setColor(Colors.transparent);
    super.onMount();
  }

  @override
  void onRemove() {
    // onRemoveCall();
    if (moleModel.type != MoleType.bomber ||
        moleModel.type == MoleType.bomber && !onCollide) {
      vase.setColor(Colors.black);
    }
    isEnableTap = false;
    game.myWorld.animals.remove(this);
    vase.animalBackground?.removeFromParent();
    removeIcon();

    super.onRemove();
  }

  stopAim() {
    effect1?.removeFromParent();
    interval2?.stop();
    effect2?.removeFromParent();
  }

  setSpriteOnCollision() {
    sprite = Sprite(Flame.images.fromCache(moleModel.cryImagePath));
    removeIcon();
  }

  removeIcon() {
    goldComponentStatic?.removeFromParent();
    boomComponentStatic?.removeFromParent();
  }

  void randomAnimal() {
    if (!isAuto) {
      return;
    }

    vase.add(AnimalTimer(
      this,
      sizeParent,
      index,
      onComplete,
      onRemoveCall,
      vase,
      moleModel,
    ));
  }

  void onCollision(int index) {
    if (moleModel.type != MoleType.ball) {
      if (!isEnableTap) {
        return;
      }
      onCollide = true;

      isEnableTap = false;
      // this.removeFromParent();
      game.addScore(moleModel.score);
      stopAim();
      setSpriteOnCollision();
      game.myWorld.add(PalleComponent(absolutePosition, size, () {}));
      padddeEffectt?.show();
      switch (moleModel.type) {
        case MoleType.normal:
          if (game.countPerfectNotify.value < 10) {
            FlameAudio.play('normal.mp3');
          }

          game.normalNotify.value = game.normalNotify.value + 1;
          game.countPerfectNotify.value++;
          game.myWorld.add(StarComponent(absolutePosition));
          add(MoveEffect.to(
              Vector2(position.x, minPositionY),
              EffectController(
                  duration: durations[4] *
                      (1 - (position.y / minPositionY).clamp(0.1, 1))),
              onComplete: () {
            onComplete();
            padddeEffectt?.hide();
            // removeIcon();
            randomAnimal();
            this.removeFromParent();
          }));

          break;
        case MoleType.gold:
          if (game.countPerfectNotify.value < 10) {
            FlameAudio.play('gold.mp3', volume: 0.7);
          }

          game.goldNotify.value = game.goldNotify.value + 1;
          game.countPerfectNotify.value++;
          final sizeParam = this.size;
          game.myWorld.add(GoldComponent(
              sizeParam,
              goldEffectPosi,
              Vector2(moleModel.dimension.dx, moleModel.dimension.dy),
              moleModel.score));

          add(MoveEffect.to(
              Vector2(position.x, minPositionY),
              EffectController(
                  duration: durations[4] *
                      (1 - (position.y / minPositionY).clamp(0.1, 1))),
              onComplete: () {
            onComplete();
            padddeEffectt?.hide();
            // removeIcon();
            randomAnimal();
            this.removeFromParent();
          }));
          break;
        case MoleType.bomber:
          game.boomNotify.value = game.boomNotify.value + 1;
          game.countPerfectNotify.value = 0;

          game.myWorld.add(OTCComponent(absolutePosition, vase));
          game.myWorld
              .add(BoomComponent(size, boomEffectPosi, moleModel.score, vase));

          add(MoveEffect.to(Vector2(position.x, minPositionY),
              EffectController(duration: durations[4] / 3), onComplete: () {
            onComplete();
            padddeEffectt?.hide();
            // removeIcon();
            randomAnimal();
            this.removeFromParent();
          }));

          break;
        default:
      }
      // final paddle = PalleComponent(size, () {});
      // add(paddle);
    } else {
      // for (var element in game.myWorld.animals) {
      //   element.removeFromParent();
      // }
      if (!isEnableTap) {
        return;
      }

      isEnableTap = false;
      vase.animalBackground?.removeFromParent();

      game.countPerfectNotify.value++;
      this.removeFromParent();
      game.overlays.add('BallAnim');

      final positionBall = Vector2(
        absolutePosition.x - size.x * anchor.x,
        absolutePosition.y - size.y * anchor.y,
      );
      game.onBallTapped(positionBall, size);
      game.ballPosition = positionBall;
      game.ballSize = size;
      // game.ballAnchor = Vector2(size.x * anchor.x, size.y * anchor.y);
      game.myWorld.isBallTapped = true;
    }
  }

  _initAnimal() {
    const double spaceWithTop = 24;
    final sizeX = sizeParent.x * 0.74;
    final sizeY = sizeX * moleModel.resolution.dy / moleModel.resolution.dx;
    size = Vector2(sizeX, sizeY);
    minPositionY = sizeParent.y / 2 - spaceWithTop / 2 + moleModel.margin;
    position.y = position.y + minPositionY;

    // print('object ' + position.y.toString());
    // position.x = (sizeParent.x - sizeX) / 2;
    sprite = Sprite(Flame.images.fromCache(moleModel.imagePath));

    switch (moleModel.type) {
      case MoleType.gold:
        goldComponentStatic = StaticGoldComponent(size, absolutePosition,
            Vector2(moleModel.dimension.dx, moleModel.dimension.dy));
        add(goldComponentStatic!);
        goldEffectPosi = goldComponentStatic!.absolutePosition;
        break;
      case MoleType.bomber:
        boomComponentStatic = StaticBoomComponent(size, absolutePosition,
            Vector2(moleModel.dimension.dx, moleModel.dimension.dy));
        add(boomComponentStatic!);
        boomEffectPosi = boomComponentStatic!.absolutePosition;

        break;
      default:
    }
    padddeEffectt = PaddleEffect(size);
    add(padddeEffectt!);
    // add(RectangleComponent.relative(
    //   Vector2(1, 1),
    //   parentSize: size,
    //   paint: Paint()..color = Colors.blueAccent,
    // ));
    // add a hitbox for collision detection
    // final hitbox = RectangleHitbox(
    //   size: size,
    // )..collisionType = CollisionType.passive; // passive: collides with active
    // add(hitbox);
    effect1 = MoveEffect.by(
        Vector2(0, -minPositionY - 4), EffectController(duration: durations[0]),
        onComplete: () {
      isEnableTap = true;
      interval2?.start();
    });

    this.add(effect1!);
    effect2 = MoveEffect.to(
      Vector2(position.x, minPositionY),
      EffectController(duration: durations[2]),
      onComplete: () {
        onComplete();
        removeIcon();
        if (isAuto) {
          vase.add(AnimalTimer(
            this,
            sizeParent,
            index,
            onComplete,
            onRemoveCall,
            vase,
            moleModel,
          ));
        }
        this.removeFromParent();
      },
    );

    interval2 = Timer(
      durations[1],
      onTick: () => {this.add(effect2!)},
      autoStart: false,
    );
  }

  _initBall() {
    /// More greatter, HitBox is more smaller
    // const smallHitBox = 6.0;
    game.onBallExist();
    size = Vector2.all(sizeParent.x * 0.7);

    //  size = Vector2(sizeX, sizeParent.y - spaceWithTop);
    // minPositionY = sizeParent.y / 2 + spaceWithTop / 2;
    position.y = position.y + minPositionY;
    position.y = position.y - 6 + size.y / 2;
    sprite = Sprite(Flame.images.fromCache(moleModel.imagePath));

    // add a hitbox for collision detection
    // add(CircleComponent(
    //     position: Vector2(position.x - sizeParent.x / 2 + smallHitBox,
    //         position.y + smallHitBox + 4),
    //     radius: sizeParent.x * 0.7 / 2 - smallHitBox,
    //     paint: Paint()..color = Colors.white));

    // final hitbox = CircleHitbox(
    //   position: Vector2(position.x - sizeParent.x / 2 + smallHitBox,
    //       position.y + smallHitBox + 4),
    //   radius: sizeParent.x * 0.7 / 2 - smallHitBox,
    // )..collisionType = CollisionType.active;
    // add(hitbox);
    this.add(MoveEffect.by(Vector2(0, -size.y * animalMoveApart),
        EffectController(duration: ballDurations[0]), onComplete: () {
      vase.addBling(size);
      if (game.myWorld.isBallTapped) {
        return;
      }
      interval2?.start();
    }));

    interval2 = Timer(
      ballDurations[1],
      onTick: () => {
        this.add(MoveEffect.by(Vector2(0, size.y / 4),
            EffectController(duration: ballDurations[2]), onComplete: () {
          onComplete();
          if (game.myWorld.isBallTapped) {
            return;
          }
          this.removeFromParent();
        }))
      },
      autoStart: false,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    _accumulator += dt;

    while (_accumulator >= fixedDt) {
      fixedUpdate(fixedDt);
      _accumulator -= fixedDt;
    }
  }

  void fixedUpdate(double dt) {
    interval2?.update(dt);
  }

  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);
  //   // Ensure the component size is set correctly
  //   final paint = Paint()..color = const Color.fromARGB(255, 0, 218, 185);
  //   canvas.drawRect(size.toRect(), paint);
  // }
}

class AnimalBackground extends SpriteComponent with HasGameReference<MoleGame> {
  final Vector2 sizeParent;
  // final Vector2 positionParent;
  final double xTimesSize;

  final Function() onComplete;

  AnimalBackground(Vector2 size, this.sizeParent, this.onComplete,
      {this.xTimesSize = 2})
      : super(
            priority: -1,
            size: size,
            anchor: Anchor.center,
            sprite: Sprite(Flame.images
                .fromCache('event/event_tet2026/animal/bling.png')));

  @override
  Future<void> onLoad() async {
    final sizeX = sizeParent.x * (xTimesSize);
    size = Vector2(sizeX, sizeX);
    // // Load the sprite sheet
    // position.y = position.y - (sizeX - sizeParent.x) / 2 + 4 + sizeX / 2;
    position.x = sizeParent.x / 2;
    position.y = position.y - size.y / 2 + size.y / 2;
    final effect = RotateEffect.by(
      math.pi * 2, // Or your flame color
      EffectController(duration: ballDurations[1] + 1),
      onComplete: () => removeFromParent(),
    );
    add(effect);
  }

  @override
  void onRemove() {
    onComplete();
    super.onRemove();
  }

  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);
  //   // Ensure the component size is set correctly
  //   final paint = Paint()..color = const Color.fromARGB(255, 76, 189, 119);
  //   canvas.drawRect(size.toRect(), paint);
  // }
}

class StaticGoldComponent extends SpriteComponent
    with HasGameReference<MoleGame> {
  final Vector2 sizeParent;
  final Vector2 positionParam;
  final Vector2 dimention;

  StaticGoldComponent(
    this.sizeParent,
    this.positionParam,
    this.dimention,
  ) : super(
            // anchor: Anchor.topCenter,
            sprite: Sprite(Flame.images.fromCache(
          'event/event_tet2026/icon/gold.png',
        )));

  double radius = 0;
  Vector2 padding = Vector2.all(12);
  @override
  FutureOr<void> onLoad() {
    final sizeX = sizeParent.x * 0.95;
    size = Vector2(sizeX, sizeX * 87 / 159);
    position = Vector2((sizeParent.x - size.x) / 2 - sizeParent.x * dimention.x,
        -sizeParent.y * (dimention.y - 0.04));
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    final radius = size.x / 2;
    final center = Offset(size.x / 2, size.y / 1.8);
    final paint = Paint()
      ..shader = const RadialGradient(
        center: Alignment.center,
        radius: 0.7,
        colors: [
          Color.fromARGB(255, 255, 234, 0),
          Color.fromARGB(255, 224, 208, 26),
          Color.fromARGB(0, 233, 222, 140),
        ],
        stops: [0.05, 0.2, 0.5],
      ).createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    canvas.drawCircle(center, radius, paint);
    super.render(canvas);
  }
}

class GoldComponent extends SpriteComponent with HasGameReference<MoleGame> {
  final Vector2 sizeParent;
  final Vector2 positionParam;
  final Vector2 dimention;
  final int score;
  GoldComponent(
    this.sizeParent,
    this.positionParam,
    this.dimention,
    this.score,
  ) : super(
            priority: 0,
            anchor: Anchor.topLeft,
            sprite: Sprite(Flame.images.fromCache(
              'event/event_tet2026/icon/gold.png',
            )));
  Vector2 padding = Vector2.all(12);
  @override
  FutureOr<void> onLoad() {
    final sizeX = sizeParent.x * 0.95;
    size = Vector2(sizeX, sizeX * 87 / 159);
    position = positionParam;
    startAim();
    return super.onLoad();
  }

  void startAim() {
    add(MoveEffect.by(Vector2(0, -52),
        EffectController(duration: iconDurations[0], curve: Curves.easeOutBack),
        onComplete: () {
      // game.myWorld.add(TextSizeAnim(absolutePosition, score));
      add(MoveEffect.to(
          goldHud,
          EffectController(
            duration: iconDurations[0] / 1.2,
          ), onComplete: () {
        removeFromParent();
      }));
    }));
  }

  void hide() {
    setColor(Colors.transparent);
  }

  @override
  void update(double dt) {
    game.myWorld.add(
        BlingParticle(absolutePosition + Vector2(size.x / 2 - 2, size.y / 2)));

    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    final radius = size.x / 2;
    final center = Offset(size.x / 2, size.y / 1.85);
    final paint = Paint()
      ..shader = const RadialGradient(
        center: Alignment.center,
        radius: 0.6,
        colors: [
          Color.fromARGB(255, 255, 234, 0),
          Color.fromARGB(255, 224, 208, 26),
          Color.fromARGB(0, 233, 222, 140),
        ],
        stops: [0.05, 0.2, 0.5],
      ).createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    canvas.drawCircle(center, radius, paint);
    super.render(canvas);
  }
}

class BlingParticle extends PositionComponent {
  BlingParticle(
    Vector2 position,
  ) : super(
          priority: -2,
          position: position,
          size: Vector2(24, 24),
          anchor: Anchor.center,
        );
  @override
  FutureOr<void> onLoad() {
    add(SpriteComponent(
        size: size,
        sprite: Sprite(
            Flame.images.fromCache('event/event_tet2026/icon/bling.png'))));
    add(ScaleEffect.by(
        Vector2(0.15, 0.15),
        EffectController(
          duration: 0.2,
        ), onComplete: () {
      add(RemoveEffect());
    }));
    return super.onLoad();
  }
}

class StaticBoomComponent extends SpriteComponent
    with HasGameReference<MoleGame> {
  final Vector2 sizeParent;
  final Vector2 positionParam;
  final Vector2 dimention;
  StaticBoomComponent(
    this.sizeParent,
    this.positionParam,
    this.dimention,
  ) : super(
            sprite: Sprite(Flame.images.fromCache(
          'event/event_tet2026/icon/boom.png',
        )));

  Vector2 padding = Vector2.all(12);
  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
    final sizeX = sizeParent.x * 56 / 168;
    size = Vector2(sizeX, sizeX * 70 / 56);
    position = Vector2(
        (sizeParent.x - sizeX) / 2 - sizeParent.x * dimention.x + size.x / 2,
        -sizeParent.y * dimention.y + size.y / 2);
    add(ScaleEffect.by(
      Vector2.all(1.4),
      EffectController(
        duration: 0.22,
        alternate: true,
        infinite: true,
      ),
    ));
    return super.onLoad();
  }

  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);
  //   // Ensure the component size is set correctly
  //   final paint = Paint()..color = const Color.fromARGB(255, 76, 189, 119);
  //   canvas.drawRect(size.toRect(), paint);
  // }
}

class OTCComponent extends SpriteComponent {
  final Vector2 positionParam;
  final VaseComponent vase;

  OTCComponent(this.positionParam, this.vase)
      : super(
            sprite: Sprite(Flame.images.fromCache(
          'event/event_tet2026/effect/otc.png',
        )));
  @override
  FutureOr<void> onLoad() {
    FlameAudio.play('otc.mp3', volume: 0.7);
    anchor = Anchor.centerLeft;
    angle = -pi / 18;
    final sizeX = vase.size.x * 0.84;
    size = Vector2(sizeX, sizeX * 137 / 178);
    scale = Vector2.all(0.1);
    position = positionParam + Vector2(0, 8);
    add(ScaleEffect.to(Vector2(1.4, 1.1),
        EffectController(duration: iconDurations[1], curve: Curves.elasticOut),
        onComplete: () {
      add(RemoveEffect());
    }));
    return super.onLoad();
  }
}

class BoomComponent extends SpriteComponent with HasGameReference<MoleGame> {
  final Vector2 sizeParent;
  final Vector2 positionParam;
  final int score;
  final VaseComponent vase;

  BoomComponent(
    this.sizeParent,
    this.positionParam,
    this.score,
    this.vase,
  ) : super(
            priority: 0,
            anchor: Anchor.bottomCenter,
            sprite: Sprite(Flame.images.fromCache(
              'event/event_tet2026/icon/boom.png',
            )));
  @override
  FutureOr<void> onLoad() {
    final sizeX = sizeParent.x * 56 / 168;
    size = Vector2(sizeX, sizeX * 70 / 56);
    position =
        Vector2(positionParam.x + sizeX / 4, positionParam.y - size.y / 1.7);
    startAim();
    return super.onLoad();
  }

  void startAim() {
    add(ScaleEffect.by(Vector2.all(2.3),
        EffectController(duration: iconDurations[1], curve: Curves.elasticIn),
        onComplete: () {
      add(RemoveEffect(onComplete: () {
        vase.shake();
        vase.setColor(Colors.black);
        game.myWorld.add(TextMoveAnim(absolutePosition, score,
            color: const Color.fromARGB(255, 232, 0, 0)));
        game.myWorld
            .add(BoomEffectComponent(sizeParent, absolutePosition, score));
      }));
    }));
  }

  void hide() {
    setColor(Colors.transparent);
  }

  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);
  //   // Ensure the component size is set correctly
  //   final paint = Paint()..color = const Color.fromARGB(255, 76, 189, 119);
  //   canvas.drawRect(size.toRect(), paint);
  // }
}

class PalleComponent extends PositionComponent {
  final Vector2 sizeParent;
  final Function() onComplete;

  PalleComponent(Vector2 position, this.sizeParent, this.onComplete)
      : super(
            priority: 10,
            position: position,
            anchor: Anchor.topCenter,
            size: Vector2(sizeParent.x * 0.81, sizeParent.x * 1.09));
  @override
  FutureOr<void> onLoad() {
    position = position - Vector2(sizeParent.x / 2, size.y / 1.5);
    add(Paddle(
      size,
      () {
        this.removeFromParent();
        onComplete();
      },
    ));
    return super.onLoad();
  }

  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);
  //   // Ensure the component size is set correctly
  //   final paint = Paint()..color = const Color.fromARGB(255, 76, 189, 119);
  //   canvas.drawRect(size.toRect(), paint);
  // }
}

class Paddle extends SpriteComponent with HasGameReference<MoleGame> {
  final Vector2 sizeParent;
  final Function() onComplete;

  Paddle(
    this.sizeParent,
    this.onComplete,
  ) : super(
            anchor: Anchor.bottomLeft,
            position: Vector2(0, -4),
            size: Vector2(sizeParent.x, sizeParent.y),
            sprite: Sprite(Flame.images.fromCache(
              'event/event_tet2026/icon/paddle.png',
            )));
  @override
  FutureOr<void> onLoad() {
    angle = -math.pi / 4;
    position = Vector2(0, size.y - 4);
    add(RotateEffect.by(
        math.pi / 3,
        EffectController(
            duration: durations[3], curve: Curves.easeInOutCubicEmphasized),
        onComplete: onComplete));
    return super.onLoad();
  }

  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);
  //   // Ensure the component size is set correctly
  //   final paint = Paint()..color = const Color.fromARGB(255, 76, 189, 119);
  //   canvas.drawRect(size.toRect(), paint);
  // }
}

class PaddleEffect extends SpriteComponent with HasGameReference<MoleGame> {
  final Vector2 sizeParent;

  PaddleEffect(
    this.sizeParent,
  ) : super(
            // anchor: Anchor.topCenter,
            size: Vector2(
                sizeParent.x * 0.84 - 4, sizeParent.x * 1.06 * 0.78 - 6),
            sprite: Sprite(Flame.images.fromCache(
              'event/event_tet2026/effect/paddle_collider.png',
            )));
  @override
  FutureOr<void> onLoad() {
    position = Vector2((sizeParent.x - size.x) / 2, -size.y / 2);
    hide();
  }

  void show() {
    setColor(Colors.black);
  }

  void hide() {
    setColor(Colors.transparent);
  }
  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);
  //   // Ensure the component size is set correctly
  //   final paint = Paint()..color = const Color.fromARGB(255, 76, 189, 119);
  //   canvas.drawRect(size.toRect(), paint);
  // }
}

class BoomEffectComponent extends SpriteAnimationComponent
    with HasGameReference<MoleGame> {
  final Vector2 sizeParent;
  final Vector2 positionEffect;

  final int scoreText;
  BoomEffectComponent(this.sizeParent, this.positionEffect, this.scoreText)
      : super(
          priority: 3,
          position: positionEffect,
          anchor: Anchor.center,
          size: Vector2(sizeParent.y, sizeParent.y),
        );
  double stepTime = 0.15;
  @override
  Future<void> onLoad() async {
    FlameAudio.play('boom.mp3');
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('event/event_tet2026/effect/boom.png'),
      SpriteAnimationData.sequenced(
        loop: false,
        amount: 5,
        stepTime: stepTime,
        textureSize: Vector2(190, 190),
      ),
    );

    // Load the sprite sheet
    final effect2 = SequenceEffect([
      ScaleEffect.by(
        Vector2.all(2.7),
        EffectController(
          duration: stepTime * 5,
          curve: Curves.easeOutBack,
        ),
      ),
      OpacityEffect.fadeOut(EffectController(duration: stepTime * 2),
          onComplete: () {}),
      RemoveEffect(onComplete: () {}),
    ]);
    add(effect2);
  }
}

class TextSizeAnim extends TextComponent with HasGameReference<MoleGame> {
  final Vector2 positionParam;

  final int score;
  TextSizeAnim(this.positionParam, this.score)
      : super(
          anchor: Anchor.center,
          priority: 4,
        );
  @override
  Future<void> onLoad() async {
    if (score > 0) {
      text = '+$score';
    } else {
      text = '$score';
    }

    textRenderer = TextPaint(
      style: TextStyle(
        fontSize: 28,
        fontFamily: fontGame,
        fontWeight: FontWeight.bold,
      ),
    );
    scale = Vector2.all(0.9);
    position = Vector2(positionParam.x + size.x, positionParam.y + size.y / 2);
    add(ScaleEffect.by(Vector2.all(1.05), EffectController(duration: 0.5),
        onComplete: () {
      removeFromParent();
    }));
  }
}

class TextMoveAnim extends TextComponent with HasGameReference<MoleGame> {
  final int score;
  final Color color;
  TextMoveAnim(Vector2 position, this.score, {this.color = Colors.white})
      : super(
          position: position,
          priority: 4,
        );
  Timer? countdown;
  double time = 0.8;
  @override
  Future<void> onLoad() async {
    countdown = Timer(time, autoStart: false, onTick: () {});
    if (score > 0) {
      text = '+$score';
    } else {
      text = '$score';
    }
    // text = '$score';

    anchor = Anchor.center;
    textRenderer = TextPaint(
      style: TextStyle(
        fontSize: textSize[0],
        fontFamily: fontGame,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );

    add(MoveEffect.to(
        game.staticPointPosi + Vector2(textSize[1] / 2, textSize[1] / 2 + 6),
        EffectController(duration: time, curve: Curves.easeInOutQuart),
        onComplete: () {
      removeFromParent();
    }));

    countdown?.start();
  }

  @override
  void update(double dt) {
    countdown?.update(dt);
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    textRenderer = TextPaint(
      style: TextStyle(
        fontSize: textSize[0] +
            (textSize[1] - textSize[0]) * (countdown?.current ?? 0) +
            (1 - time),
        color: color,
        fontWeight: FontWeight.bold,
        fontFamily: 'DVN',
      ),
    );

    super.render(canvas);
  }
}

class StarComponent extends SpriteComponent with HasGameReference<MoleGame> {
  StarComponent(Vector2 position)
      : super(
            priority: 4,
            size: Vector2.all(20),
            position: position,
            anchor: Anchor.center,
            sprite: Sprite(Flame.images.fromCache(
              'event/event_tet2026/icon/star.png',
            )));
  double time = 0.4;
  @override
  FutureOr<void> onLoad() {
    final effect1 = SequenceEffect([
      MoveEffect.by(
        Vector2(0, -54),
        EffectController(
          duration: time,
          curve: Curves.elasticInOut,
        ),
      ),
      RotateEffect.by(
        pi * 2,
        EffectController(duration: time * 2, alternate: true),
      ),
    ]);
    final effect2 = SequenceEffect([
      ScaleEffect.by(
        Vector2.all(1.8),
        EffectController(
          duration: time,
          alternate: true,
          curve: Curves.fastOutSlowIn,
        ),
      ),
      MoveEffect.to(
        game.staticStarPosi,
        EffectController(
          duration: time,
        ),
      ),
      RemoveEffect(),
    ]);
    add(effect1);
    add(effect2);
    return super.onLoad();
  }

  double rotationY = 0;

  @override
  void update(double dt) {
    rotationY += dt * 2;
    final m = transform.transformMatrix;
    m.setIdentity();
    m.translate(position.x, position.y);
    m.translate(size.x / 2, size.y / 2);
    m.setEntry(3, 2, 0.001);
    m.rotateY(rotationY);
    m.translate(-size.x / 2, -size.y / 2);
    super.update(dt);
  }
}

class MyParallaxComponent extends ParallaxComponent<MoleGame> {
  @override
  Future<void> onLoad() async {
    parallax = await game.loadParallax([
      ParallaxImageData('parallax/layer_1.jpg'),
      ParallaxImageData('parallax/layer_2.png'),
    ]);
  }
}

class BlingComponent extends SpriteComponent with HasGameReference<MoleGame> {
  final Vector2 sizeParent;

  BlingComponent(
    this.sizeParent,
  ) : super();
  Timer? interval;
  @override
  Future<void> onLoad() async {
    final double intervalDuration = game.myWorld.random.nextDouble() * 3 + 3.0;

    final double randomSize = game.myWorld.random.nextInt(10) + 8;
    size = Vector2.all(randomSize);

    sprite =
        Sprite(Flame.images.fromCache('event/event_tet2026/icon/bling.png'));
    randomPosition(randomSize);

    interval = Timer(
      intervalDuration,
      onTick: () => {
        _toTransparent(randomSize),
        interval?.pause(),
      },
      autoStart: true,
      repeat: true,
    );
  }

  _toTransparent(double randomSize) {
    final toTransparent =
        OpacityEffect.to(0.1, EffectController(duration: 0.5), onComplete: () {
      randomPosition(randomSize);
      // add(toFullColor);
      _toFullColor();
    });
    add(toTransparent);
  }

  _toFullColor() {
    final toFullColor =
        OpacityEffect.to(1, EffectController(duration: 0.5), onComplete: () {
      interval?.resume();
    });
    add(toFullColor);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _accumulator += dt;

    while (_accumulator >= fixedDt) {
      fixedUpdate(fixedDt);
      _accumulator -= fixedDt;
    }
  }

  void fixedUpdate(double dt) {
    interval?.update(dt);
  }

  void randomPosition(double randomSize) {
    final double randomX =
        game.myWorld.random.nextDouble() * (sizeParent.x - randomSize / 2);
    final double randomY =
        game.myWorld.random.nextDouble() * (sizeParent.y - randomSize * 2) +
            randomSize;
    position = Vector2(randomX, randomY);
  }
}
