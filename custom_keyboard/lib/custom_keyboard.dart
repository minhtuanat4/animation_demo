
import 'custom_keyboard_platform_interface.dart';

class CustomKeyboard {
  Future<String?> getPlatformVersion() {
    return CustomKeyboardPlatform.instance.getPlatformVersion();
  }
}
