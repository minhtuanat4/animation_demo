import 'package:animation_demo/getx_demo/common/vtc_basic_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {}

class AccountPage extends VtcBasicPageChild<AccountController> {
  const AccountPage({super.key});

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
        const Text('Account Page'),
        GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Text('Go Back'))
      ],
    ));
  }
}
