import 'package:animation_demo/getx_demo/common/vtc_basic_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentResult extends VtcBasicPage<GetxController> {
  const PaymentResult({super.key});

  @override
  AppBar? appBarCustom(BuildContext context) {
    return AppBar(
      title: const Text('PaymentResult'),
    );
  }

  @override
  Widget? body(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Successful Payment"),
          const SizedBox(
            height: 12,
          ),
          GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Text('Go Back'))
        ],
      ),
    );
  }
}
