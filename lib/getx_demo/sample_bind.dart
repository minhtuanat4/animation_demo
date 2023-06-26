import 'package:animation_demo/getx_demo/controller.dart';
import 'package:get/instance_manager.dart';

class SimpleBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ControllerCount>(() => ControllerCount());
  }
}
