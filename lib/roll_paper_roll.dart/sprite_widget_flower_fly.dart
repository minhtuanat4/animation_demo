import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

import 'main_holiday.dart';

class SnowWorld extends NodeWithSize {
  late SnowNode snow;

  SnowWorld() : super(const Size(414, 896)) {
    snow = SnowNode();

    snow.active(true);
    addChild(snow);
  }
}

class SnowNode extends Node {
  final rand = Random();
  int ranDomCustom(int min, int max) => min + rand.nextInt(max - min);
  SnowNode() {
    final random = ranDomCustom(150, 250);

    _addParticles(
        SpriteTexture(imageMap['assets/images/canh_hoa_2.png']!), 2, random);
    _addParticles(
        SpriteTexture(imageMap['assets/images/canh_hoa_2.png']!), 1.5, random);

    _addParticles(
        SpriteTexture(imageMap['assets/images/canh_hoa_3.png']!), 2, random);
    _addParticles(
        SpriteTexture(imageMap['assets/images/canh_hoa_4.png']!), 1, random);
    _addParticles(
        SpriteTexture(imageMap['assets/images/canh_hoa_5.png']!), 1, random);
    _addParticles(
        SpriteTexture(imageMap['assets/images/canh_hoa_6.png']!), 1.5, random);
  }

  final _particles = <ParticleSystem>[];

  void _addParticles(
    SpriteTexture texture,
    double distance,
    int speed,
  ) {
    final particles = ParticleSystem(
        blendMode: BlendMode.srcATop,
        posVar: const Offset(1300, 0),
        direction: 90,
        directionVar: 0,
        speed: speed / distance,
        speedVar: speed / distance,
        startSize: 1.0 / distance,
        startSizeVar: 0.3 / distance,
        endSize: 1.2 / distance,
        endSizeVar: 0.2 / distance,
        life: 30.0 * distance,
        lifeVar: 10.0 * distance,
        emissionRate: 0.8,
        startRotationVar: 360,
        endRotationVar: 360,
        radialAccelerationVar: 10.0 / distance,
        tangentialAccelerationVar: 10.0 / distance,
        texture: texture)
      ..position = const Offset(0, 0)
      // ..startSize = 0.1
      // ..startSizeVar = 0.15
      // ..endSize = 0.1
      // ..endSizeVar = 0.15
      ..scaleX = 0.3
      ..scaleY = 0.3
      ..opacity = 0.0;

    _particles.add(particles);
    addChild(particles);
  }

  void active(bool active) {
    motions.stopAll();
    for (final system in _particles) {
      if (active) {
        motions.run(MotionTween<double>(
            setter: (a) => system.opacity = a,
            start: system.opacity,
            end: 1,
            duration: 2));
      } else {
        motions.run(MotionTween<double>(
            setter: (a) => system.opacity = a,
            start: system.opacity,
            end: 0,
            duration: 0.5));
      }
    }
  }
}
