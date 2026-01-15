import 'dart:async';

import 'package:animation_demo/common/color_extension.dart';
import 'package:animation_demo/custom_progress_indicator/custom_progress_indicator.dart'
    as Utils;
import 'package:animation_demo/flame_main.dart';
import 'package:animation_demo/model_game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class HudInGame extends PositionComponent with HasGameReference<MoleGame> {
  HudInGame(this.sizeParent) : super() {}
  final Vector2 sizeParent;
  double borderRadius = 30;
  double heightPixel = 300;
  double heightPixelDefault = 264;
  double marginBetween = 28;
  @override
  FutureOr<void> onLoad() {
    size = Vector2(sizeParent.x, sizeParent.y * heightPixel / resolution.dy);
    final sizeBtnY = size.y * 82 / heightPixelDefault;
    add(SubHubInGame(size));
    addBackBtn();
    addTimeComponent(sizeBtnY);
    addPointComponent(sizeBtnY);
    return super.onLoad();
  }

  addBackBtn() {
    add(BackComponent(Vector2.all(size.y * 80 / heightPixelDefault),
        Vector2.all(size.y * 40 / heightPixelDefault)));
  }

  addTimeComponent(double sizeBtnY) {
    add(TimerComponent(Vector2(sizeBtnY * 280 / 80, sizeBtnY),
        Vector2(size.x / 2 + marginBetween / 2, size.y / 2)));
  }

  addPointComponent(double sizeBtnY) {
    final x = sizeBtnY * 280 / 80;
    add(PointComponent(Vector2(x, sizeBtnY),
        Vector2(size.x / 2 - x - marginBetween / 2, size.y / 2)));
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = const Color(0xFFA60000)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.x, 0)
      ..lineTo(size.x, size.y - borderRadius / 1)
      ..quadraticBezierTo(
        size.x,
        size.y,
        size.x - borderRadius,
        size.y,
      )
      ..lineTo(borderRadius, size.y)
      ..quadraticBezierTo(0, size.y, 0, size.y - borderRadius / 1)
      ..close();

    canvas.drawPath(path, paint);
  }
}

class TimerComponent extends SpriteComponent {
  TimerComponent(Vector2 size, Vector2 position)
      : super(
            size: size,
            position: position,
            sprite: Sprite(Flame.images.fromCache(
              'event/event_tet2026/button_form.png',
            )));

  @override
  FutureOr<void> onLoad() {
    final sizeClockX = size.y * 100 / 80;
    add(SpriteComponent(
        size: Vector2(sizeClockX, sizeClockX + 3),
        position: Vector2(-sizeClockX / 2.5, -(sizeClockX - size.y) / 2),
        sprite: Sprite(Flame.images.fromCache(
          'event/event_tet2026/icon/clock.png',
        ))));
    final point = TimerTextStatic(
      Vector2(size.x / 2 + textSize[1] / 2, size.y / 2),
      Vector2(size.x - 10, size.y),
    );
    add(point);
    return super.onLoad();
  }
}

class PointComponent extends SpriteComponent with HasGameReference<MoleGame> {
  PointComponent(Vector2 size, Vector2 position)
      : super(
            size: size,
            position: position,
            sprite: Sprite(Flame.images.fromCache(
              'event/event_tet2026/button_form.png',
            )));
  @override
  FutureOr<void> onLoad() {
    final sizeStarX = size.y * 100 / 80;
    final star = SpriteComponent(
        size: Vector2.all(sizeStarX),
        position: Vector2(-sizeStarX / 2.5, -(sizeStarX - size.y) / 1.8),
        sprite: Sprite(Flame.images.fromCache(
          'event/event_tet2026/icon/star.png',
        )));
    add(star);
    final point = PointTextStatic(
      Vector2(size.x / 2 + textSize[1] / 2, size.y / 2),
      Vector2(size.x - 10, size.y),
      0,
    );
    add(point);
    game.staticStarPosi =
        star.absolutePosition + Vector2(sizeStarX / 2, sizeStarX / 2);
    return super.onLoad();
  }
}

