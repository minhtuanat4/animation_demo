import 'package:animation_demo/resource/definition_color.dart';
import 'package:flutter/material.dart';

const TextTheme eposTextTheme = TextTheme(
  displayLarge: TextStyle(
    color: colorBlackPos,
    fontFamily: 'Be Vietnam',
    fontSize: 72,
    fontWeight: FontWeight.bold,
  ),

  /// Tiêu để 1
  headlineLarge: TextStyle(
    color: colorBlackPos,
    fontFamily: 'Be Vietnam',
    fontSize: 24,
    decoration: TextDecoration.none,
  ),

  /// Tiêu để 2 và 3
  headlineMedium: TextStyle(
    color: colorBlackPos,
    fontFamily: 'Be Vietnam',
    fontSize: 18,
    decoration: TextDecoration.none,
  ),

  titleSmall: TextStyle(
    fontSize: 14,
    color: colorBlackPos,
    fontFamily: 'Be Vietnam',
    decoration: TextDecoration.none,
  ),

  /// Mô tả và nội dung nhỏ
  bodySmall: TextStyle(
    color: colorBlackPos,
    fontSize: 12,
    fontFamily: 'Be Vietnam',
    decoration: TextDecoration.none,
  ),

  ///
  bodyMedium: TextStyle(
    color: colorBlackPos,
    fontSize: 14,
    fontFamily: 'Be Vietnam',
    decoration: TextDecoration.none,
  ),

  ///
  bodyLarge: TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontFamily: 'Be Vietnam',
    decoration: TextDecoration.none,
  ),

  /// Ghi chú
  labelSmall: TextStyle(
    color: colorBlackPos,
    fontFamily: 'Be Vietnam',
    fontSize: 14,
    decoration: TextDecoration.none,
  ),
);

final TextTheme ehomeDarkTextTheme = TextTheme(
  labelLarge: TextStyle(
    color: Colors.grey[600],
    fontFamily: 'Be Vietnam',
    decoration: TextDecoration.none,
  ),
  bodySmall: TextStyle(
    color: Colors.grey[600],
    fontFamily: 'Be Vietnam',
    decoration: TextDecoration.none,
  ),
  labelSmall: TextStyle(
    color: Colors.grey[600],
    fontFamily: 'Be Vietnam',
    decoration: TextDecoration.none,
  ),
);
