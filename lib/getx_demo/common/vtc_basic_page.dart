import 'package:animation_demo/common/debug.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class VtcBasicPage<T extends GetxController> extends GetView<T>
    with WidgetsBindingObserver {
  const VtcBasicPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addObserver(this);
    Debug.logMessage(
      trace: StackTrace.current,
      message:
          '=====================================Child Screen:${runtimeType.toString()}',
    );
    return Scaffold(
      appBar: appBarCustom(context),
      body: body(context),
      floatingActionButton: floatingButtons(),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('didChangeAppLifecycleState : ' + state.toString());
    super.didChangeAppLifecycleState(state);
  }

  Widget bottomNavigationBar() => const SizedBox();
  Widget floatingButtons() => const SizedBox();
  Future<bool> onWillPop() => Future.value(true);
  AppBar? appBarCustom(BuildContext context);
  Widget? body(BuildContext context);
}

abstract class VtcBasicPageChild<T extends GetxController> extends GetView<T> {
  const VtcBasicPageChild({super.key});

  @override
  Widget build(BuildContext context) {
    Debug.logMessage(
      trace: StackTrace.current,
      message:
          '=====================================Child Screen:${runtimeType.toString()}',
    );
    return Scaffold(
      appBar: appBarCustom(context),
      body: body(context),
      floatingActionButton: floatingButtons(),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Widget bottomNavigationBar() => const SizedBox();
  Widget floatingButtons() => const SizedBox();
  Future<bool> onWillPop() => Future.value(true);
  AppBar? appBarCustom(BuildContext context);
  Widget? body(BuildContext context);
}
