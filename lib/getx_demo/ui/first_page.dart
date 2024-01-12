import 'package:animation_demo/getx_demo/common/vtc_basic_page.dart';
import 'package:animation_demo/getx_demo/controller/call_back_verify_code_ctrol.dart';
import 'package:animation_demo/getx_demo/router/route_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirstBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CallBackVerifyCodeCtrol(), tag: 'FirstBindings');
    Get.lazyPut(() => ControllerCount());
  }
}

class ControllerCount extends GetxController {
  @override
  void onReady() {
    // TODO: implement onReady
    Get.find<CallBackVerifyCodeCtrol>(tag: 'FirstBindings')
        .isCallBackVerifyCode
        .listen((val) {
      // service.callTelcoPrepaid();
      print('First');
    });
    super.onReady();
  }

  int count = 0;
  void increment() {
    count++;
    // use update method to update all count variables
    update();
  }
}

class FirstPage extends VtcBasicPage<ControllerCount> {
  const FirstPage({super.key});

  @override
  AppBar? appBarCustom(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          Get.snackbar("Hi", "I'm modern snackbar");
        },
      ),
      title: Text("title".trArgs(['John'])),
    );
  }

  @override
  Future<bool> onWillPop() {
    print('BACK BACK BACK BACK BACK');
    return super.onWillPop();
  }

  @override
  Widget floatingButtons() {
    return FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Get.find<ControllerCount>().increment();
        });
  }

  @override
  Widget? body(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetBuilder<ControllerCount>(
              init: ControllerCount(),
              // You can initialize your controller here the first time. Don't use init in your other GetBuilders of same controller
              builder: (_) => Text(
                'clicks: ${_.count}',
              ),
            ),
            ElevatedButton(
              child: const Text('Next Route'),
              onPressed: () {
                Get.toNamed(RoutePaths.secondPage);
              },
            ),
            ElevatedButton(
              child: const Text('Change locale to English'),
              onPressed: () {
                Get.updateLocale(const Locale('en', 'UK'));
              },
            ),
          ],
        ),
      ),
    );
  }
}
