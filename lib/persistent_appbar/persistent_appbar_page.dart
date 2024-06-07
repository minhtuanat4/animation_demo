import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';

class PersistentAppbarPage extends StatefulWidget {
  const PersistentAppbarPage({super.key});

  @override
  State<PersistentAppbarPage> createState() => _PersistentAppbarPageState();
}

class _PersistentAppbarPageState extends State<PersistentAppbarPage>
    with AfterLayoutMixin, SingleTickerProviderStateMixin {
  final lstString = ['Nap/Rut', 'Nhan tien', 'QR Thanh Toan', 'VI tien ich'];
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
  final paddingVertical = 12.0;
  final paddingBetween = 30.0;

  double translateY = 0;
  double translateX = 0;

  int smallPeices = 16;

  int numberIcon = 6;

  double spaceBetweenSmallIcon = 0;

  late AnimationController _controller;

  late Animation<double> _animations;

  final completeValueListen = ValueNotifier<bool>(false);

  void init() {
    _controller =
        AnimationController(duration: Duration(milliseconds: 800), vsync: this);
    _animations = Tween<double>(begin: 0, end: 1).animate(_controller);
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

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    final widthAppAfterPadding = (sizeApp.width - (paddingHorizontal * 2));
    final smallIconWidth = widthAppAfterPadding / smallPeices;
    spaceBetweenSmallIcon =
        (widthAppAfterPadding - (smallIconWidth * numberIcon)) / 5;
    final bigIconWidth = widthAppAfterPadding / 8;
    smallSizedBoxSize = Size(smallIconWidth, smallIconWidth);
    bigSizedBoxSize = Size(bigIconWidth, bigIconWidth);

    translateY = smallSizedBoxSize.height + paddingBetween + paddingVertical;

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
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Stack(
                fit: StackFit.loose,
                children: [
                  AnimatedBuilder(
                    animation: _animations,
                    builder: (context, child) {
                      return Container(
                        color: Colors.amber.withOpacity(_animations.value),
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top,
                            bottom: paddingVertical),
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
                                    child: Container(
                                      color: Colors.transparent,
                                    )),
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
                                    child: Container(
                                      color: Colors.transparent,
                                    )),
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
                                    child: Container(
                                      color: Colors.transparent,
                                    )),
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
                                    child: Container(
                                      color: Colors.transparent,
                                    )),
                              ),
                              Positioned(
                                left: (1 - _animations.value) *
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
                      );
                    },
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
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top +
                            smallSizedBoxSize.height +
                            paddingVertical),
                    child: AnimatedBuilder(
                        animation: _animations,
                        builder: (context, child) {
                          return Container(
                            color: _animations.value == 1
                                ? Colors.transparent
                                : Colors.blue.shade200
                                    .withOpacity(1 - _animations.value),
                            margin: EdgeInsets.only(
                              left: paddingHorizontal,
                              right: paddingHorizontal,
                              top: paddingBetween,
                            ),
                            child: Transform.translate(
                              offset:
                                  Offset(0, -(translateY) * _animations.value),
                              child: Transform.translate(
                                offset: Offset(0, 0),
                                child: Column(
                                  children: [
                                    Row(
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
                                                  _animations.value,
                                              0),
                                          child: Container(
                                            // color: index % 2 == 0
                                            //     ? Colors.red
                                            //     : Colors.black,
                                            width: (bigSizedBoxSize.width -
                                                        smallSizedBoxSize
                                                            .width) *
                                                    (1 - _animations.value) +
                                                smallSizedBoxSize.width,
                                            height: (bigSizedBoxSize.height -
                                                        smallSizedBoxSize
                                                            .height) *
                                                    (1 - _animations.value) +
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
                                    Transform.translate(
                                      offset: Offset(0, 0),
                                      child: Opacity(
                                        opacity: 1 - _animations.value,
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: List.generate(
                                              lstString.length,
                                              (index) => Expanded(
                                                child: Text(
                                                  lstString[index],
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),

            /// BIG BIG BIG BIG
            // SliverToBoxAdapter(
            //   child: AnimatedBuilder(
            //     animation: _animations,
            //     builder: (context, _) {
            //       return Transform.translate(
            //         offset: Offset(0, -(translateY) * _animations.value),
            //         child: Container(
            //           color: Colors.blue.shade200
            //               .withOpacity(1 - _animations.value),
            //           margin: EdgeInsets.only(
            //             left: paddingHorizontal,
            //             right: paddingHorizontal,
            //             top: paddingBetween,
            //           ),
            //           child: Transform.translate(
            //             offset: Offset(0, 0),
            //             child: Column(
            //               children: [
            //                 Container(
            //                   // color: Colors.blue.shade700,
            //                   child: Row(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceAround,
            //                     children: List.generate(
            //                       lstString.length,
            //                       (index) => Container(
            //                         // color: Colors.amber,
            //                         child: Transform.translate(
            //                           offset: Offset(
            //                               ((smallSizedBoxSize.width +
            //                                               spaceBetweenSmallIcon) *
            //                                           (index + 1) +
            //                                       paddingHorizontal -
            //                                       (lstPositionBiglIcon[index]
            //                                               .dx -
            //                                           bigSizedBoxSize.width /
            //                                               2 +
            //                                           (bigSizedBoxSize.width -
            //                                                   smallSizedBoxSize
            //                                                       .width) /
            //                                               2)) *
            //                                   _animations.value,
            //                               0),
            //                           child: Container(
            //                             // color: index % 2 == 0
            //                             //     ? Colors.red
            //                             //     : Colors.black,
            //                             width: (bigSizedBoxSize.width -
            //                                         smallSizedBoxSize.width) *
            //                                     (1 - _animations.value) +
            //                                 smallSizedBoxSize.width,
            //                             height: (bigSizedBoxSize.height -
            //                                         smallSizedBoxSize.height) *
            //                                     (1 - _animations.value) +
            //                                 smallSizedBoxSize.height,
            //                             child: Image(
            //                               key: lstBigIconKey[index],
            //                               color: Colors.black,
            //                               fit: BoxFit.contain,
            //                               image: AssetImage(
            //                                 'assets/images/bottom_tabbar/scan_qr.png',
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //                 Transform.translate(
            //                   offset: Offset(0, 0),
            //                   child: Opacity(
            //                     opacity: 1 - _animations.value,
            //                     child: Row(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: List.generate(
            //                         lstString.length,
            //                         (index) => Expanded(
            //                           child: Text(
            //                             lstString[index],
            //                             textAlign: TextAlign.center,
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),

            // SliverToBoxAdapter(
            //   child: Container(
            //     margin: EdgeInsets.only(
            //         left: (lstPositionBiglIcon[2].dx) -
            //             bigSizedBoxSize.width / 2),
            //     child: Container(
            //       color: Colors.red,
            //       child: GestureDetector(
            //         onTap: () {
            //           _controller
            //             ..reset()
            //             ..forward();
            //         },
            //         child: Text('BIG'),
            //       ),
            //     ),
            //   ),
            // ),
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
