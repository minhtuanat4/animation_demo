import 'dart:async';
import 'dart:ui';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';

class PersistentAppbarPage extends StatefulWidget {
  const PersistentAppbarPage({super.key});

  @override
  State<PersistentAppbarPage> createState() => _PersistentAppbarPageState();
}

class _PersistentAppbarPageState extends State<PersistentAppbarPage>
    with AfterLayoutMixin, SingleTickerProviderStateMixin {
  final lstString = ['Nap/Rut', 'Nhan tien', 'QR Thanh Toan', 'Ví tien ich'];
  final lstSmallIconKey = <GlobalKey>[
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  final lstPositionSmallIcon = <Offset>[
    Offset(0, 0),
    Offset(0, 0),
    Offset(0, 0),
    Offset(0, 0)
  ];

  final lstBigIconKey = <GlobalKey>[
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey()
  ];

  final lstPositionBiglIcon = <Offset>[
    Offset(0, 0),
    Offset(0, 0),
    Offset(0, 0),
    Offset(0, 0)
  ];

  Size smallSizedBoxSize = Size(0, 0);
  Size smallImageSize = Size(0, 0);

  Size bigSizedBoxSize = Size(0, 0);
  Size bigImageSize = Size(0, 0);

  Size sizeApp = Size(0, 0);

  final paddingHorizontal = 12.0;
  final paddingVerticalSmallFrame = 12.0;
  final paddingVerticalBigFrame = 12.0;
  final paddingBetween = 28.0;
  final paddingTop = 8.0;

  double translateY = 0;
  double translateX = 0;

  int smallPeices = 16;

  int numberIcon = 6;

  double spaceBetweenSmallIcon = 0;

  late AnimationController _controller;

  // late Animation<double> _animations;

  final completeValueListen = ValueNotifier<bool>(false);
  final notifyListener = ValueNotifier<double>(0.0);

  final sc = ScrollController();
  void init() {
    _controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    // _animations = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  void listenFunc() {
    _controller.addListener(() {
      if (_controller.isCompleted) {
        completeValueListen.value = true;
      } else {
        completeValueListen.value = false;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double delta = 100.0;
  @override
  void initState() {
    init();
    sc.addListener(() {
      if (sc.position.pixels <= translateY && sc.position.pixels >= 0) {
        notifyListener.value = sc.position.pixels / translateY;
      }
      // if (sc.position.pixels > delta) {
      //   _controller.forward();
      // } else {
      //   _controller.reverse();
      // }
    });
    super.initState();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    final widthAppAfterPadding = (sizeApp.width - (paddingHorizontal * 2));
    final smallIconWidth = widthAppAfterPadding / smallPeices;
    spaceBetweenSmallIcon =
        (widthAppAfterPadding - (smallIconWidth * numberIcon)) / 5;
    final bigIconWidth = widthAppAfterPadding / 10;
    smallSizedBoxSize = Size(smallIconWidth, smallIconWidth);
    bigSizedBoxSize = Size(bigIconWidth, bigIconWidth);

    translateY = smallSizedBoxSize.height + paddingBetween;

    for (var i = 0; i < lstBigIconKey.length; i++) {
      lstPositionBiglIcon[i] = getPositions(lstBigIconKey[i]);
    }

    setState(() {});

    print(lstPositionSmallIcon.toString());
    print(lstPositionBiglIcon.toString());
  }

  @override
  Widget build(BuildContext context) {
    sizeApp = MediaQuery.of(context).size;
    return Scaffold(
        appBar: null,
        body: Stack(
          children: [
            SizedBox(
              height: 240,
              width: double.infinity,
              child: const Image(
                image: AssetImage('assets/images/ice_bg.jpeg'),
                fit: BoxFit.fill,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 80),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.white70],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
              child: SizedBox(
                height: 160,
                width: double.infinity,
              ),
            ),
            RefreshIndicator(
              onRefresh: () {
                print('object');
                return Future.value(false);
              },
              child: CustomScrollView(
                controller: sc,
                // physics: ClampingScrollPhysics(
                //     parent: AlwaysScrollableScrollPhysics()),
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Container(
                      child: Stack(
                        fit: StackFit.loose,
                        children: [
                          ValueListenableBuilder<double>(
                              valueListenable: notifyListener,
                              builder: (context, value, child) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: value == 1
                                        ? Colors.transparent
                                        : Colors.white.withOpacity(1 - value),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  margin: EdgeInsets.only(
                                    left: paddingHorizontal,
                                    right: paddingHorizontal,
                                    // top: MediaQuery.of(context).padding.top +
                                    //     paddingTop -
                                    //     paddingVerticalBigFrame +
                                    //     (translateY) * (1 - _animations.value),
                                    top: MediaQuery.of(context).padding.top +
                                        paddingTop -
                                        paddingVerticalBigFrame +
                                        (translateY),
                                  ),
                                  padding: EdgeInsets.only(
                                      top: paddingVerticalBigFrame,
                                      bottom: paddingVerticalBigFrame),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: paddingHorizontal),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: List.generate(
                                            lstString.length,
                                            (index) => Transform.translate(
                                              offset: Offset(
                                                  ((smallSizedBoxSize.width +
                                                                  spaceBetweenSmallIcon) *
                                                              (index + 1) +
                                                          paddingHorizontal -
                                                          (lstPositionBiglIcon[
                                                                      index]
                                                                  .dx -
                                                              bigSizedBoxSize
                                                                      .width /
                                                                  2 +
                                                              (bigSizedBoxSize
                                                                          .width -
                                                                      smallSizedBoxSize
                                                                          .width) /
                                                                  2)) *
                                                      value,
                                                  0),
                                              child: Container(
                                                // color: index % 2 == 0
                                                //     ? Colors.red
                                                //     : Colors.black,
                                                width: (bigSizedBoxSize.width -
                                                            smallSizedBoxSize
                                                                .width) *
                                                        (1 - value) +
                                                    smallSizedBoxSize.width,
                                                height: (bigSizedBoxSize
                                                                .height -
                                                            smallSizedBoxSize
                                                                .height) *
                                                        (1 - value) +
                                                    smallSizedBoxSize.height,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    print('Object $index');
                                                  },
                                                  child: Image(
                                                    key: lstBigIconKey[index],
                                                    color: Colors.black,
                                                    fit: BoxFit.contain,
                                                    image: AssetImage(
                                                      'assets/images/bottom_tabbar/scan_qr.png',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      value == 1
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 12),
                                              child: NameBalance(),
                                            )
                                          : Opacity(
                                              opacity: 1 - value,
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    top: 4,
                                                    left: paddingHorizontal,
                                                    right: paddingHorizontal),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: List.generate(
                                                    lstString.length,
                                                    (index) => Expanded(
                                                      child: Text(
                                                        lstString[index],
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                      value == 1
                                          ? SizedBox()
                                          : Opacity(
                                              opacity: 1 - value,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12),
                                                child: Column(
                                                  children: [
                                                    Divider(
                                                      thickness: 1,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text.rich(
                                                          TextSpan(
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'ANDROGYNE',
                                                            ),
                                                            children: [
                                                              const TextSpan(
                                                                text:
                                                                    'Xin chào: ',
                                                              ),
                                                              TextSpan(
                                                                  text:
                                                                      'Trần Minh Tuấn'),
                                                            ],
                                                          ),
                                                        ),
                                                        Text(
                                                          '1.000.000đ',
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'ANDROGYNE',
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                );
                              })
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Container(
                      height: 50,
                      color: Colors.red,
                    ),
                  )),
                  SliverToBoxAdapter(
                    child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 200),
                        child: GestureDetector(
                            onTap: () {
                              _controller
                                ..reset()
                                ..forward();
                            },
                            child: Text('Start Animation'))),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 20),
                        child: GestureDetector(
                            onTap: () {
                              _controller.reverse();
                            },
                            child: Text('Revert Animation'))),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 20),
                        child: GestureDetector(
                            onTap: () {
                              _controller.reverse();
                            },
                            child: Text('Revert Animation'))),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 20),
                        child: GestureDetector(
                            onTap: () {
                              _controller.reverse();
                            },
                            child: Text('Revert Animation'))),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 20),
                        child: GestureDetector(
                            onTap: () {
                              _controller.reverse();
                            },
                            child: Text('Revert Animation'))),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 20),
                        child: GestureDetector(
                            onTap: () {
                              _controller.reverse();
                            },
                            child: Text('Revert Animation'))),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 20),
                        child: GestureDetector(
                            onTap: () {
                              _controller.reverse();
                            },
                            child: Text('Revert Animation'))),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 20),
                        child: GestureDetector(
                            onTap: () {
                              _controller.reverse();
                            },
                            child: Text('Revert Animation'))),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 20),
                        child: GestureDetector(
                            onTap: () {
                              _controller.reverse();
                            },
                            child: Text('Revert Animation'))),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 20),
                        child: GestureDetector(
                            onTap: () {
                              _controller.reverse();
                            },
                            child: Text('Revert Animation'))),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 200),
                        child: GestureDetector(
                            onTap: () {
                              _controller.reverse();
                            },
                            child: Text('Revert Animation'))),
                  ),
                ],
              ),
            ),
            ValueListenableBuilder<double>(
              // animation: _animations,
              valueListenable: notifyListener,
              builder: (context, value, child) {
                print('object $value');

                /// Small Small Small
                return Column(
                  children: [
                    Container(
                      color: Colors.blue.shade300.withOpacity(value),
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + paddingTop,
                          bottom: paddingVerticalSmallFrame),
                      child: Container(
                        margin: EdgeInsets.only(
                          left: paddingHorizontal,
                          right: paddingHorizontal,
                        ),
                        height: smallSizedBoxSize.height,
                        child: Stack(
                          children: [
                            Positioned(
                              left: (smallSizedBoxSize.width +
                                      spaceBetweenSmallIcon) *
                                  1,
                              width: smallSizedBoxSize.width,
                              height: smallSizedBoxSize.height,
                              child: GestureDetector(
                                onTap: () {
                                  print('Object Big 0');
                                },
                                child: value == 0
                                    ? const SizedBox()
                                    : value == 1
                                        ? Image(
                                            fit: BoxFit.contain,
                                            color: Colors.black,
                                            image: AssetImage(
                                              'assets/images/bottom_tabbar/scan_qr.png',
                                            ),
                                          )
                                        : const SizedBox(),
                              ),
                            ),
                            Positioned(
                              left: (smallSizedBoxSize.width +
                                      spaceBetweenSmallIcon) *
                                  2,
                              width: smallSizedBoxSize.width,
                              height: smallSizedBoxSize.height,
                              child: GestureDetector(
                                onTap: () {
                                  print('Object Big 1');
                                },
                                child: value == 0
                                    ? const SizedBox()
                                    : value >= 0.5
                                        ? Image(
                                            fit: BoxFit.contain,
                                            color: Colors.black,
                                            image: AssetImage(
                                              'assets/images/bottom_tabbar/scan_qr.png',
                                            ),
                                          )
                                        : const SizedBox(),
                              ),
                            ),
                            Positioned(
                              left: (smallSizedBoxSize.width +
                                      spaceBetweenSmallIcon) *
                                  3,
                              width: smallSizedBoxSize.width,
                              height: smallSizedBoxSize.height,
                              child: GestureDetector(
                                onTap: () {
                                  print('Object Big 2');
                                },
                                child: value == 0
                                    ? const SizedBox()
                                    : value == 1
                                        ? Image(
                                            fit: BoxFit.contain,
                                            color: Colors.black,
                                            image: AssetImage(
                                              'assets/images/bottom_tabbar/scan_qr.png',
                                            ),
                                          )
                                        : const SizedBox(),
                              ),
                            ),
                            Positioned(
                              left: (smallSizedBoxSize.width +
                                      spaceBetweenSmallIcon) *
                                  4,
                              width: smallSizedBoxSize.width,
                              height: smallSizedBoxSize.height,
                              child: GestureDetector(
                                onTap: () {
                                  print('Object Big 3');
                                },
                                child: value > 0
                                    ? const SizedBox()
                                    : value == 1
                                        ? Image(
                                            fit: BoxFit.contain,
                                            color: Colors.black,
                                            image: AssetImage(
                                              'assets/images/bottom_tabbar/scan_qr.png',
                                            ),
                                          )
                                        : const SizedBox(),
                              ),
                            ),
                            Positioned(
                              left: (1 - value) *
                                  ((smallSizedBoxSize.width +
                                              spaceBetweenSmallIcon) *
                                          5 -
                                      smallSizedBoxSize.width -
                                      12),
                              width: smallSizedBoxSize.width,
                              height: smallSizedBoxSize.height,
                              child: GestureDetector(
                                onTap: () {
                                  print('Object 0');
                                },
                                child: Image(
                                  fit: BoxFit.contain,
                                  color: Colors.black,
                                  image: AssetImage(
                                    'assets/images/bottom_tabbar/scan_qr.png',
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: (smallSizedBoxSize.width +
                                      spaceBetweenSmallIcon) *
                                  5,
                              width: smallSizedBoxSize.width,
                              height: smallSizedBoxSize.height,
                              child: GestureDetector(
                                onTap: () {
                                  print('Object 5');
                                },
                                child: Image(
                                  fit: BoxFit.contain,
                                  color: Colors.black,
                                  image: AssetImage(
                                    'assets/images/bottom_tabbar/scan_qr.png',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    value == 0
                        ? SizedBox()
                        : Opacity(
                            opacity: value,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: NameBalance(),
                            )),
                  ],
                );
              },
            ),
          ],
        ));
  }

  Size getSizes(GlobalKey key) {
    try {
      final renderBoxRed = key.currentContext!.findRenderObject() as RenderBox;
      final sizeRed = renderBoxRed.size;
      return sizeRed;
    } catch (e) {
      return Size.zero;
    }
  }

  static Offset getPositions(GlobalKey key) {
    try {
      final renderBoxRed = key.currentContext!.findRenderObject() as RenderBox;
      final positionRed = renderBoxRed.localToGlobal(Offset.zero);
      return positionRed;
    } catch (e) {
      return Offset.zero;
    }
  }
}

class NameBalance extends StatelessWidget {
  const NameBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(12),
              bottomLeft: Radius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text.rich(
              TextSpan(
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ANDROGYNE',
                ),
                children: [
                  const TextSpan(
                    text: 'Xin chào: ',
                  ),
                  TextSpan(text: 'Trần Minh Tuấn'),
                ],
              ),
            ),
            Text(
              '1.000.000đ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'ANDROGYNE',
              ),
            )
          ],
        ));
  }
}

// child: Padding(
//   padding: EdgeInsets.only(
//       top: MediaQuery.of(context).padding.top,
//       bottom: paddingVertical),
//   child: Container(
//     margin: EdgeInsets.only(
//       left: paddingHorizontal,
//       right: paddingHorizontal,
//     ),
//     height: smallSizedBoxSize.height,
//     child: Stack(
//       children: List.generate(
//         6,
//         (index) => Visibility(
//           visible: index == 0 ? true : false,
//           child: Positioned(
//             left: (smallSizedBoxSize.width +
//                     spaceBetweenSmallIcon) *
//                 index,
//             width: smallSizedBoxSize.width,
//             height: smallSizedBoxSize.height,
//             child: Image(
//               fit: BoxFit.contain,
//               color: Colors.black,
//               image: AssetImage(
//                 'assets/images/bottom_tabbar/scan_qr.png',
//               ),
//             ),
//           ),
//         ),
//       ),
//     ),
//   ),
// ),
