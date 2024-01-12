import 'package:animation_demo/getx_demo/common/vtc_basic_page.dart';
import 'package:animation_demo/getx_demo/controller/call_back_verify_code_ctrol.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VeriryCodeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VerifyCodeController());
  }
}

class VerifyCodeController extends GetxController {
  final argumentData = Get.arguments;
  String tag = '';
  final otpController = TextEditingController();
  RxString otp = ''.obs;

  @override
  void onInit() {
    tag = (argumentData[0]['first']);

    otpController.text = '';
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}

class VerifyCodePage extends VtcBasicPage<VerifyCodeController> {
  const VerifyCodePage({super.key});

  @override
  AppBar? appBarCustom(BuildContext context) {
    return AppBar(
      title: const Text('VerifyCodePage'),
    );
  }

  @override
  Widget? body(BuildContext context) {
    final callBackVerifyCode =
        Get.find<CallBackVerifyCodeCtrol>(tag: controller.tag);
    return Center(
      child: Column(children: [
        TextFormField(
            controller: controller.otpController,
            onChanged: (value) {
              if (value.length > 6) {
                callBackVerifyCode.callBack(
                    otp: value,
                    istrustDevice: true,
                    secureTypeID: 20,
                    signNextStep: 12345);

                controller.otpController.text = '';
              }
            })
      ]),
    );
  }
}