class PointTextStatic extends TextComponent with HasGameReference<MoleGame> {
  final int score;
  final Vector2 sizeParent;

  PointTextStatic(
    Vector2 position,
    this.sizeParent,
    this.score,
  ) : super(
          position: position,
        );
  late Timer countdown;
  IntTweenEffect? intTweenEffect;
  @override
  Future<void> onLoad() async {
    countdown = Timer(1, autoStart: false, onTick: () {});
    text = '$scoreĐ';
    anchor = Anchor.center;
    textRenderer = TextPaint(
      style: TextStyle(
        fontSize: textSize[1],
        color: HexColor.fromHex('#A0180B'),
        fontWeight: FontWeight.w900,
      ),
    );
    if (size.x > sizeParent.x - 12) {
      textRenderer = TextPaint(
        style: TextStyle(
          fontSize: ((sizeParent.x - 16) / size.x * textSize[1]),
          color: HexColor.fromHex('#A0180B'),
          fontWeight: FontWeight.w900,
        ),
      );
    }
    game.scoreNotify.addListener(() {
      var data = game.scoreNotify.value - game.scoreItem;
      intTweenEffect?.removeFromParent();
      // final data = game.scoreNotify.value - 20;
      intTweenEffect = IntTweenEffect(
          begin: 0,
          end: game.scoreItem,
          controller: EffectController(duration: 0.12),
          onUpdate: (value) {
            text = Utils.formatMoney((data).toInt() + value) + 'Đ';
          },
          onComplete: () {
            text = Utils.formatMoney((game.scoreNotify.value).toInt()) + 'Đ';
          });
      add(intTweenEffect!);
    });
  }

  @override
  void onMount() {
    game.staticPointPosi = absolutePosition;
    super.onMount();
  }

  @override
  void update(double dt) {
    countdown.update(dt);
    super.update(dt);
  }
}

class TimerTextStatic extends TextComponent with HasGameReference<MoleGame> {
  final Vector2 sizeParent;

  TimerTextStatic(
    Vector2 position,
    this.sizeParent,
  ) : super(
          position: position,
        );
  @override
  Future<void> onLoad() async {
    text = '${game.timerNotify.value}S';
    anchor = Anchor.center;
    textRenderer = TextPaint(
      style: TextStyle(
        fontSize: textSize[1],
        color: HexColor.fromHex('#A0180B'),
        fontWeight: FontWeight.w900,
      ),
    );
    game.timerNotify.addListener(() {
      text = '${game.timerNotify.value}S';
    });
  }
}

class IntTweenEffect extends Effect {
  final int begin;
  final int end;

  /// Called every frame
  final void Function(int value)? onUpdate;

  /// Called once when effect starts
  final VoidCallback? onStartCallback;

  /// Called once when effect finishes
  final VoidCallback? onComplete;

  bool _started = false;

  IntTweenEffect({
    required this.begin,
    required this.end,
    required EffectController controller,
    this.onUpdate,
    this.onStartCallback,
    this.onComplete,
  }) : super(controller);

  @override
  void apply(double progress) {
    // onStart (only once)
    if (!_started) {
      _started = true;
      onStartCallback?.call();
    }

    final value = begin + ((end - begin) * progress).round();

    onUpdate?.call(value);
  }

  @override
  void onFinish() {
    // Ensure final value is applied
    onUpdate?.call(end);

    onComplete?.call();
    super.onFinish();
  }
}

class BackComponent extends SpriteComponent {
  BackComponent(Vector2 size, Vector2 position)
      : super(
            size: size,
            position: position,
            sprite: Sprite(Flame.images.fromCache(
              'event/event_tet2026/icon/back.png',
            )));
}

