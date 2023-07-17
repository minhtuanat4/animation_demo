import 'package:flutter/material.dart';

class BottomBarProvider extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  set currentIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }

  Color _inactiveColor = Colors.grey;
  Color get inactiveColor => _inactiveColor;

  set inactiveColor(Color value) {
    _inactiveColor = value;
    notifyListeners();
  }
}
