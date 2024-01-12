import 'package:animation_demo/common/debug.dart';
import 'package:animation_demo/getx_demo/common/custom/epos_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/vtc_basic_page.dart';
import 'controller/second_controller.dart';

String tagGlobal = '';

class SecondPage extends VtcBasicPage<ControllerSecondPage> with EposPopup {
  const SecondPage({super.key});

  @override
  Future<bool> onWillPop() {
    Get.back();
    Debug.logMessage(message: 'BACK BACK BACK BACK BACK');
    return super.onWillPop();
  }

  @override
  AppBar? appBarCustom(BuildContext context) {
    return AppBar(
      title: const Text('second Route'),
    );
  }

  @override
  Widget? body(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: controller.ani,
            builder: (context, child) {
              return Transform.scale(
                scale: controller.ani.value,
                child: child ?? const SizedBox(),
              );
            },
            child: AnimatedBuilder(
              animation: controller.aniSecond,
              builder: (context, child) {
                return Transform.rotate(
                  angle: controller.aniSecond.value,
                  child: Container(
                    height: 100,
                    width: 100,
                    color: Colors.red,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              // Get.toNamed(RoutePaths.paymentResult);
            },
            child: Container(
              height: 20,
              width: 100,
              color: Colors.green,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          GestureDetector(
            onTap: () {
              controller.ctrolerSecond
                ..reset()
                ..forward();
            },
            child: Container(
              height: 20,
              width: 100,
              color: Colors.green,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              controller.service.callTelcoPrepaid();
            },
            child: Container(
              height: 20,
              width: 100,
              color: Colors.green,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          GetBuilder<ControllerSecondPage>(
            builder: (controller) {
              return (controller.telCoModel != null)
                  ? const Text('Has Data')
                  : const Text('controller.telCoModel is Null');
            },
          ),
          const SizedBox(
            height: 12,
          ),
          Text(controller.count.toString()),
        ],
      ),
    );
  }
}