class CountingPointComponent extends PositionComponent
    with HasGameReference<MoleGame> {
  final Vector2 sizeParent;

  CountingPointComponent(
    Vector2 position,
    this.sizeParent,
  ) : super(
          anchor: Anchor.center,
          position: position + Vector2(sizeParent.x / 4, sizeParent.y / 2 + 12),
          size: Vector2(sizeParent.y * 1.5 * 360 / 213, sizeParent.y * 1.5),
        );
  double padding = 4;
  double fontSize = 36;
  double opacity = 0.2;
  double durationEffect = 0.6;
  Curve curveEffect = Curves.bounceOut;

  double moveText = 12;
  // bool isFlame = true;
  TextComponent? txt1;
  TextComponent? txt2;
  SpriteComponent? flame;
  late Timer countdown;
  Timer? _timerForWaiting;
  @override
  Future<void> onLoad() async {
    // isFlame = game.countPerfectNotify.value > 2;
    // if (isFlame) {

    // } else {
    //   padding = 0;
    // }
    countdown = Timer(durationEffect);
    final sizeFlameY = size.y / 1.5;
    final sizeFlame = Vector2(sizeFlameY * 77 / 101, sizeFlameY);
    flame = SpriteComponent(
        anchor: Anchor.center,
        position: Vector2(size.x / 2, size.y / 2 - 4),
        size: sizeFlame,
        sprite: Sprite(Flame.images.fromCache(
          'event/event_tet2026/effect/flame.png',
        )));
    add(flame!
      ..setOpacity(opacity)
      ..position = flame!.position - Vector2(sizeFlame.x / 2 + padding, 0));
    txt1 = TextComponent(
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2 - padding),
      text: 'x${game.countPerfectNotify.value}',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: 'SVN',
          fontWeight: FontWeight.bold,
          letterSpacing: 3,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 5
            ..color = HexColor.fromHex('#A0180B').withOpacity(opacity),
        ),
      ),
    );
    // ..scale = Vector2(1, 0.1)
    // ..add(MoveEffect.by(Vector2(0, moveText),
    //     EffectController(duration: durationEffect, curve: curveEffect)))
    // ..add(ScaleEffect.to(
    //   Vector2.all(1),
    //   EffectController(duration: durationEffect, curve: curveEffect),
    // ));

    txt2 = TextComponent(
      text: 'x${game.countPerfectNotify.value}',
      textRenderer: TextPaint(
        style: TextStyle(
          letterSpacing: 3,
          fontSize: fontSize,
          fontFamily: 'SVN',
          color: Colors.white.withOpacity(opacity),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(txt1!
      ..add(txt2!)
      ..position = txt1!.position + Vector2(txt1!.size.x / 2 + padding, 0));

    scale = Vector2(1.8, 1.4);
    position = position + Vector2(0, moveText);

    countdown.start();
    add(MoveEffect.by(Vector2(0, -moveText),
        EffectController(duration: durationEffect, curve: curveEffect)));
    add(ScaleEffect.to(Vector2.all(1),
        EffectController(duration: durationEffect, curve: curveEffect),
        onComplete: () async {
      _timerForWaiting = Timer(
        0.3,
        onTick: () {
          add(ScaleEffect.to(
            Vector2(0, 0),
            EffectController(
                duration: durationEffect * 1.5,
                curve: Curves.easeInOutCubicEmphasized),
            onComplete: () {
              add(RemoveEffect());
            },
          ));
        },
      );
    }));
  }

  @override
  void update(double dt) {
    countdown.update(dt);
    _timerForWaiting?.update(dt);

    if (countdown.isRunning()) {
      double opacityEffect =
          ((1 - opacity) * countdown.current / durationEffect + opacity)
              .clamp(0, 1);

      txt1?.textRenderer = getTextPaint1(opacityEffect);
      txt2?.textRenderer = getTextPaint2(opacityEffect);
      flame?.setOpacity(opacityEffect);
    }
    super.update(dt);
  }

  TextPaint getTextPaint2(double opacity) {
    return TextPaint(
      style: TextStyle(
        letterSpacing: 3,
        fontSize: fontSize,
        fontFamily: 'SVN',
        color: Colors.white.withOpacity(opacity),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  TextPaint getTextPaint1(double opacity) {
    return TextPaint(
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: 'SVN',
        fontWeight: FontWeight.bold,
        letterSpacing: 3,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..color = HexColor.fromHex('#A0180B').withOpacity(opacity),
      ),
    );
  }
}

class CoolComponent extends SpriteComponent {
  CoolComponent(Vector2 position, Vector2 size)
      : super(
          anchor: Anchor.center,
          position: position,
          size: Vector2(size.x, size.x / 2.63),
          sprite: Sprite(
            Flame.images.fromCache(
              'event/event_tet2026/effect/cool_light.png',
            ),
          ),
        );
  double opacity = 0.5;
  double durationEffect = 0.5;
  Curve curveEffect = Curves.bounceOut;
  double opacityEffect = 0;
  @override
  FutureOr<void> onLoad() {
    final ratio = 2.5;
    setOpacity(opacityEffect);
    scale = Vector2(1.6, 1.4);
    position = position + Vector2(size.x / 2, 4);

    add(MoveEffect.by(Vector2(0, -4),
        EffectController(duration: durationEffect, curve: curveEffect)));
    add(ScaleEffect.to(Vector2.all(0.9),
        EffectController(duration: durationEffect, curve: curveEffect),
        onComplete: () {
      setOpacity(1);
      // add(ScaleEffect.to(
      //   Vector2(0.8, 0),
      //   EffectController(
      //       duration: durationEffect, curve: Curves.easeInOutCubicEmphasized),
      //   onComplete: () {},
      // ));
    }));
    add(
      SpriteComponent(
        position: Vector2(size.x / 2 + 4, size.y / 2 + 4),
        anchor: Anchor.center,
        size: Vector2(size.y / ratio * 2.42, size.y / ratio),
        sprite: Sprite(
          Flame.images.fromCache(
            'event/event_tet2026/effect/cool.png',
          ),
        ),
      )
        ..setOpacity(opacity)
        ..add(OpacityEffect.to(
            1, EffectController(duration: durationEffect, curve: curveEffect))),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    opacityEffect += dt / durationEffect / 1.5;
    if (opacityEffect < 0.99) {
      setOpacity(opacityEffect);
    }
    super.update(dt);
  }
}

class PerfectComponent extends SpriteComponent with HasGameReference<MoleGame> {
  PerfectComponent(Vector2 position, Vector2 size)
      : super(
          anchor: Anchor.center,
          position: position,
          size: Vector2(size.x, size.x / 2.55),
          sprite: Sprite(
            Flame.images.fromCache(
              'event/event_tet2026/effect/perfect_light.png',
            ),
          ),
        );
  double opacity = 0.1;
  double durationEffect = 0.6;
  Curve curveEffect = Curves.bounceOut;
  late Timer countdown;
  Timer? _timerForWaiting;
  @override
  FutureOr<void> onLoad() {
    FlameAudio.play('perfect4.mp3');
    countdown = Timer(durationEffect);
    final ratio = 2.3;

    scale = Vector2(2, 1.8);
    position = position + Vector2(size.x / 2, 10);
    countdown.start();
    add(MoveEffect.by(Vector2(0, -4),
        EffectController(duration: durationEffect, curve: curveEffect)));
    add(ScaleEffect.to(Vector2.all(1),
        EffectController(duration: durationEffect, curve: curveEffect),
        onComplete: () async {
      _timerForWaiting = Timer(
        0.3,
        onTick: () {
          add(ScaleEffect.to(
            Vector2(0.8, 0),
            EffectController(
                duration: durationEffect * 1.5,
                curve: Curves.easeInOutCubicEmphasized),
            onComplete: () {
              add(RemoveEffect());
            },
          ));
        },
      );
    }));
    final perfectX = size.y / ratio * 4.1;
    add(
      SpriteComponent(
        position: Vector2(size.x / 2 + 4, size.y / 2 + 4),
        anchor: Anchor.center,
        size: Vector2(perfectX, size.y / ratio),
        sprite: Sprite(
          Flame.images.fromCache(
            'event/event_tet2026/effect/perfect.png',
          ),
        ),
      )
        ..add(TextComponent(
          anchor: Anchor.center,
          position: Vector2(perfectX + 20, 4),
          text: 'x${game.countPerfectNotify.value}',
          textRenderer: TextPaint(
            style: TextStyle(
              letterSpacing: 1,
              fontSize: 24,
              fontFamily: 'SVN',
              color: Colors.yellowAccent,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 7.0,
                  color: Colors.black38,
                ),
              ],
            ),
          ),
        ))
        ..setOpacity(opacity)
        ..add(OpacityEffect.to(
            1, EffectController(duration: durationEffect, curve: curveEffect))),
    );
    setOpacity(opacity);
    // countdown.progress
    return super.onLoad();
  }

  @override
  void update(double dt) {
    countdown.update(dt);
    _timerForWaiting?.update(dt);

    if (countdown.isRunning()) {
      setOpacity(((1 - opacity) * countdown.current / durationEffect + opacity)
          .clamp(0, 1));
    }

    super.update(dt);
  }
}

class SubHubInGame extends PositionComponent with HasGameReference<MoleGame> {
  final Vector2 sizeParent;
  SubHubInGame(this.sizeParent) : super() {}
  double borderRadius = 12;
  PerfectComponent? perfectComp;
  CountingPointComponent? countingComp;
  // CoolComponent? coolComponent;
  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.topCenter;
    final x = sizeParent.x * 626 / resolution.dx;
    size = Vector2(x, x * 106 / 620);
    position = Vector2(sizeParent.x / 2, sizeParent.y + 4);
    final List<MoleType> list = [
      MoleType.normal,
      MoleType.gold,
      MoleType.bomber
    ];
    for (var i = 0; i < list.length; i++) {
      add(Item(Vector2((size.x / 3 - 9) * i, 0), list[i],
          Vector2(size.x / 3 - 6, size.y)));
    }
    // countingComp =
    //     CountingPointComponent(Vector2(size.x / 4, size.y + 4), size);
    // add(countingComp!);
    // add(TitleTextComponent(Vector2(size.x / 2, size.y + 28)));
    // add(CoolComponent(Vector2(0, size.y + 32), size));
    // countingComp = CountingPointComponent(Vector2(size.x / 4, size.y), size);
    // add(countingComp!);
    // perfectComp = PerfectComponent(Vector2(0, size.y + 28), size);
    // add(perfectComp!);
    game.countPerfectNotify.addListener(() {
      final count = game.countPerfectNotify.value;
      perfectComp?.removeFromParent();
      // coolComponent?.removeFromParent();
      countingComp?.removeFromParent();
      // if (count == 5) {
      // coolComponent = CoolComponent(Vector2(0, size.y + 28), size);
      // add(coolComponent!);
      // } else
      if (count >= 10) {
        perfectComp = PerfectComponent(Vector2(0, size.y + 28), size);
        add(perfectComp!);
      } else if (count > 2) {
        countingComp =
            CountingPointComponent(Vector2(size.x / 4, size.y), size);
        add(countingComp!);
      }
    });

    return super.onLoad();
  }

  final shadowOffset = Vector2(0, 3);
  final blur = 1.0;

  @override
  void render(Canvas canvas) {
    final rrect = RRect.fromRectAndRadius(
      size.toRect(),
      Radius.circular(borderRadius),
    );
    final baseRect = size.toRect();
    final shadowRect = baseRect.shift(
      Offset(
        shadowOffset.x,
        shadowOffset.y,
      ),
    );

    final shadowRRect = RRect.fromRectAndRadius(
      shadowRect,
      Radius.circular(borderRadius),
    );

    canvas.drawRRect(
      shadowRRect,
      Paint()
        ..color = Colors.white
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          blur,
        ),
    );
    canvas.drawRRect(
        rrect,
        Paint()
          ..color = HexColor.fromHex('A1682A')
          ..style = PaintingStyle.fill);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = HexColor.fromHex('EAC484')
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }
}

