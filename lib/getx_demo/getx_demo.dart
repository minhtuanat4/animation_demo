import 'package:animation_demo/getx_demo/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controllerCount = Get.put(ControllerCount());
  // Another Way to get Controller
  // final ControllerCount controllerCount = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
          child: Column(
        children: [
          const SizedBox(height: 20),
          Obx(
            () => Text('Clicks:  ${controllerCount.count}'),
          ),
          const SizedBox(height: 20),
          TextButton(
              onPressed: () {
                controllerCount.increment();
              },
              child: const Text('Increase Count')),
          const SizedBox(height: 20),
          TextButton(
              onPressed: () {
                Get.to(() => const NextPage());
              },
              child: const Text('Navigate the Next Page')),
          const SizedBox(height: 20),
          TextButton(
              onPressed: () {
                Get.snackbar('GetX Snackbar', 'Yay! Awesome GetX Snackbar',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.tealAccent);
              },
              child: const Text('Show Snackbar')),
          const SizedBox(height: 20),
          TextButton(
              onPressed: () {
                Get.defaultDialog(
                    title: 'GetX Alert',
                    middleText: 'Simple GetX alert',
                    textConfirm: 'Okay',
                    confirmTextColor: Colors.white,
                    textCancel: 'Cancel');
              },
              child: const Text('Show AlertDialog')),
          const SizedBox(height: 20),
          TextButton(
              onPressed: () {
                Get.bottomSheet(
                    Wrap(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.wb_sunny_outlined),
                          title: const Text("Light theme"),
                          onTap: () => {Get.changeTheme(ThemeData.light())},
                        ),
                        ListTile(
                          leading: const Icon(Icons.wb_sunny),
                          title: const Text("Dark theme"),
                          onTap: () => {Get.changeTheme(ThemeData.dark())},
                        )
                      ],
                    ),
                    backgroundColor: Colors.green);
              },
              child: const Text('Show BottomSheet'))
        ],
      )),
    );
  }
}

class NextPage extends StatefulWidget {
  const NextPage({super.key});

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  final ControllerCount ctrl = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Page'),
      ),
      body: Center(
          child: Column(
        children: [
          const SizedBox(height: 20),
          Text('Clicks: ${ctrl.count}'),
          const SizedBox(height: 20),
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Back to Page'))
        ],
      )),
    );
  }
}
