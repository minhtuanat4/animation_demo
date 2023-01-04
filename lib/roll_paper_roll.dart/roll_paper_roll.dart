import 'dart:ui';
import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' as material;

import 'main_holiday.dart';

class RollPaperRoll extends FlameGame with HasTappables {
  final Size sizeBg;
  static const _imageAssets = [
    'roll_paper_roll/home_view_1.jpg',
    'roll_paper_roll/home_view_2.jpg',
    'roll_paper_roll/home_view_3.jpg',
    'roll_paper_roll/home_view_4.jpg',
    'roll_paper_roll/meo_0.png',
    'roll_paper_roll/meo_1.png',
    'roll_paper_roll/meo_2.png',
    'roll_paper_roll/meo_3.png',
    'roll_paper_roll/meo_4.png',
    'roll_paper_roll/meo_5.png',
    'roll_paper_roll/meo_6.png',
    'roll_paper_roll/meo_7.png',
    'roll_paper_roll/meo_8.png',
    'roll_paper_roll/meo_9.png',
    'roll_paper_roll/meo_10.png',
    'roll_paper_roll/icon_lich_su.png',
    'roll_paper_roll/icon_giai_thuong.png',
    'roll_paper_roll/icon_nhiem_vu.png',
    'roll_paper_roll/icon_the_le.png',
    'roll_paper_roll/sao_nhap_nhay.png',
    'roll_paper_roll/light_frame_1.png',
    'roll_paper_roll/light_frame_2.png',
  ];
  late SpriteAnimationComponent _catSpriteAnimation;
  // late SpriteAnimationComponent _lightFrameSpriteAnimation;

  late IconGame _iconLichSu;
  late IconGame _iconGiaiThuong;
  late IconGame _icoNhiemVu;
  late IconGame _iconTheLe;

  late GlowLight _glowLight;

  void initIconGame() {
    final sizeIcon = Vector2(sizeBg.width * 154 / bgDimention.x,
        sizeBg.height * 166 / bgDimention.y);
    final sizeIconGiaithuong = Vector2(sizeBg.width * 160 / bgDimention.x,
        sizeBg.height * 165 / bgDimention.y);
    final sizeIconThele = Vector2(sizeBg.width * 164 / bgDimention.x,
        sizeBg.height * 158 / bgDimention.y);
    final sizeIconNhiemvu = Vector2(sizeBg.width * 172 / bgDimention.x,
        sizeBg.height * 167 / bgDimention.y);
    final marginHeightIcon = sizeBg.height * 1950 / bgDimention.y;
    _iconLichSu = IconGame(
        imageIcon: images.fromCache('roll_paper_roll/icon_giai_thuong.png'),
        positionIcon:
            Vector2(sizeBg.width * 80 / bgDimention.x, marginHeightIcon),
        sizeIcon: sizeIconGiaithuong);
    _iconGiaiThuong = IconGame(
        imageIcon: images.fromCache('roll_paper_roll/icon_lich_su.png'),
        positionIcon: Vector2(
            sizeBg.width * (80 + 315) / bgDimention.x, marginHeightIcon),
        sizeIcon: sizeIcon);
    _icoNhiemVu = IconGame(
        imageIcon: images.fromCache('roll_paper_roll/icon_nhiem_vu.png'),
        positionIcon: Vector2(
            sizeBg.width * (80 + 610) / bgDimention.x, marginHeightIcon),
        sizeIcon: sizeIconNhiemvu);
    _iconTheLe = IconGame(
        imageIcon: images.fromCache('roll_paper_roll/icon_the_le.png'),
        positionIcon: Vector2(
            sizeBg.width * (80 + 930) / bgDimention.x, marginHeightIcon),
        sizeIcon: sizeIconThele);
  }

