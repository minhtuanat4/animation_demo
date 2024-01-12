import 'dart:io';

import 'package:animation_demo/common/device_info.dart';
import 'package:animation_demo/common/utils.dart';
import 'package:animation_demo/getx_demo/common/sharepreference_keys.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserManagement extends GetxService {
  Future<void> init() async {
    final preBackPress = DateTime.now();
    await _getDeviceName();
    await _getSystemVersion();
    await _getSeviceSerial();
    await _getDeviceSystemVersion();
  }

  @protected
  String? _accessToken = '';

  String? get accessToken => _accessToken;

  String _deviceSystemVersion = '';
  String _deviceOsVersion = '29'; // Android10+
  String get deviceInfo =>
      'Hệ điều hành: ${Platform.operatingSystem}\nPhiên bản: $_deviceSystemVersion';
  String get deviceOs => _deviceOsVersion;
  Future<void> _getDeviceSystemVersion() async {
    if (Platform.isAndroid) {
      _deviceSystemVersion =
          'Android ${(await DeviceInfoPlugin().androidInfo).version.release}';
      _deviceOsVersion =
          '${(await DeviceInfoPlugin().androidInfo).version.sdkInt}';
    } else {
      _deviceSystemVersion =
          (await DeviceInfoPlugin().iosInfo).systemName ?? '';
      _deviceOsVersion = (await DeviceInfoPlugin().iosInfo).systemVersion ?? '';
    }
  }

  String get accountName {
    return '0333881682';
  }

  @protected
  String? _deviceName = '';

  String? get deviceName => _deviceName;

  /// Lấy device name
  Future<void> _getDeviceName() async {
    if (_deviceName == null || _deviceName!.isEmpty) {
      _deviceName = await DeviceInfo.deviceName;
      _deviceName = _deviceName!.replaceAll(':', '');
      _deviceName = Utils.cleanUpVietnamese(_deviceName)!.replaceAll(' ', '');
      _deviceName = Uri.encodeFull(_deviceName!);
      if (_deviceName!.length > 50) {
        _deviceName = _deviceName!.substring(0, 50);
      }
    }
  }

  @protected
  String? _systemVersion = '';

  String? get systemVersion => _systemVersion;

  /// Lấy system version
  Future<void> _getSystemVersion() async {
    if (_systemVersion == null || _systemVersion!.isEmpty) {
      _systemVersion = await DeviceInfo.systemVersion;
      _systemVersion = _systemVersion!.replaceAll(':', '');
      _systemVersion = Uri.encodeFull(_systemVersion!);
      if (_systemVersion!.length > 50) {
        _systemVersion = _systemVersion!.substring(0, 50);
      }
    }
  }

  @protected
  String _deviceSerial = '';

  String get deviceSerial => _deviceSerial;

  /// Lấy device serial
  Future<void> _getSeviceSerial() async {
    if (_deviceSerial.isEmpty) {
      _deviceSerial = await Utils.genOrGetGuid();

      _deviceSerial = _deviceSerial.replaceAll('-', '');
    }
  }

  /// aGuid: chỉ dùng cho android, trường hợp người dùng clean data trong app info thì gen lại, coi như 1 thiết bị mới
  Future<String?> getAGuid() async {
    return await Utils.readData(
      '${SharedPreferenceKeys.aGuid}$accountName',
    );
  }

  void setAGuid({String? data}) {
    if (data == null) {
      Utils.removeData(
        '${SharedPreferenceKeys.aGuid}$accountName',
      );
    } else {
      Utils.saveData(
        '${SharedPreferenceKeys.aGuid}$accountName',
        data,
      );
    }
  }
}
