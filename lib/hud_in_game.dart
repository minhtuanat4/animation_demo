import 'dart:async';

import 'package:animation_demo/common/color_extension.dart';
import 'package:animation_demo/custom_progress_indicator/custom_progress_indicator.dart'
    as Utils;
import 'package:animation_demo/flame_main.dart';
import 'package:animation_demo/model_game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
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

class TitleTextComponent extends TextComponent with HasGameReference<MoleGame> {
  TitleTextComponent(Vector2 position) : super(position: position);
  @override
  FutureOr<void> onLoad() {
    text = '';
    anchor = Anchor.center;
    textRenderer = TextPaint(
      style: TextStyle(
        fontSize: textSize[1],
        color: Colors.white,
        fontWeight: FontWeight.w900,
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    text = 'X${game.myWorld.countPerfect}';
    super.update(dt);
  }
}

class SubHubInGame extends PositionComponent with HasGameReference<MoleGame> {
  final Vector2 sizeParent;
  SubHubInGame(this.sizeParent) : super() {}
  double borderRadius = 12;
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
    add(TitleTextComponent(Vector2(size.x / 2, size.y + 28)));
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