  Future<void> _initCatSpriteAnimation() async {
    final sprites = List.generate(11, (index) => index)
        .map((i) => Sprite.load('roll_paper_roll/meo_$i.png'));
    final animation = SpriteAnimation.spriteList(
      await Future.wait(sprites),
      stepTime: 0.18,
      loop: false,
    );
    _catSpriteAnimation = SpriteAnimationComponent(
        animation: animation,
        size: Vector2(sizeBg.width * 551 / bgDimention.x,
            sizeBg.height * 624 / bgDimention.y),
        position: Vector2(sizeBg.width * 650 / bgDimention.x,
            sizeBg.height * 1080 / bgDimention.y),
        anchor: Anchor.topLeft);
  }

  RollPaperRoll(this.sizeBg);
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await Flame.device.fullScreen();
    await Flame.device.setPortrait();
    await images.loadAll(_imageAssets);
    await _initCatSpriteAnimation();
    // await _initLightFrame();
    initIconGame();
    _glowLight = GlowLight(
      positionGlowLight: Vector2(20, 30),
      imageGlowLight: images.fromCache('roll_paper_roll/sao_nhap_nhay.png'),
      sizeGlowLight: Vector2(sizeBg.width * 749 / bgDimention.x,
          sizeBg.height * 468 / bgDimention.y),
    );
  }

  @override
  Color backgroundColor() => material.Colors.transparent;
  @override
  void onMount() {
    super.onMount();
    // add(_lightFrameSpriteAnimation);
    add(_catSpriteAnimation);
    add(_iconLichSu);
    add(_iconGiaiThuong);
    add(_icoNhiemVu);
    add(_iconTheLe);
    add(_glowLight);
  }
}

class CustomSpriteAnimation extends SpriteAnimationComponent with Tappable {
  @override
  bool onTapDown(TapDownInfo info) {
    // TODO: implement onTapDown
    return super.onTapDown(info);
  }
}

class GlowLight extends SpriteComponent {
  final Image imageGlowLight;
  final Vector2 positionGlowLight;
  final Vector2 sizeGlowLight;
  final _timer = Timer(1, repeat: true);

  GlowLight(
      {required this.sizeGlowLight,
      required this.positionGlowLight,
      required this.imageGlowLight})
      : super(
          sprite: Sprite(imageGlowLight),
          position: positionGlowLight,
          size: sizeGlowLight,
        );
  int countTimer = 0;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    _timer.onTick = onTick;
  }

  void onTick() {
    countTimer++;

    if (countTimer == 1) {
      setOpacity(1);
      position = Vector2(positionGlowLight.x - 15, positionGlowLight.y - 10);
    } else if (countTimer == 2) {
      position = Vector2(positionGlowLight.x, positionGlowLight.y - 15);
    } else {
      countTimer = 0;
      position = positionGlowLight;
      final effectDisappear = OpacityEffect.to(
        0.2,
        EffectController(duration: 0.75),
      )..removeOnFinish = true;
      add(effectDisappear);
    }
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);
  }
}

class IconGame extends SpriteComponent
    with Tappable, HasGameRef<RollPaperRoll> {
  final Image imageIcon;
  final Vector2 sizeIcon;
  final Vector2 positionIcon;
  final double speed = 15;
  late Vector2 limitPositionY;
  bool isDown = false;
  bool isForward = true;
  final timer = Timer(0.2, repeat: true);
  IconGame(
      {required this.imageIcon,
      required this.sizeIcon,
      required this.positionIcon})
      : super(
            sprite: Sprite(imageIcon),
            size: sizeIcon,
            anchor: Anchor.bottomCenter);
  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    position =
        Vector2(positionIcon.x + sizeIcon.x / 2, positionIcon.y + sizeIcon.y);
    limitPositionY = Vector2(position.y - 5, position.y + 5);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (position.y < limitPositionY.x) {
      isDown = true;
    } else if (position.y > limitPositionY.y) {
      isDown = false;
    }
    if (isDown) {
      position.y += speed * dt;
    } else {
      position.y -= speed * dt;
    }
    // if (angle < -(pi / 12)) {
    //   isForward = true;
    // } else if (angle > (pi / 12)) {
    //   isForward = false;
    // }
    // if (isForward) {
    //   angle += dt;
    // } else {
    //   angle -= dt;
    // }
  }

  @override
  bool onTapUp(TapUpInfo info) {
    print('object ---- ');
    return true;
  }
}
