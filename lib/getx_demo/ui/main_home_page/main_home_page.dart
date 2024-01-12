import 'dart:async';

import 'package:animation_demo/common/definition_color.dart';
import 'package:animation_demo/common/utils.dart';
import 'package:animation_demo/getx_demo/common/vtc_basic_page.dart';
import 'package:animation_demo/getx_demo/ui/main_home_page/tab_view_page/account_page.dart';
import 'package:animation_demo/getx_demo/ui/main_home_page/tab_view_page/payment_history_page.dart';
import 'package:animation_demo/getx_demo/ui/main_home_page/tab_view_page/qr_page.dart';
import 'package:animation_demo/getx_demo/ui/main_home_page/tab_view_page/voucher_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import 'tab_menu_item.dart';
import 'tab_view_page/home_page.dart';

class MainHomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainHomeController());
  }
}

class MainHomeController extends GetxController
    with GetSingleTickerProviderStateMixin, WidgetsBindingObserver {
  int _currentIndex = TabMenuItem.HOME.index;
  //TabController tabController;
  TabMenuItem? selectedItem;
  final pageController = PageController(
    initialPage: TabMenuItem.HOME.index,
    keepPage: true,
  );
  final List<TabMenuItem> itemsList = [
    TabMenuItem.HOME,
    TabMenuItem.MGG,
    TabMenuItem.SCANQR,
    TabMenuItem.HISTORY,
    TabMenuItem.USER,
  ];
  BottomNavigationBar? bottomNavigationBar;

  dynamic lstContactApart;
  List<String> listApart = [];
  dynamic lstContactSelectedApart;
  List<String> listContactType = [];
  bool dialVisible = true;
  Size bottomTabbarHeight = Size.zero;
  final _keyBottomTabbar = GlobalKey();

  late AnimationController _scanMenuItemCotrol;
  @override
  void onInit() {
    _scanMenuItemCotrol =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    selectedItem = itemsList[TabMenuItem.HOME.index];

    super.onInit();
  }

  @override
  void onReady() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      bottomTabbarHeight = Utils.getSizes(_keyBottomTabbar);
      // update();
    });
    super.onReady();
  }

  @override
  void onClose() {
    pageController.dispose();
    _scanMenuItemCotrol.dispose();
    super.onClose();
  }

  void onPageChanged(int index) {
    _currentIndex = index;
  }
}

class MainHomePage extends VtcBasicPage<MainHomeController> {
  const MainHomePage({super.key});

  @override
  AppBar? appBarCustom(BuildContext context) {
    return AppBar(
      title: const Text('Main Home Page'),
      leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined)),
    );
  }

  @override
  Widget? body(BuildContext context) {
    genBottomNavBar();
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: controller.pageController,
      onPageChanged: controller.onPageChanged,
      children: const <Widget>[
        HomePage(),
        VoucherPage(),
        QRPage(),
        PaymentHistoryPage(),
        AccountPage(),
      ],
    );
  }

  @override
  Widget bottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey[300]!,
              blurRadius: 8,
              offset: const Offset(8, 0)),
        ],
        borderRadius: const BorderRadius.all(
          Radius.circular(0),
        ),
      ),
      child: GetBuilder<MainHomeController>(builder: (controller) {
        return controller.bottomNavigationBar ?? const SizedBox();
      }),
    );
  }

  void genBottomNavBar() {
    controller.bottomNavigationBar = BottomNavigationBar(
        selectedFontSize: 10,
        key: controller._keyBottomTabbar,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        selectedItemColor: colorBlue,
        unselectedLabelStyle: const TextStyle(color: Colors.grey),
        selectedLabelStyle: const TextStyle(color: Colors.blueAccent),
        elevation: 0,
        onTap: (index) {
          // selectedItem = itemsList[index];
          controller._currentIndex = index;
          genBottomNavBar();
          controller.update();
          controller.pageController.jumpToPage(index);
        },
        currentIndex: controller._currentIndex,
        items: controller.itemsList.map((data) {
          final imageName = data.index == controller._currentIndex
              ? 'assets/images/bottom_tabbar/${data.imageNameIsActivated}hv.png'
              : 'assets/images/bottom_tabbar/${data.imageNameIsActivated}.png';
          const size = 20.0;
          return BottomNavigationBarItem(
            icon: Builder(builder: (context) {
              return Center(
                child: Container(
                  padding: EdgeInsets.zero,
                  // color: Colors.red,
                  height: data.index == TabMenuItem.SCANQR.index ? 30 : 20,
                  alignment: Alignment.bottomCenter,
                  child: (data.index == TabMenuItem.SCANQR.index)
                      ? Transform.scale(
                          scale: 1.7,
                          child: Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'assets/images/bottom_tabbar/bg_scan.png'),
                              ),
                              // borderRadius: BorderRadius.circular(10),
                            ),
                            // decoration: BoxDecoration(
                            //     color: colorPayBlue900,
                            //     borderRadius:
                            //         const BorderRadius.all(Radius.circular(11)),
                            //     boxShadow: kElevationToShadow[1]),
                            child: const RotateScaleScanWidget(),
                            // child: const Padding(
                            //   padding: EdgeInsets.all(6),
                            //   child: RotateScaleScanWidget(),
                            // ),
                          ),
                        )
                      : data.imageIcon is String
                          ? Center(
                              child: Image.asset(
                                imageName,
                                // width: size,
                                height: size,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              data.imageIcon,
                              color: data.index == controller._currentIndex
                                  ? colorBlue
                                  : colorGrey,
                              size: 18,
                            ),
                ),
              );
            }),
            label: data.title.isEmpty ? '' : data.title,
          );
        }).toList());
  }
}

