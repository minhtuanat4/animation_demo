import 'dart:math' show Random;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

final _rand = Random();

// ignore: avoid_classes_with_only_static_members
class Helper {
  static double randomize(double min, double max) {
    return lerpDouble(min, max, _rand.nextDouble())!;
  }

  static Color randomColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }
}
