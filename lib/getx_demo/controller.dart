import 'package:get/state_manager.dart';

class ControllerCount extends GetxController {
  var count = 0.obs;
  void increment() {
    count++;
    update();
  }
}
