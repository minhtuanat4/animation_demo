import 'package:animation_demo/getx_demo/common/custom/epos_popup.dart';
import 'package:animation_demo/getx_demo/router/route_path.dart';
import 'package:animation_demo/getx_demo/ui/second_page/controller/second_controller.dart';
import 'package:animation_demo/getx_demo/ui/second_page/service/second_service.dart';
import 'package:get/get.dart';

class FuncSecondPgae extends SecondService with EposPopup {
  final ControllerSecondPage controller;

  FuncSecondPgae(this.controller);
  Future<void> callTelcoPrepaid({bool isCallback = false}) async {
    // final verifyController = Get.find<VerifyCodeController>();
    // verifyController.
    telcoPrepaid().then((value) {
      if (value != null && value.responseCode! > 0) {
        controller.telCoModel = value;

        if (isCallback) {
          Get.toNamed(RoutePaths.paymentResult);
        } else {
          Get.toNamed(RoutePaths.verifyCodePage, arguments: [
            {"first": 'SecondPageBind'},
            {"second": 'Second data'}
          ]);
        }
      } else {
        noticeSamePikachu(
          () {
            Get.back();
          },
        );
      }
    }).catchError((e) {});
  }
}