class RotateScaleScanWidget extends StatefulWidget {
  const RotateScaleScanWidget({super.key});

  @override
  State<RotateScaleScanWidget> createState() => _RotateScaleScanWidgetState();
}

class _RotateScaleScanWidgetState extends State<RotateScaleScanWidget>
    with TickerProviderStateMixin {
  late AnimationController scaleOutController;
  late AnimationController scaleIntController;
  late AnimationController moveController;
  late Tween<double> scaleOutTween; // <<< Tween for first animation
  late Tween<double> scaleIntTween; // <<< Tween for second animation
  late Tween<double> moveTween; // <<< Tween for third animation
  late Animation<double> scaleOutAnimation; // <<< first animation
  late Animation<double> scaleIntAnimation; // <<< second animation
  late Animation<double> moveAnimation; // <<< third animation
  late final Timer _timer;
  // late ScanIconPr scanIconPr;
  final visibleNotify = ValueNotifier<bool>(false);
  @override
  void initState() {
    _timer = Timer.periodic(const Duration(milliseconds: 3200), (_) {
      scaleOutController
        ..reset()
        ..forward();

      scaleIntController
        ..reset()
        ..forward();
    });
    scaleOutController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    scaleIntController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    moveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    scaleOutTween = Tween<double>(begin: 0.95, end: 0.75)
      ..animate(
          CurvedAnimation(parent: scaleOutController, curve: Curves.bounceOut)
            ..addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                Future.delayed(
                  const Duration(milliseconds: 200),
                  () {
                    visibleNotify.value = true;
                    moveController
                      ..reset()
                      ..forward();
                  },
                );
              }
            }));

    scaleIntTween = Tween<double>(begin: 0.94, end: 1.05)
      ..animate(
          CurvedAnimation(parent: scaleIntController, curve: Curves.bounceOut));

    moveTween = Tween(begin: -12, end: 15)
      ..animate(moveController).addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          moveController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          visibleNotify.value = false;
          Future.delayed(
            const Duration(milliseconds: 200),
            () {
              scaleOutController.reverse();
              scaleIntController.reverse();
            },
          );
        }
      });

    scaleOutAnimation =
        scaleOutController.drive(scaleOutTween); // <<< create out animation
    scaleIntAnimation =
        scaleIntController.drive(scaleIntTween); // <<< create int animation
    moveAnimation = moveController.drive(moveTween);

    scaleOutController.forward();
    scaleIntController.forward();

    super.initState();
  }

  @override
  void dispose() {
    scaleOutController
      ..stop()
      ..dispose();
    scaleIntController
      ..stop()
      ..dispose();
    moveController
      ..stop()
      ..dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ScaleTransition(
          scale: scaleOutAnimation,
          child: AnimatedBuilder(
            animation: scaleOutController,
            builder: (context, child) {
              return const Padding(
                padding: EdgeInsets.all(6),
                child: Image(
                    image:
                        AssetImage('assets/images/bottom_tabbar/scan_qr.png')),
              );
            },
          ),
        ),
        ScaleTransition(
          scale: scaleIntAnimation,
          child: AnimatedBuilder(
            animation: scaleIntController,
            builder: (context, child) {
              return const Padding(
                padding: EdgeInsets.all(6),
                child: Image(
                    image: AssetImage('assets/images/bottom_tabbar/4goc.png')),
              );
            },
          ),
        ),
        ValueListenableBuilder<bool>(
            valueListenable: visibleNotify,
            builder: (context, isVisible, child) {
              return Visibility(
                visible: isVisible,
                child: AnimatedBuilder(
                  animation: moveController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, moveAnimation.value),
                      child: Container(
                        height: 2,
                        width: 30,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white70,
                            Colors.white24,
                            Colors.white12
                          ],
                        )),
                      ),
                    );
                  },
                ),
              );
            }),
      ],
    );
  }
}
