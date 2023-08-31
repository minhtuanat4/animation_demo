import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
