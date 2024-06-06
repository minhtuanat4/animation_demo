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
  final paddingBetween = 30.0;

  double translateY = 0;
  double translateX = 0;

  late AnimationController _controller;

  late Animation<double> _animations;

  void init() {
    _controller =
        AnimationController(duration: Duration(milliseconds: 800), vsync: this);
    _animations = Tween<double>(begin: 0, end: 1).animate(_controller);
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
    final smallIconWidth = widthAppAfterPadding / 11;
    final bigIconWidth = widthAppAfterPadding / 8;
    smallSizedBoxSize = Size(smallIconWidth, smallIconWidth);
    bigSizedBoxSize = Size(bigIconWidth, bigIconWidth);

    translateY = bigSizedBoxSize.height + paddingBetween;

    // smallImageSize = getSizes(lstSmallIconKey[0]);
    // bigImageSize = getSizes(lstBigIconKey[0]);
    // for (var i = 0; i < lstSmallIconKey.length; i++) {
    //   lstPositionSmallIcon[i] = getPositions(lstSmallIconKey[i]);
    // }

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
              child: Container(
                // width: double.infinity,
                height: smallSizedBoxSize.height,
                color: Colors.blue.shade200,
                margin: EdgeInsets.only(
                  left: paddingHorizontal,
                  right: paddingHorizontal,
                  top: MediaQuery.of(context).padding.top,
                ),
                child: Stack(
                  children:
                      // [
                      //   Positioned(
                      //     left: 0,
                      //     top: 0,
                      //     // color: index % 2 == 0 ? Colors.red : Colors.black,
                      //     width: 20, height: 20,

                      //     child: Image(
                      //       // key: index == 0 || index == 5
                      //       //     ? null
                      //       //     : lstSmallIconKey[index - 1],
                      //       fit: BoxFit.contain,
                      //       color: Colors.black,
                      //       image: AssetImage(
                      //         'assets/images/bottom_tabbar/scan_qr.png',
                      //       ),
                      //     ),
                      //   ),
                      // ]

                      List.generate(
                    6,
                    (index) => Positioned(
                      left: smallSizedBoxSize.width * index * 2,
                      // color: index % 2 == 0 ? Colors.red : Colors.black,
                      width: smallSizedBoxSize.width,
                      height: smallSizedBoxSize.height,

                      child: Image(
                        // key: index == 0 || index == 5
                        //     ? null
                        //     : lstSmallIconKey[index - 1],
                        fit: BoxFit.contain,
                        color: Colors.black,
                        image: AssetImage(
                          'assets/images/bottom_tabbar/scan_qr.png',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(
                    left:
                        (smallSizedBoxSize.width * 4 * 2) + paddingHorizontal),
                child: Container(
                  color: Colors.red,
                  child: GestureDetector(
                    onTap: () {
                      _controller
                        ..reset()
                        ..forward();
                    },
                    child: Text('Small'),
                  ),
                ),
              ),
            ),

            /// BIG BIG BIG BIG
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                  animation: _animations,
                  builder: (context, _) {
                    return Transform.translate(
                      offset: Offset(0, -translateY * _animations.value),
                      child: Container(
                        color: Colors.blue.shade200
                            .withOpacity(1 - _animations.value),
                        margin: EdgeInsets.only(
                          left: paddingHorizontal,
                          right: paddingHorizontal,
                          top: paddingBetween,
                        ),
                        child: Transform.translate(
                          offset: Offset(0, 0),
                          child: Column(
                            children: [
                              Container(
                                // color: Colors.blue.shade700,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: List.generate(
                                    lstString.length,
                                    (index) => Transform.translate(
                                      offset: Offset(0, 0),
                                      child: Container(
                                        color: index % 2 == 0
                                            ? Colors.red
                                            : Colors.black,
                                        width: bigSizedBoxSize.width,
                                        height: bigSizedBoxSize.height,
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
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),

            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(left: (lstPositionBiglIcon[2].dx)),
                child: Container(
                  color: Colors.red,
                  child: GestureDetector(
                    onTap: () {
                      _controller
                        ..reset()
                        ..forward();
                    },
                    child: Text('BIG'),
                  ),
                ),
              ),
            ),
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
