import 'platfrom_interface.dart';

PlatformShow createAdapter() => TextShowPlatformWeb();

class TextShowPlatformWeb implements PlatformShow {
  @override
  String platformName() {
    return 'Platform Phone';
  }
}
