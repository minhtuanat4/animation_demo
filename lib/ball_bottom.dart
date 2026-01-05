import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animation_demo/common/color_extension.dart';
import 'package:animation_demo/flame_main.dart';
import 'package:flutter/material.dart';

class BallBottom extends StatefulWidget {
  final MoleGame game;
  const BallBottom({
    super.key,
    required this.game,
  });

  @override
  State<BallBottom> createState() => _BallBottomState();
}

class _BallBottomState extends State<BallBottom>
    with SingleTickerProviderStateMixin {
  final colorizeColors = [
    Colors.white,
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];
  final colorizeTextStyle =
      TextStyle(fontSize: 13.0, fontWeight: FontWeight.w900);

  double scale = 2.2;
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Material(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              bottom: 16,
              child: Container(
                height: 44,
                // width: MediaQuery.sizeOf(context).width / 1.5,
                decoration: BoxDecoration(
                  color: HexColor.fromHex('#F36500'),
                  border: Border.all(
                      width: 2.4,
                      color: const Color.fromARGB(247, 255, 255, 255)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 255, 255, 255)
                          .withValues(alpha: 0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                    BoxShadow(
                      color: const Color.fromARGB(255, 255, 255, 255)
                          .withValues(alpha: 0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, -1), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.all(
                    Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 12, bottom: 2, top: 2),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 1),
                        child: Stack(
                          children: [
                            Transform.scale(
                              scale: scale,
                              child: Image.asset(
                                  'assets/images/event/event_tet2026/animal/bling_2.png'),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Transform.scale(
                              scale: scale / 2.3,
                              child: Image.asset(
                                  'assets/images/event/event_tet2026/animal/ball.png'),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      AnimatedTextKit(
                        repeatForever: true,
                        pause: Duration(milliseconds: 100),
                        animatedTexts: [
                          ColorizeAnimatedText(
                            'Bạn đã trúng quà đặc biệt',
                            textStyle: colorizeTextStyle,
                            colors: colorizeColors,
                          ),
                        ],
                        isRepeatingAnimation: true,
                        onTap: () {
                          print("Tap Event");
                        },
                      ),
                      // Text(
                      //   'Bạn đã trúng quà đặc biệt',
                      //   style: TextStyle(
                      //       color: Colors.white,
                      //       fontSize: 12,
                      //       fontWeight: FontWeight.w900),
                      // )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
