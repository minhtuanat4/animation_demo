// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/sliver_persistent_header.dart';

const paddingHorizontal = 12.0;

class PersistentHeaderPage extends StatefulWidget {
  const PersistentHeaderPage({super.key});

  @override
  State<PersistentHeaderPage> createState() => _PersistentHeaderPageState();
}

class _PersistentHeaderPageState extends State<PersistentHeaderPage>
    with AfterLayoutMixin {
  final currentScrollPixel = ValueNotifier<double>(0.0);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final paddingTop = MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          ValueListenableBuilder<double>(
            valueListenable: currentScrollPixel,
            builder: (context, pixels, child) {
              return Positioned(
                top: pixels,
                left: 0,
                right: 0,
                child: child ?? const SizedBox(),
              );
            },
            child: SizedBox(
              height: 260,
              width: double.infinity,
              child: const Image(
                image: AssetImage('assets/images/ice_bg.jpeg'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              scrollNotification.metrics.pixels;

              final pixels = scrollNotification.metrics.pixels;
              if (pixels <= 0) {
                currentScrollPixel.value = 0;
              } else if (pixels < 5000) {
                currentScrollPixel.value = -pixels;
              }

              return true;
            },
            child: RefreshIndicator(
              onRefresh: () {
                print('object');
                return Future.value(false);
              },
              child: CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    delegate: PersistenHeader(
                      minExtentParam: 136,
                      maxExtentParam: 260,
                      paddingTop: paddingTop,
                      sizeWidth: size.width,
                    ),
                    pinned: true,
                    floating: false,
                  ),
                  for (var i = 0; i < 20; i++)
                    SliverToBoxAdapter(
                      child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 50),
                          child: GestureDetector(
                              onTap: () {}, child: Text('Start Animation'))),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {}
}

class PersistenHeader implements SliverPersistentHeaderDelegate {
  final double minExtentParam;
  final double maxExtentParam;
  final double sizeWidth;
  final double paddingTop;
  PersistenHeader({
    required this.minExtentParam,
    required this.maxExtentParam,
    required this.sizeWidth,
    required this.paddingTop,
  });

  final sizeBig = Size(36, 36);
  final sizeSmall = Size(24, 24);

  final paddingBetween = 12.0;
  final paddingVerticalBigFrame = 12.0;
  final lstString = ['Nap/Rut', 'Nhan tien', 'QR Thanh Toan', 'Ví tien ich'];
  late double heightSmall = 250 / 10;
  late double heightBig = 250 / 8;
  late double spaceBetweenSmall =
      ((sizeWidth - paddingHorizontal * 2) - heightSmall * 6) / 5;
  late double spaceBetweenBig =
      ((sizeWidth - paddingHorizontal * 2) - heightBig * 4) / 4;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final value = ((shrinkOffset) /
            (heightSmall + paddingBetween + paddingVerticalBigFrame))
        .clamp(0, 1)
        .toDouble();
    final valueBiggerSpace =
        ((shrinkOffset) / (maxExtent - minExtent)).clamp(0, 1).toDouble();
    // up = 1, down = 0
    print('object  $value');
    print('shrinkOffset  $shrinkOffset');

    return Stack(
      // fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: minExtent,
            child: Column(
              children: [
                SizedBox(
                  height: minExtent - 36,
                  child: Container(
                    color: Colors.blue.shade300.withOpacity(valueBiggerSpace),
                  ),
                ),
                Opacity(
                    opacity: value,
                    child: GestureDetector(
                        onTap: () {
                          print('object');
                        },
                        child: NameBalance()))
              ],
            ),
          ),
        ),
        Positioned(
          top: (paddingTop - paddingVerticalBigFrame) +
              (heightSmall + paddingBetween + paddingVerticalBigFrame) *
                  (1 - value),
          left: 0,
          right: 0,
          child: Opacity(
            opacity: 1,
            child: Container(
              // alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(1 - value),
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              margin: EdgeInsets.only(
                left: paddingHorizontal,
                right: paddingHorizontal,
              ),
              padding: EdgeInsets.symmetric(vertical: paddingVerticalBigFrame),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(4, (index) {
                      double dxBig = 0;
                      final dxSmall = paddingHorizontal +
                          (heightSmall + spaceBetweenSmall) * (index + 1);

                      if (index == 0) {
                        dxBig = paddingHorizontal + spaceBetweenBig / 2;
                      } else {
                        dxBig = paddingHorizontal +
                            spaceBetweenBig / 2 +
                            (spaceBetweenBig + heightBig) * index;
                      }
                      return Transform.translate(
                        offset: Offset(value * (dxSmall - (dxBig)), 0),
                        child: SizedBox(
                          height: heightSmall +
                              (heightBig - heightSmall) * (1 - value),
                          width: heightSmall +
                              (heightBig - heightSmall) * (1 - value),
                          child: GestureDetector(
                            onTap: () {
                              print('Object $index');
                            },
                            child: Image(
                              color: Colors.black,
                              fit: BoxFit.contain,
                              image: AssetImage(
                                'assets/images/bottom_tabbar/scan_qr.png',
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Opacity(
                    opacity: 1 - value,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            children: [
                              Divider(
                                thickness: 1,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: paddingTop,
          left: paddingHorizontal,
          child: GestureDetector(
            onTap: () {
              print('Small 1');
            },
            child: SizedBox(
              width: heightSmall,
              height: heightSmall,
              child: Image(
                color: Colors.black,
                fit: BoxFit.contain,
                image: AssetImage(
                  'assets/images/bottom_tabbar/scan_qr.png',
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: paddingTop,
          right: paddingHorizontal,
          child: GestureDetector(
            onTap: () {
              print('Small 2');
            },
            child: SizedBox(
              height: heightSmall,
              width: heightSmall,
              child: Image(
                color: Colors.black,
                fit: BoxFit.contain,
                image: AssetImage(
                  'assets/images/bottom_tabbar/scan_qr.png',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => maxExtentParam;

  @override
  // TODO: implement minExtent
  double get minExtent => minExtentParam;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  // TODO: implement showOnScreenConfiguration
  PersistentHeaderShowOnScreenConfiguration? get showOnScreenConfiguration =>
      null;

  @override
  // TODO: implement snapConfiguration
  FloatingHeaderSnapConfiguration? get snapConfiguration => null;

  @override
  // TODO: implement stretchConfiguration
  OverScrollHeaderStretchConfiguration? get stretchConfiguration => null;

  @override
  // TODO: implement vsync
  TickerProvider? get vsync => null;
}

class NameBalance extends StatelessWidget {
  const NameBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.red,
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
