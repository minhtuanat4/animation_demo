import 'package:animation_demo/getx_demo/ui/first_page.dart';
import 'package:animation_demo/getx_demo/ui/intro_page/intro_page.dart';
import 'package:animation_demo/getx_demo/ui/main_home_page/main_home_page.dart';
import 'package:animation_demo/getx_demo/ui/payment_result.dart';
import 'package:animation_demo/getx_demo/ui/second_page/controller/second_controller.dart';
import 'package:animation_demo/getx_demo/ui/second_page/second_page.dart';
import 'package:animation_demo/getx_demo/ui/third_page.dart';
import 'package:animation_demo/getx_demo/ui/verify_code_page/verify_code_page.dart';
import 'package:animation_demo/performance_series/off_stage_widget.dart';
import 'package:get/get.dart';

import 'route_path.dart';

// class MiddleWare {
//   static observer(Routing routing) {
//     if (routing.current == '/second') {
//       Get.snackbar("Hi", "You are on the second route");
//     } else if (routing.current == '/third') {
//       print('Last route called');
//     }
//   }
// }

class GetPageCustom extends GetPage {
  final String nameCustom;
  GetPageCustom({required this.nameCustom, required super.page, super.binding})
      : super(name: '/$nameCustom');
}

class GetPages {
  static List<GetPage<dynamic>>? getPages() {
    return [
      GetPageCustom(
        nameCustom: '/',
        page: () => const IntroPage(),
      ),

      GetPageCustom(
        nameCustom: RoutePaths.mainHomePage,
        binding: MainHomeBindings(),
        page: () => const MainHomePage(),
      ),

      GetPage(
          name: RoutePaths.firstPage,
          page: () => const FirstPage(),
          binding: FirstBindings()),
      // GetPage with custom transitions and bindings
      GetPage(
        name: RoutePaths.secondPage,
        popGesture: false,
        binding: SecondPageBind(),
        page: () => const SecondPage(),
        transition: Transition.cupertino,
      ),
      GetPage(
        name: RoutePaths.thirdPage,
        transition: Transition.cupertino,
        page: () => const ThirdPage(),
      ),
      GetPage(
        name: RoutePaths.verifyCodePage,
        popGesture: false,
        binding: VeriryCodeBindings(),
        page: () => const VerifyCodePage(),
        transition: Transition.cupertino,
      ),
      GetPage(
        name: RoutePaths.paymentResult,
        popGesture: false,
        page: () => const PaymentResult(),
        transition: Transition.cupertino,
      ),
      GetPage(
        name: RoutePaths.performanceSeriesPage,
        popGesture: false,
        page: () => const PerformanceSeriesPage(),
        transition: Transition.cupertino,
      ),
      // GetPage with default transitions
    ];
  }
}