class Item extends PositionComponent with HasGameReference<MoleGame> {
  final MoleType moleType;
  final Vector2 sizeItem;
  Item(Vector2 position, this.moleType, this.sizeItem)
      : super(
          position: position,
        );
  double timeEffect = 0.12;
  double sizeScale = 1.7;
  @override
  FutureOr<void> onLoad() {
    switch (moleType) {
      case MoleType.normal:
        final objectY = sizeItem.y * 68 / 106;
        final objectX = objectY - 2;
        position = position +
            Vector2((sizeItem.x - objectX) / 2, (sizeItem.y - objectY) / 2);
        final text =
            TextStatic(Vector2(objectX + 3, objectY / 2), sizeItem, moleType);
        add(SpriteComponent(
            size: Vector2(objectX, objectY),
            sprite: Sprite(Flame.images.fromCache(
              'event/event_tet2026/animal/7_normal.png',
            )))
          ..add(text));
        game.normalNotify.addListener(() {
          _textAnim(text, game.normalNotify.value.toString());
        });
        break;
      case MoleType.gold:
        final objectY = sizeItem.y * 62 / 106;
        final objectX = objectY * 92 / 50;
        position = position +
            Vector2(
                (sizeItem.x - objectX) / 2 - 2, (sizeItem.y - objectY) / 2 + 2);
        final text =
            TextStatic(Vector2(objectX - 2, objectY / 2), sizeItem, moleType);
        final gold = SpriteComponent(
            size: Vector2(objectX, objectY),
            sprite: Sprite(Flame.images.fromCache(
              'event/event_tet2026/icon/gold.png',
            )));
        add(gold..add(text));
        print(gold.absolutePosition);
        goldHud = gold.absolutePosition;
        game.goldNotify.addListener(() {
          _textAnim(text, game.goldNotify.value.toString());
        });
        break;
      case MoleType.bomber:
        final objectY = sizeItem.y * 72 / 106;
        final objectX = objectY * 67 / 84;

        position = position +
            Vector2(
                (sizeItem.x - objectX) / 2 + 2, (sizeItem.y - objectY) / 2 - 2);
        final text =
            TextStatic(Vector2(objectX + 3, objectY / 2), sizeItem, moleType);
        final sprite = SpriteComponent(
            size: Vector2(objectX, objectY),
            sprite: Sprite(
                Flame.images.fromCache('event/event_tet2026/icon/boom.png')));
        add(
          sprite..add(text),
        );
        game.boomNotify.addListener(() {
          sprite.add(ScaleEffect.by(
            Vector2.all(1.5),
            EffectController(
              duration: timeEffect,
              alternate: true,
            ),
          ));
          text.text = game.boomNotify.value.toString();
        });
        break;
      default:
    }

    return super.onLoad();
  }

  _textAnim(TextStatic text, String value) {
    text.add(ScaleEffect.by(
      Vector2.all(sizeScale),
      EffectController(
        duration: timeEffect,
        alternate: true,
        curve: Curves.easeOutBack,
      ),
    ));
    text.text = value;
  }
}

class TextStatic extends TextComponent with HasGameReference<MoleGame> {
  final Vector2 sizeParent;
  final MoleType moleType;

  TextStatic(
    Vector2 position,
    this.sizeParent,
    this.moleType,
  ) : super(
          position: position,
        );
  @override
  Future<void> onLoad() async {
    text = '${0}';
    anchor = Anchor.center;
    textRenderer = TextPaint(
      style: TextStyle(
        fontSize: 24,
        color: Colors.white,
        fontFamily: fontGame,
        fontWeight: FontWeight.w900,
      ),
    );
    if (moleType == MoleType.gold) {
      position.y = position.y - size.y / 2;
    } else {
      position.y = position.y - size.y / 3;
    }
    position = position + size / 2;
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);
  //   // Ensure the component size is set correctly
  //   final paint = Paint()..color = const Color.fromARGB(255, 204, 191, 0);
  //   canvas.drawRect(size.toRect(), paint);
  // }
}
