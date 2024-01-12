import 'package:animation_demo/getx_demo/common/vtc_basic_page.dart';
import 'package:animation_demo/getx_demo/router/route_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {}

class HomePage extends VtcBasicPageChild<HomeController> {
  const HomePage({super.key});

  @override
  AppBar? appBarCustom(BuildContext context) {
    return null;
  }

  @override
  Widget? body(BuildContext context) {
    return Center(
        child: Container(
      width: double.infinity,
      color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Home Page'),
          GestureDetector(
              onTap: () {
                Get.toNamed(RoutePaths.secondPage);
              },
              child: const Text('secondPage'))
        ],
      ),
    ));
  }
}
