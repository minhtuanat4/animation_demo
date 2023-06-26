// Create Adapter
import 'package:animation_demo/flutter_use_case/platfrom_interface.dart';

PlatformShow createAdapter() => TextShowPlatformPhone();

class TextShowPlatformPhone implements PlatformShow {
  @override
  String platformName() {
    return 'Platform Phone';
  }
}
