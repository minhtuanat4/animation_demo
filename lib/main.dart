import 'dart:io';

import 'package:animation_demo/blocs/flip_flop_game_bloc/flip_flop_game_bloc.dart';
import 'package:animation_demo/firebase_options.dart';
import 'package:animation_demo/sqlite_example/sqlite_hepler.dart';
import 'package:animation_demo/validation_textfield/validation_textfield_bloc/validation_textfield_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fpjs_pro_plugin/fpjs_pro_plugin.dart';
import 'package:go_router/go_router.dart';

import 'common/user_management.dart';
import 'define_go_router.dart';

// List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
//   List<DateTime> days = [];
//   for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
//     days.add(startDate.add(Duration(days: i)));
//   }
//   return days;
// }

// List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
//   final daysToGenerate = endDate.difference(startDate).inDays + 1;
//   return List.generate(daysToGenerate, (i) => startDate.add(Duration(days: i)));
// }

// Toggle this to cause an async error to be thrown during initialization
// and to test that runZonedGuarded() catches the error
const _kShouldTestAsyncErrorOnInit = false;

// Toggle this for testing Crashlytics in your app locally.
const _kTestingCrashlytics = true;

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  ErrorWidget.builder = (details) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('''There's happened error'''),
      ),
      body: Center(
        child:
            Text('''There's happened error ${details.exceptionAsString()}'''),
      ),
    );
  };
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserManagement().navigatorKey = _navigatorKey;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FlipFlopGameBloc()),
        BlocProvider(create: (_) => ValidationTextfieldBloc())
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routerConfig: router,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    initialization();
    _initFingerprint();
    _getId();
    // initDatabase();
    super.initState();
  }

  // Future<void> initDatabase() async {
  //   await NewsProvider().getPathData();
  //   await NewsProvider().initOpenDababase();
  // }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print

    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
  }

  void _initFingerprint() async {
    await FpjsProPlugin.initFpjs('h63wEGPjvm4X0mABm3tS');
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      print('object ' + iosDeviceInfo.identifierForVendor.toString());
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
    return 'null';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: const OptionWidget());
  }
}

class OptionWidget extends StatelessWidget {
  const OptionWidget({Key? key}) : super(key: key);
  Future<void> identify() async {
    try {
      final visitorId = await FpjsProPlugin.getVisitorId();
      final deviceData = await FpjsProPlugin.getVisitorData();
      print('Visitor ID: ${visitorId}');
      print('Device data: ${deviceData}');
    } on PlatformException catch (e) {
      // process the error
      print('PlatformException ' + e.toString());
    }
  }

