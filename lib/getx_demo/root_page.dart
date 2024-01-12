import 'dart:async';

import 'package:animation_demo/common/debug.dart';
import 'package:animation_demo/getx_demo/common/app_config.dart';
import 'package:animation_demo/getx_demo/rootpage_onesignal.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
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

    initPlatformState(oneSignalAppId: widget.oneSignalAppId);

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void setStateRootPage(Function fc) {
    setState(fc as void Function());
  }

// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    var result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      Debug.logMessage(message: e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value();
    }

    return _updateConnectionStatus(result);
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

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        // UserManagement().getTelcoModel(context: context);
        break;
      case ConnectivityResult.none:
        break;
      default:
        break;
    }
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
