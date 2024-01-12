import 'package:animation_demo/getx_demo/common/vtc_basic_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentHistoryController extends GetxController {}

class PaymentHistoryPage extends VtcBasicPageChild<PaymentHistoryController> {
  const PaymentHistoryPage({super.key});

  @override
  AppBar? appBarCustom(BuildContext context) {
    return null;
  }

  @override
  Widget? body(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('PaymentHistory Page'),
        GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Text('Go Back'))
      ],
    ));
  }
}
