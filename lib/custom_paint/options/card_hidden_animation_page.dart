import 'dart:math';

import 'package:flutter/material.dart';

class CardHiddenAnimationPage extends StatefulWidget {
  const CardHiddenAnimationPage({super.key});

  @override
  State<CardHiddenAnimationPage> createState() =>
      _CardHiddenAnimationPageState();
}

class _CardHiddenAnimationPageState extends State<CardHiddenAnimationPage>
    with TickerProviderStateMixin {
  final cardSize = 150.0;

  late AnimationController holeOffsetACtrol = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300));

  late AnimationController cardOffsetACtrol = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1000));

  late Tween<double> holeTween;
  late Tween<double> cardElevationTween;
  late Tween<double> cardRotationTween;
  late Tween<double> cardPositionTween;

  final holeWidthNotify = ValueNotifier<double>(0.0);
  @override
  void initState() {
    holeTween = Tween<double>(begin: 0, end: cardSize * 1.25);
    cardElevationTween = Tween<double>(begin: 20, end: 2);
    cardRotationTween = Tween<double>(begin: pi / 2, end: 0);
    cardPositionTween = Tween<double>(begin: cardSize * 2, end: 0);
    holeTween.animate(holeOffsetACtrol);
    cardElevationTween.animate(cardOffsetACtrol);
    cardRotationTween.animate(cardOffsetACtrol);
    cardPositionTween.animate(cardOffsetACtrol);
    holeOffsetACtrol.addListener(() {
      holeWidthNotify.value = getHoleWidth;
    });
    cardOffsetACtrol.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    holeOffsetACtrol.dispose();
    cardOffsetACtrol.dispose();
    super.dispose();
  }

  double get getHoleWidth => holeTween.evaluate(holeOffsetACtrol);

  double get getElevationCard => cardElevationTween.evaluate(cardOffsetACtrol);

  double get getRotationCard => cardRotationTween.evaluate(cardOffsetACtrol);

  double get getPositionCard => cardPositionTween.evaluate(cardOffsetACtrol);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('CardHiddenAnimationPage')),
        body: Center(
          child: SizedBox(
              height: cardSize * 1.25,
              width: double.infinity,
              child: ClipPath(
                clipper: BlackHoleClipper(),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ValueListenableBuilder<double>(
                      valueListenable: holeWidthNotify,
                      builder: (context, value, child) {
                        return SizedBox(width: value, child: child);
                      },
                      child: const Image(
                        image: AssetImage(
                          'assets/images/hole.png',
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                        child: Center(
                      child: Transform.translate(
                        offset: Offset(0, getPositionCard),
                        child: Transform.rotate(
                          angle: getRotationCard,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: CardTextAnimation(
                              elevation: getElevationCard,
                              cardSize: cardSize / 1.25,
                            ),
                          ),
                        ),
                      ),
                    ))
                  ],
                ),
              )),
        ),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            onPressed: () async {
              await holeOffsetACtrol.forward();
              await cardOffsetACtrol.reverse();
              Future.delayed(
                const Duration(milliseconds: 200),
                () {
                  holeOffsetACtrol.reverse();
                },
              );
            },
            heroTag: "fab1",
            child: const Icon(Icons.remove),
          ),
          FloatingActionButton(
            onPressed: () async {
              await cardOffsetACtrol.forward();
            },
            heroTag: "fab2",
            child: const Icon(Icons.add),
          ),
        ]));
  }
}

class CardTextAnimation extends StatefulWidget {
  final double cardSize;
  final double elevation;
  const CardTextAnimation(
      {super.key, required this.cardSize, required this.elevation});

  @override
  State<CardTextAnimation> createState() => _CardTextAnimationState();
}

class _CardTextAnimationState extends State<CardTextAnimation> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: widget.elevation,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox.square(
        dimension: widget.cardSize,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue,
          ),
          child: const Center(
            child: Text(
              'Hello\nWorld',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}

class BlackHoleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height / 2);
    path.arcTo(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: size.height,
      ),
      0,
      pi,
      true,
    );
    // Using -1000 guarantees the card won't be clipped at the top, regardless of its height
    path.lineTo(0, -1000);
    path.lineTo(size.width, -1000);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(BlackHoleClipper oldClipper) => false;
}

class DrawArcTo extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;
    Path path = Path();
    path.moveTo(0, size.height / 2);
    path.arcTo(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: size.width,
            height: size.height),
        0,
        pi,
        true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
