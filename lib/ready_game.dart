import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:animation_demo/flame_main.dart';
import 'package:flutter/material.dart';

class ReadyGame extends StatefulWidget {
  // Reference to parent game.
  final MoleGame game;
  const ReadyGame({super.key, required this.game});

  @override
  State<ReadyGame> createState() => _ReadyGameState();
}

class _ReadyGameState extends State<ReadyGame>
    with SingleTickerProviderStateMixin, AfterLayoutMixin {
  late AnimationController ctrolNormal;
  late Animation<double> aniNormal;

  late int myDuration;
  int totalDuration = 4;
  late ValueNotifier<String> timerNotify;
  Timer? timer;
  String textReady = 'Bắt đầu...';

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    isFirstTime = false;
  }

  bool isFirstTime = true;

  @override
  void initState() {
    timerNotify = ValueNotifier<String>('3');
    myDuration = 3;
    ctrolNormal =
        AnimationController(vsync: this, duration: Duration(milliseconds: 160));
    aniNormal = Tween<double>(begin: 0.2, end: 1).animate(ctrolNormal);

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        totalDuration = totalDuration - 1;
        myDuration = myDuration - 1;
        if (totalDuration == 0) {
          _startGame();
          // Times up
        } else if (totalDuration == 1) {
          timerNotify.value = textReady;
        } else {
          // final minutes = strDigits(myDuration.inMinutes.remainder(60));
          timerNotify.value = '$myDuration';
        }
      },
    );
    ctrolNormal.forward();
    super.initState();
  }

  void _startGame() {
    timer?.cancel();
    widget.game.overlays.remove('ReadyGame');
    widget.game.startNotify.value = true;
  }

  @override
  void dispose() {
    timer?.cancel();
    ctrolNormal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black38,
      child: Center(
        child: ValueListenableBuilder<String>(
            valueListenable: timerNotify,
            builder: (context, value, _) {
              double fontSize = 96;
              if (value == textReady) {
                fontSize = 58;
              }
              if (!isFirstTime) {
                ctrolNormal
                  ..reset()
                  ..forward();
              }
              return AnimatedBuilder(
                animation: aniNormal,
                builder: (context, value) {
                  return Transform.scale(
                    scale: aniNormal.value,
                    child: Text(
                      '${timerNotify.value}',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: fontSize,
                        fontFamily: fontGame,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
