import 'dart:math';

import 'package:flutter/material.dart';

const List<Offset> dimensions = [
  Offset(-0.04, 0.14),
  Offset(0.01, 0.12),
  Offset(0.07, 0.1),
  Offset(0.07, 0.15),
  //
  Offset(0.13, 0.1),
  Offset(0.02, 0.2),
  Offset(-0.04, 0.2),
  Offset(-0.01, 0.14),
  //
  Offset(-0.02, 0.1),
  Offset(0.03, 0.05),
  Offset(-.08, 0.1),
  Offset(0, 0.2),
];

const List<Offset> resolutionAnimals = [
  Offset(174, 223),
  Offset(168, 230),
  Offset(164, 230),
  Offset(180, 225),
  //
  Offset(174, 235),
  Offset(164, 210),
  Offset(186, 237),
  Offset(235, 239),
  //
  Offset(172, 236),
  Offset(152, 226),
  Offset(176, 224),
  Offset(150, 180),
];
const List<int> marginAnimals = [
  0,
  -4,
  3,
  1,
  -6,
  3,
  3,
  -2,
  -2,
  2,
  0,
  5,
];
List<String> lstMole = [
  'event/event_tet2026/animal/ball.png',
  'event/event_tet2026/animal/bling.png',
  'event/event_tet2026/animal/bottom_bling.png',

  'event/event_tet2026/animal/1_normal.png',
  'event/event_tet2026/animal/1_cry.png',
//
  'event/event_tet2026/animal/2_normal.png',
  'event/event_tet2026/animal/2_cry.png',
//
  'event/event_tet2026/animal/3_normal.png',
  'event/event_tet2026/animal/3_cry.png',
//
  'event/event_tet2026/animal/4_normal.png',
  'event/event_tet2026/animal/4_cry.png',
  //
  'event/event_tet2026/animal/5_normal.png',
  'event/event_tet2026/animal/5_cry.png',
//
  'event/event_tet2026/animal/6_normal.png',
  'event/event_tet2026/animal/6_cry.png',
//
  'event/event_tet2026/animal/7_normal.png',
  'event/event_tet2026/animal/7_cry.png',
//
  'event/event_tet2026/animal/8_normal.png',
  'event/event_tet2026/animal/8_cry.png',
//
  'event/event_tet2026/animal/9_normal.png',
  'event/event_tet2026/animal/9_cry.png',
//
  'event/event_tet2026/animal/10_normal.png',
  'event/event_tet2026/animal/10_cry.png',
//
  'event/event_tet2026/animal/11_normal.png',
  'event/event_tet2026/animal/11_cry.png',
//
  'event/event_tet2026/animal/12_normal.png',
  'event/event_tet2026/animal/12_cry.png',

//
];
List<String> lstVase = [
  'event/event_tet2026/chau_vang1.png',
  'event/event_tet2026/chau_vang2.png',
  'event/event_tet2026/chau_vang3.png',
  'event/event_tet2026/fx_normal.png',
  'event/event_tet2026/fx_none.png',
  'event/event_tet2026/fx_bomber.png',
  'event/event_tet2026/soluot.png',
  'event/event_tet2026/thunder_storm.png',
  'event/event_tet2026/wood_bar.png',
  'event/event_tet2026/bg_game.jpg',
  'event/event_tet2026/expand_light.jpg',
  'event/event_tet2026/button_form.png',
];
List<String> lstIcon = [
  'event/event_tet2026/icon/paddle.png',
  'event/event_tet2026/icon/gold.png',
  'event/event_tet2026/icon/boom.png',
  'event/event_tet2026/icon/bling.png',
  'event/event_tet2026/icon/back.png',
  'event/event_tet2026/icon/star.png',
  'event/event_tet2026/icon/clock.png',
];
List<String> lstEffect = [
  'event/event_tet2026/effect/paddle_collider.png',
  'event/event_tet2026/effect/boom.png',
  'event/event_tet2026/effect/otc.png',
  'event/event_tet2026/effect/perfect_light.png',
  'event/event_tet2026/effect/perfect.png',
  'event/event_tet2026/effect/cool.png',
  'event/event_tet2026/effect/cool_light.png',
  'event/event_tet2026/effect/xtime_light.png',
  'event/event_tet2026/effect/flame.png',
];

enum MoleType {
  normal,
  bomber,
  gold,
  none,
  ball;

  const MoleType();
}

class MoleModel {
  int index;
  MoleType type;
  bool isVisible;
  bool isTapped;
  bool isAnimating; // thêm cờ này
  String imagePath;
  int score = 0;
  Offset dimension;
  Offset resolution;
  int margin = 0;

  String cryImagePath;
  MoleModel({
    this.index = 0,
    this.type = MoleType.none,
    this.isVisible = false,
    this.isTapped = false,
    this.isAnimating = false,
    this.imagePath = 'event/event_tet2026/animal/1_normal.png',
    this.cryImagePath = '',
    this.dimension = Offset.zero,
    this.resolution = Offset.zero,
  });

  void makeMoleModel(MoleType typeParam, int num) {
    switch (typeParam) {
      case MoleType.bomber:
        type = MoleType.bomber;
        score = -20;
        break;
      case MoleType.gold:
        type = MoleType.gold;

        score = 50;
        break;
      case MoleType.normal:
        type = MoleType.normal;
        score = 10;
        break;
      default:
    }
    margin = marginAnimals[num - 1];
    this.resolution = resolutionAnimals[num - 1];
    imagePath = 'event/event_tet2026/animal/${num}_normal.png';
    this.dimension = dimensions[num - 1];

    cryImagePath = 'event/event_tet2026/animal/${num}_cry.png';
    // isVisible = true;
    isTapped = false;
    isAnimating = true;
    isVisible = true;
  }

  void randomGoodData() {
    final r = Random().nextInt(100); // 0 – 99
    final num = Random().nextInt(12) + 1;

    if (r < 70) {
      type = MoleType.normal;
      score = 10;
    } else {
      type = MoleType.gold;
      score = 50;
    }
    margin = marginAnimals[num - 1];
    this.resolution = resolutionAnimals[num - 1];
    imagePath = 'event/event_tet2026/animal/${num}_normal.png';
    this.dimension = dimensions[num - 1];
    cryImagePath = 'event/event_tet2026/animal/${num}_cry.png';
    // isVisible = true;
    isTapped = false;
    isAnimating = true;
    isVisible = true;
  }

  void ballData() {
    type = MoleType.ball;
    imagePath = 'event/event_tet2026/animal/ball.png';
    score = 200;
    // isVisible = true;
    isTapped = false;
    isAnimating = true;
    isVisible = true;
  }

  void resetData() {
    print('ResetData');
    index = 0;
    type = MoleType.none;
    isVisible = false;
    isTapped = false;
    isAnimating = false;
    imagePath = 'assets/images/event/event_tet2026/animal/1_normal.png';
    score = 0;
  }

  void setIndex(int value) {
    index = value;
  }
}