  static MethodChannel methodChannel = const MethodChannel('animation_demo');

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ListView(
        children: [
          // OptionButton(
          //     label: 'Page View Animation',
          //     onPressed: () {
          //       Navigator.of(context).push(MaterialPageRoute(
          //         builder: (context) {
          //           return const MyPageView();
          //         },
          //       ));
          //     }),
          // OptionButton(
          //     label: 'Holiday Game',
          //     onPressed: () {
          //       Navigator.of(context).push(MaterialPageRoute(
          //         builder: (context) {
          //           return const GameHolidays();
          //         },
          //       ));
          //     }),
          // OptionButton(
          //   label: 'Lifecycles State',
          //   onPressed: () {
          //     context.goNamed('lifecycle-state', params: {
          //       "id": '955',
          //       "name": "All 4 things",
          //     });
          //   },
          // ),
          // OptionButton(
          //   label: 'Custom Package',
          //   onPressed: () {
          //     Navigator.of(context).push(MaterialPageRoute(
          //       builder: (context) {
          //         return const HomePackages();
          //       },
          //     ));
          //   },
          // ),
          // OptionButton(
          //   label: 'Demo Tooltip',
          //   onPressed: () {
          //     Navigator.of(context).push(MaterialPageRoute(
          //       builder: (context) {
          //         return const TooltipDemo();
          //       },
          //     ));
          //   },
          // ),
          // OptionButton(
          //   label: 'Custom Validate Textfield',
          //   onPressed: () {
          //     Navigator.of(context).push(MaterialPageRoute(
          //       builder: (context) {
          //         return ValidationTextFieldPage(
          //           argumentObject: ArgumentObject(955, "Tuan"),
          //         );
          //       },
          //     ));
          //   },
          // ),
          // OptionButton(
          //   label: 'Go Router',
          //   onPressed: () {
          //     context.goNamed('go-router');
          //   },
          // ),
          // OptionButton(
          //   label: 'Carousel Slider',
          //   onPressed: () {
          //     context.goNamed(RouteName.carouselSliderPage, extra: {
          //       "arg1": "The Billionaire's Accidental  Bride",
          //       "arg2": "All 4 things",
          //     });
          //   },
          // ),

          // OptionButton(
          //   label: 'Animated List',
          //   onPressed: () {
          //     context.goNamed(
          //       RouteName.animatedListPage,
          //     );
          //   },
          // ),
          // OptionButton(
          //   label: 'Navigation Bar 3.0',
          //   onPressed: () {
          //     context.goNamed(RouteName.navigationBarPage);
          //   },
          // ),
          // OptionButton(
          //   label: 'Home Test Page',
          //   onPressed: () {
          //     context.goNamed(RouteName.homeTestPage);
          //   },
          // ),
          // OptionButton(
          //   label: 'Flutter Slidable',
          //   onPressed: () {
          //     context.goNamed(RouteName.flutterSlidale);
          //   },
          // ),
          // OptionButton(
          //   label: 'Draw Vertice',
          //   onPressed: () {
          //     context.goNamed(
          //       RouteName.drawVerticePage,
          //     );
          //   },
          // ),
          // OptionButton(
          //   label: 'Flame Game',
          //   onPressed: () {
          //     context.goNamed(
          //       RouteName.myGame,
          //     );
          //   },
          // ),
          // OptionButton(
          //   label: 'Custom Progress Indicator',
          //   onPressed: () {
          //     context.goNamed(
          //       RouteName.customProgressIndicator,
          //     );
          //   },
          // ),
          // OptionButton(
          //   label: 'Flip Flop Game',
          //   onPressed: () {
          //     context.goNamed(
          //       RouteName.flipFlopGame,
          //     );
          //   },
          // ),
          OptionButton(
            label: 'Pikachu Game Ver 1.0',
            onPressed: () {
              context.goNamed(
                RouteName.pikachuFlameGame,
              );
            },
          ),
          OptionButton(
            label: 'RotateScaleAnimationPage',
            onPressed: () {
              context.goNamed(RouteName.rotateScaleAnimationPage);
            },
          ),
          OptionButton(
            label: RouteName.drawProgressBar,
            onPressed: () {
              context.goNamed(RouteName.drawProgressBar);
            },
          ),
          OptionButton(
            label: RouteName.sqlitePage,
            onPressed: () async {
              context.goNamed(RouteName.sqlitePage);
            },
          ),
          OptionButton(
            label: RouteName.accountInfoHoang,
            onPressed: () async {
              context.goNamed(RouteName.accountInfoHoang);
            },
          ),
          OptionButton(
            label: RouteName.multiAnimation,
            onPressed: () async {
              context.goNamed(RouteName.multiAnimation);
            },
          ),
          OptionButton(
            label: RouteName.paintHolePage,
            onPressed: () async {
              context.goNamed(RouteName.multiAnimation);
            },
          ),
          // OptionButton(
          //   label: 'Finger.com',
          //   onPressed: () {
          //     identify();
          //   },
          // ),
          // OptionButton(
          //   label: 'Invoke Method Channel',
          //   onPressed: () {
          //     methodChannel.invokeMethod('openVC');
          //   },
          // ),
          // OptionButton(
          //   label: 'Render Object Page',
          //   onPressed: () {
          //     context.goNamed(
          //       RouteName.renderObjectPage,
          //     );
          //   },
          // ),
          // OptionButton(
          //   label: 'CupertinoSlideSegmentsControl',
          //   onPressed: () {
          //     context.goNamed(
          //       RouteName.cupertinoSlideSegmentsControl,
          //     );
          //   },
          // ),
          // OptionButton(
          //   label: 'Custom Animated Bottom Bar',
          //   onPressed: () {
          //     context.goNamed(
          //       RouteName.customAnimatedBottomBar,
          //     );
          //   },
          // ),
          // OptionButton(
          //   label: 'Scan Image QR Page',
          //   onPressed: () {
          //     context.goNamed(
          //       RouteName.scanImageQRPage,
          //     );
          //   },
          // ),
          // OptionButton(
          //   label: 'PaintOptionPage',
          //   onPressed: () {
          //     context.goNamed(
          //       RouteName.paintOptionPage,
          //     );
          //   },
          // ),
          // OptionButton(
          //   label: 'FlutterHookExample',
          //   onPressed: () {
          //     context.goNamed(
          //       RouteName.flutterHookExample,
          //     );
          //   },
          // ),
          // OptionButton(
          //   label: 'Test Throw Exeption',
          //   onPressed: () {
          //     throw Exception();
          //   },
          // ),
          // OptionButton(
          //   label: 'Bar Chart Page',
          //   onPressed: () {
          //     context.goNamed(
          //       RouteName.barChartPage,
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const OptionButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12)),
        onPressed: onPressed,
        child: Text(
          label,
        ),
      ),
    );
  }
}
