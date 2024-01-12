import 'package:animation_demo/common/definition_color.dart';
import 'package:animation_demo/common/definition_theme.dart';
import 'package:animation_demo/getx_demo/common/app_config.dart';
import 'package:animation_demo/getx_demo/common/user_management.dart';
import 'package:animation_demo/getx_demo/controller/loading_controller.dart';
import 'package:animation_demo/getx_demo/root_page.dart';
import 'package:animation_demo/getx_demo/ui/second_page/controller/second_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'common/my_translaions.dart';
import 'router/router.dart' as getpages;
import 'service/api_service.dart';

void main() {
  AppConfig();

  runApp(const MyApp());
}

class RootPageController extends GetxController {
  bool _isFirst = false;
  bool get isFirst => _isFirst;

  set isFirst(bool value) {
    _isFirst = value;
    update();
  }
}

class RootPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserManagement());
    Get.put(RootPageController());
    Get.put(LoadingCtroller());
    Get.put(ApiService());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.put(() => AppConfig());
    final appConfig = Get.put(AppConfig());
    // Get.put(VerifyCodeController('ControllerSecondPage'));
    return GetMaterialApp(
      // It is not mandatory to use named routes, but dynamic urls are interesting.
      initialRoute: '/',
      // localizationsDelegates: const [
      //   // GlobalMaterialLocalizations.delegate,
      //   // GlobalCupertinoLocalizations.delegate,
      //   DefaultWidgetsLocalizations.delegate,
      // ],
      // supportedLocales: const [Locale('vi')],
      debugShowCheckedModeBanner: false,
      title: appConfig.appTitle,
      initialBinding: RootPageBinding(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness:
                Brightness.dark, //<-- For Android SEE HERE (dark icons)
            statusBarBrightness:
                Brightness.light, //<-- For iOS SEE HERE (dark icons)
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,

        brightness: Brightness.light,
        //primarySwatch: appBarWhiteColor,
        primarySwatch: appBarColor,
        textTheme: ehomeTextTheme,
        fontFamily: 'Be Vietnam',
        //cursorColor: Colors.red,
      ),
      defaultTransition: Transition.native,
      translations: MyTranslations(),
      locale: const Locale('pt', 'BR'),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: RootPage(
            oneSignalAppId: appConfig.oneSignalAppId,
            child: child,
          ),
        );
      },
      getPages: getpages.GetPages.getPages(),
    );
  }
}

class ControllerX extends GetxController {
  final count1 = 0.obs;
  final count2 = 0.obs;
  final list = [56].obs;
  final user = User().obs;

  updateUser() {
    user.update((value) {
      value!.name = 'Jose';
      value.age = 30;
    });
  }

  /// Once the controller has entered memory, onInit will be called.
  /// It is preferable to use onInit instead of class constructors or initState method.
  /// Use onInit to trigger initial events like API searches, listeners registration
  /// or Workers registration.
  /// Workers are event handlers, they do not modify the final result,
  /// but it allows you to listen to an event and trigger customized actions.
  /// Here is an outline of how you can use them:

  /// made this if you need cancel you worker
  late Worker _ever;

  @override
  onInit() {
    /// Called every time the variable $_ is changed
    _ever = ever(count1, (_) => print("$_ has been changed (ever)"));

    everAll([count1, count2], (_) => print("$_ has been changed (everAll)"));

    /// Called first time the variable $_ is changed
    once(count1, (_) => print("$_ was changed once (once)"));

    /// Anti DDos - Called every time the user stops typing for 1 second, for example.
    debounce(count1, (_) => print("debouce$_ (debounce)"),
        time: const Duration(seconds: 1));

    /// Ignore all changes within 1 second.
    interval(count1, (_) => print("interval $_ (interval)"),
        time: const Duration(seconds: 1));
  }

  int get sum => count1.value + count2.value;

  increment() => count1.value++;

  increment2() => count2.value++;

  disposeWorker() {
    _ever.dispose();
    // or _ever();
  }

  incrementList() => list.add(75);
}

class SizeTransitions extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve? curve,
      Alignment? alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animation,
          curve: Curves.bounceIn,
        ),
        child: child,
      ),
    );
  }
}
