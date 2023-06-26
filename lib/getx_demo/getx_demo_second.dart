import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(
    // It is not mandatory to use named routes, but dynamic urls are interesting.
    initialRoute: '/home',
    theme: ThemeData(primarySwatch: Colors.blue),
    defaultTransition: Transition.native,
    translations: MyTranslations(),
    locale: const Locale('pt', 'BR'),
    getPages: [
      //Simple GetPage
      GetPage(name: '/home', page: () => const First()),
      // GetPage with custom transitions and bindings
      GetPage(
        name: '/second',
        page: () => Second(),
        transition: Transition.cupertino,
        binding: SampleBind(),
      ),
      // GetPage with default transitions
      GetPage(
        name: '/third',
        transition: Transition.cupertino,
        page: () => Third(),
      ),
    ],
  ));
}

abstract class VtcBasicPage<T extends GetxController> extends GetView<T> {
  const VtcBasicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: appBarCustom(context),
        body: body(context),
        floatingActionButton: floatingButtons(),
      ),
    );
  }

  Widget floatingButtons() => const SizedBox();
  Future<bool> onWillPop() => Future.value(true);
  AppBar? appBarCustom(BuildContext context);
  Widget? body(BuildContext context);
}

class MyTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'title': 'Hello World %s',
        },
        'en_US': {
          'title': 'Hello World from US',
        },
        'pt': {
          'title': 'Olá de Portugal',
        },
        'pt_BR': {
          'title': 'Olá do Brasil',
        },
      };
}

class ControllerCount extends GetxController {
  int count = 0;
  void increment() {
    count++;
    // use update method to update all count variables
    update();
  }
}

class First extends VtcBasicPage<GetxController> {
  const First({super.key});

  @override
  AppBar? appBarCustom(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          Get.snackbar("Hi", "I'm modern snackbar");
        },
      ),
      title: Text("title".trArgs(['John'])),
    );
  }

  @override
  Future<bool> onWillPop() {
    print('BACK BACK BACK BACK BACK');
    return super.onWillPop();
  }

  @override
  Widget floatingButtons() {
    return FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Get.find<ControllerCount>().increment();
        });
  }

  @override
  Widget? body(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetBuilder<ControllerCount>(
                init: ControllerCount(),
                // You can initialize your controller here the first time. Don't use init in your other GetBuilders of same controller
                builder: (_) => Text(
                      'clicks: ${_.count}',
                    )),
            ElevatedButton(
              child: const Text('Next Route'),
              onPressed: () {
                Get.toNamed('/second');
              },
            ),
            ElevatedButton(
              child: const Text('Change locale to English'),
              onPressed: () {
                Get.updateLocale(const Locale('en', 'UK'));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Second extends VtcBasicPage<ControllerX> {
  const Second({super.key});

  @override
  Future<bool> onWillPop() {
    print('BACK BACK BACK BACK BACK');
    return super.onWillPop();
  }

  @override
  AppBar? appBarCustom(BuildContext context) {
    return AppBar(
      title: const Text('second Route'),
    );
  }

  @override
  Widget? body(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () {
              print("count1 rebuild");
              return Text('${controller.count1}');
            },
          ),
          Obx(
            () {
              print("count2 rebuild");
              return Text('${controller.count2}');
            },
          ),
          Obx(() {
            print("sum rebuild");
            return Text('${controller.sum}');
          }),
          Obx(
            () => Text('Name: ${controller.user.value.name}'),
          ),
          Obx(
            () => Text('Age: ${controller.user.value.age}'),
          ),
          ElevatedButton(
            child: const Text("Go to last page"),
            onPressed: () {
              Get.toNamed('/third', arguments: 'arguments of second');
            },
          ),
          ElevatedButton(
            child: const Text("Back page and open snackbar"),
            onPressed: () {
              Get.back();
              Get.snackbar(
                'User 123',
                'Successfully created',
                colorText: Colors.black,
                backgroundColor: Colors.white,
              );
            },
          ),
          ElevatedButton(
            child: const Text("Increment"),
            onPressed: () {
              controller.increment();
            },
          ),
          ElevatedButton(
            child: const Text("Increment"),
            onPressed: () {
              controller.increment2();
            },
          ),
          ElevatedButton(
            child: const Text("Update name"),
            onPressed: () {
              controller.updateUser();
            },
          ),
          ElevatedButton(
            child: const Text("Dispose worker"),
            onPressed: () {
              controller.disposeWorker();
            },
          ),
        ],
      ),
    );
  }
}

class Third extends GetView<ControllerX> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        controller.incrementList();
      }),
      appBar: AppBar(
        title: Text("Third ${Get.arguments}"),
      ),
      body: Center(
          child: Obx(() => ListView.builder(
              itemCount: controller.list.length,
              itemBuilder: (context, index) {
                return Text("${controller.list[index]}");
              }))),
    );
  }
}

class SampleBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ControllerX>(() => ControllerX());
  }
}

class User {
  User({this.name = 'Name', this.age = 0});
  String name;
  int age;
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
