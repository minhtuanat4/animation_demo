import 'dart:async';

import 'package:flutter/material.dart';

class ImageObject {
  final String name;
  final String assetName;
  ImageObject({required this.name, required this.assetName});
  String get formAssetName => 'assets/images/$assetName.jpeg';
}

final List<ImageObject> listImageObject = [
  ImageObject(assetName: 'ice_bg', name: 'Ice Landscape'),
  ImageObject(assetName: 'foggy_bg', name: 'Foggy Landscape'),
  ImageObject(assetName: 'river_bg', name: 'River Landscape'),
];

class MyPageView extends StatefulWidget {
  const MyPageView({Key? key}) : super(key: key);

  @override
  State<MyPageView> createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView>
    with SingleTickerProviderStateMixin {
  double slideValue = 0.0;
  final _pageController = PageController();
  final _notifierScroll = ValueNotifier(0.0);
  late Timer _timer;
  int _currentPage = 0;

  void _listenPageControl() {
    if (_pageController.page != null) {
      _notifierScroll.value = _pageController.page!;
    }
  }

  void _listenTimer(Timer timer) {
    if (_currentPage < 2) {
      _currentPage++;
    } else {
      _currentPage = 0;
    }
    _pageController.animateToPage(_currentPage,
        duration: const Duration(seconds: 2), curve: Curves.linearToEaseOut);
  }

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 2), _listenTimer);

    _pageController.addListener(_listenPageControl);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.removeListener(_listenPageControl);
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: null,
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   listImageObject[0].formAssetName,
            //   fit: BoxFit.cover,
            // ),
            SizedBox(
              height: size.height * 0.4,
              width: size.width * 0.8,
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.transparent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 20,
                            offset: Offset(0, 10),
                            spreadRadius: 10,
                          )
                        ]),
                  ),
                  PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      // final slideValue  = lerpDouble(0.0, 2*pi, t)

                      return ValueListenableBuilder<double>(
                        valueListenable: _notifierScroll,
                        builder: (context, value, child4) {
                          final percentage = value - index;
                          final rotation = percentage.clamp(0.0, 1.0);
                          return Opacity(
                            opacity: 1 - rotation,
                            child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..rotateX(rotation * 1.8),
                                child: child4),
                          );
                        },
                        child: Image.asset(
                          listImageObject[index].formAssetName,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                    itemCount: listImageObject.length,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            GestureDetector(
              onTap: () {
                _timer.cancel();
              },
              child: Container(
                height: 50,
                width: 100,
                color: Colors.red,
              ),
            ),
            GestureDetector(
              onTap: () {
                _timer.tick;
              },
              child: Container(
                height: 50,
                width: 100,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
