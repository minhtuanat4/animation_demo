import 'package:animation_demo/common/utils.dart';
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

  Future<int?> getCurrentID() async {
    return await Utils.readData(
      'currentIdSqflite',
    );
  }

  void setCurrentID({int? data}) {
    if (data == null) {
      Utils.removeData(
        'currentIdSqflite',
      );
    } else {
      Utils.saveData(
        'currentIdSqflite',
        data,
      );
    }
  }

  Future<String?> getToken() async {
    return await Utils.readData(
      'token',
    );
  }

  void setToken({String? data}) {
    if (data == null) {
      Utils.removeData(
        'token',
      );
    } else {
      Utils.saveData(
        'token',
        data,
      );
    }
  }
}
