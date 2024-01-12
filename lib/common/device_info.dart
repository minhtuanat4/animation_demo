import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfo {
  static IosDeviceInfo? iosDeviceInfo;
  static AndroidDeviceInfo? androidDeviceInfo;
  static String? _deviceSerial;
  static String? _systemVersion;
  static String? _deviceName;
  static String? _deviceVersion;

  DeviceInfo() {
    _getDeviceInfo();
  }

  Future<void> _getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      iosDeviceInfo = await deviceInfo.iosInfo;
    } else {
      androidDeviceInfo = await deviceInfo.androidInfo;
    }
  }

  static Future<String?> get deviceSerial async {
    if (_deviceSerial != null) {
      return _deviceSerial;
    }
    if (Platform.isIOS) {
      iosDeviceInfo ??= await DeviceInfoPlugin().iosInfo;
      _deviceSerial = iosDeviceInfo!.identifierForVendor;
    } else {
      androidDeviceInfo ??= await DeviceInfoPlugin().androidInfo;
      _deviceSerial = androidDeviceInfo!.androidId;
    }
    return _deviceSerial;
  }

  static Future<String?> get systemVersion async {
    if (_systemVersion != null) {
      return _systemVersion;
    }
    if (Platform.isIOS) {
      iosDeviceInfo ??= await DeviceInfoPlugin().iosInfo;
      _systemVersion = iosDeviceInfo!.systemVersion;
    } else {
      androidDeviceInfo ??= await DeviceInfoPlugin().androidInfo;
      _systemVersion = androidDeviceInfo!.version.baseOS;
    }
    return _systemVersion;
  }

  static Future<String?> get deviceName async {
    if (_deviceName != null) {
      return _deviceName;
    }
    if (Platform.isIOS) {
      iosDeviceInfo ??= await DeviceInfoPlugin().iosInfo;
      _deviceName = iosDeviceInfo!.name;
    } else {
      androidDeviceInfo ??= await DeviceInfoPlugin().androidInfo;
      _deviceName = androidDeviceInfo!.model;
    }
    return _deviceName;
  }

  static Future<String?> get deviceVersion async {
    if (_deviceVersion != null) {
      return _deviceVersion;
    }
    if (Platform.isIOS) {
      iosDeviceInfo ??= await DeviceInfoPlugin().iosInfo;
      _deviceVersion = iosDeviceInfo!.systemVersion;
    } else {
      androidDeviceInfo ??= await DeviceInfoPlugin().androidInfo;
      _deviceVersion = androidDeviceInfo!.version.release;
    }
    return _deviceVersion;
  }
}
