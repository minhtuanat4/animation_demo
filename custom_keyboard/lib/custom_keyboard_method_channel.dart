import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'custom_keyboard_platform_interface.dart';

/// An implementation of [CustomKeyboardPlatform] that uses method channels.
class MethodChannelCustomKeyboard extends CustomKeyboardPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('custom_keyboard');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
