import 'package:animation_demo/getx_demo/common/app_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/loading_controller.dart';

class RootPage extends StatefulWidget {
  final Widget? child;
  final String? oneSignalAppId;

  const RootPage({
    Key? key,
    this.child,
    this.oneSignalAppId,
  }) : super(key: key);

  @override
  RootPageState createState() => RootPageState();
}

class RootPageState extends State<RootPage> {
  bool isShowLoading = false;

  //One signal
  String? emailAddress;
  String? smsNumber;
  String? externalUserId;

  // CHANGE THIS parameter to true if you want to test GDPR privacy consent
  bool requireConsent = true;
  //end onesignal
  late AppConfig appConfig;
  @override
  void initState() {
    super.initState();

    appConfig = Get.find<AppConfig>();

    // initPlatformState(oneSignalAppId: widget.oneSignalAppId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setStateRootPage(Function fc) {
    setState(fc as void Function());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child!,
        const CircularIndicator(),
      ],
    );
  }
}

class CircularIndicator extends StatefulWidget {
  const CircularIndicator({Key? key}) : super(key: key);

  @override
  State<CircularIndicator> createState() => _CircularIndicatorState();
}

class _CircularIndicatorState extends State<CircularIndicator> {
  final loadingController = Get.find<LoadingCtroller>();
  final valueListen = ValueNotifier<bool>(false);
  @override
  void initState() {
    loadingController.isLoading.listen((val) {
      if (val) {
        if (valueListen.value) {
          return;
        } else {
          valueListen.value = true;
        }
      } else {
        valueListen.value = false;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: valueListen,
      builder: (context, isLoading, child) {
        return isLoading
            ? Container(
                color: Colors.black.withOpacity(0.2),
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(188),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(22),
                    child: const CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              )
            : const SizedBox();
      },
    );
  }
}
