import 'dart:convert';
import 'dart:io';

import 'package:animation_demo/getx_demo/common/user_management.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Utils {
  static Future<bool> saveData(String key, Object? value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = json.encode(value);
      return prefs.setString(key, savedData);
    } catch (e) {
      return Future<bool>.value(true);
    }
  }

  static Size getSizes(GlobalKey key) {
    try {
      final renderBoxRed = key.currentContext!.findRenderObject() as RenderBox;
      final sizeRed = renderBoxRed.size;
      return sizeRed;
    } catch (e) {
      return Size.zero;
    }
  }

  static Future<String> genOrGetGuid() async {
    var aGuid = await UserManagement().getAGuid();
    if (aGuid == null || aGuid.isEmpty) {
      const uuid = Uuid();
      aGuid = uuid.v4();
      UserManagement().setAGuid(data: aGuid);
    }
    return aGuid;
  }

  static Future<bool> checkNetwork() async {
    var isConnected = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
    }
    return isConnected;
  }

  static String? cleanUpVietnamese(String? input) {
    if (input == null) {
      return null;
    }
    var res = input;
    const before =
        'áàảãạ ăắằẳẵặ âấầẩẫậ ÁÀẢÃẠ ĂẮẰẲẴẶ ÂẤẦẨẪẬ đ Đ éèẻẽẹ êếềểễệ ÉÈẺẼẸ ÊẾỀỂỄỆ íìỉĩị ÍÌỈĨỊ óòỏõọ ôốồổỗộ ơớờởỡợ ÓÒỎÕỌ ÔỐỒỔỖỘ ƠỚỜỞỠỢ úùủũụ ưứừửữự ÚÙỦŨỤ ƯỨỪỬỮỰ ýỳỷỹỵ ÝỲỶỸỴ';
    const after =
        'aaaaa aaaaaa aaaaaa AAAAA AAAAAA AAAAAA d D eeeee eeeeee EEEEE EEEEEE iiiii IIIII ooooo oooooo oooooo OOOOO OOOOOO OOOOOO uuuuu uuuuuu UUUUU UUUUUU yyyyy YYYYY';

    for (var i = 0; i < before.length; i++) {
      final b = before.substring(i, i + 1);
      final a = after.substring(i, i + 1);
      if (!b.contains(' ')) {
        res = res.replaceAll(b, a);
      }
    }
    return res;
  }

  // ignore: avoid_positional_boolean_parameters
  static Future<void> saveBoolData(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<dynamic> readData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key);
    if (value == null || value.isEmpty) {
      return null;
    } else {
      return json.decode(value);
    }
  }

  static dynamic readBoolData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(key);
    return value;
  }

  static Future<void> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static String convertToDatetime(int datetime) {
    final f = DateFormat('yyyy/MM/dd HH:mm');
    final date = DateTime.fromMillisecondsSinceEpoch(datetime);
    return f.format(date);
  }

  static String getCurrentTime() {
    final f = DateFormat('dd/MM/yyyy hh:MM');
    final date = DateTime.now();
    return f.format(date);
  }

  static String getCurrentTimeWithFormat(String dateFormat) {
    final f = DateFormat(dateFormat);
    final date = DateTime.now();
    return f.format(date);
  }

  static Future<PermissionStatus> checkPermission(Permission permission) async {
    var status = await permission.status;
    if (status != PermissionStatus.granted) {
      status = await permission.request();
    }
    return status;
  }
}
