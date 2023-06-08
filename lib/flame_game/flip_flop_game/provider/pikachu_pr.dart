import 'package:flutter/material.dart';

class FlipFlopPR extends ChangeNotifier {
  CustomPainter? _lineConnectedPikachu;
  CustomPainter? get lineConnectedPikachu => _lineConnectedPikachu;

  set lineConnectedPikachu(CustomPainter? value) {
    _lineConnectedPikachu = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _lineConnectedPikachu = null;
    super.dispose();
  }
}
