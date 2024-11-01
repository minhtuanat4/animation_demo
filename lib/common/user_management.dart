import 'package:animation_demo/common/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserManagement {
  static final UserManagement _shared = UserManagement._initialState();

  factory UserManagement() {
    return _shared;
  }

  /// Initial State
  UserManagement._initialState() {
    navigatorKey = null;
    databaseRef = FirebaseDatabase.instanceFor(
            app: Firebase.app(),
            databaseURL:
                'https://animation-demo-3bc8b-default-rtdb.asia-southeast1.firebasedatabase.app/')
        .ref();
  }
  GlobalKey<NavigatorState>? navigatorKey;

  UserCredential? userInfo;

  late DatabaseReference databaseRef;
  AuthCredential? authCredential;
  Future<void> addUser(
    String uuid,
    String name,
    String image,
  ) async {
    // databaseRef.child('users/').push().set({
    //   'id': uuid,
    //   'name': name,
    //   'image': image,
    // }).then((value) => null);

    final ref = databaseRef.child('users/$uuid/');
    await ref.update({
      'id': uuid,
      'name': name,
      'image': image,
    });
  }

  Future<void> updateUser(
    String uuid,
    String name,
    String image,
  ) async {
    final ref = databaseRef.child('users/$uuid/');
    await ref.update({
      'name': name,
      'image': image,
    });
  }

  Future<void> statusUser(
    String uuid,
    bool isActive,
  ) async {
    final ref = databaseRef.child('users/$uuid/');
    await ref.update({
      'active': isActive,
    });
  }

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

  Future<String?> getAuthCredential() async {
    return await Utils.readData(
      'token',
    );
  }

  void setAuthCredential({AuthCredential? data}) {
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
