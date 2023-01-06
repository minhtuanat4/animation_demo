import 'package:flutter/material.dart';

class UserManagement {
  static final UserManagement _shared = UserManagement._initialState();

  factory UserManagement() {
    return _shared;
  }

  /// Initial State
  UserManagement._initialState() {
    navigatorKey = null;
  }
  GlobalKey<NavigatorState>? navigatorKey;
}
