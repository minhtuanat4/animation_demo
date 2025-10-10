import 'package:flutter_test/flutter_test.dart';
import 'package:custom_keyboard/custom_keyboard.dart';
import 'package:custom_keyboard/custom_keyboard_platform_interface.dart';
import 'package:custom_keyboard/custom_keyboard_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCustomKeyboardPlatform
    with MockPlatformInterfaceMixin
    implements CustomKeyboardPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final CustomKeyboardPlatform initialPlatform = CustomKeyboardPlatform.instance;

  test('$MethodChannelCustomKeyboard is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCustomKeyboard>());
  });

  test('getPlatformVersion', () async {
    CustomKeyboard customKeyboardPlugin = CustomKeyboard();
    MockCustomKeyboardPlatform fakePlatform = MockCustomKeyboardPlatform();
    CustomKeyboardPlatform.instance = fakePlatform;

    expect(await customKeyboardPlugin.getPlatformVersion(), '42');
  });
}
