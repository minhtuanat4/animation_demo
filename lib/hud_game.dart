import 'dart:async';
import 'dart:math';

import 'package:animation_demo/flame_main.dart';
import 'package:flutter/material.dart';

const milliseconds = 360;

const timeDurationnDefault = Duration(milliseconds: milliseconds);

class HUDGame extends StatefulWidget {
  final int time;
  // Reference to parent game.
  final MoleGame game;
  const HUDGame({super.key, required this.game, required this.time});

  @override
  State<HUDGame> createState() => _HUDGameState();
}

class _HUDGameState extends State<HUDGame> with TickerProviderStateMixin {
  String strDigits(int n) => n.toString().padLeft(2, '0');

  Offset size = Offset(0, 0);

  int myDuration = 0;
  Timer? timer;

  bool isFirstTime = true;

  int ballTime = startRandomMode + 10;

  _randomBallTime() {
    ballTime = Random().nextInt(10) + (startRandomMode + 7);
  }

  @override
  void initState() {
    _randomBallTime();
    myDuration = widget.time;
    print('Ball $ballTime');
    size = Offset(
      widget.game.size.x,
      widget.game.size.y * 566 / 2048,
    );
    widget.game.startNotify.addListener(() {
      if (widget.game.startNotify.value) {
        widget.game.myWorld.startGame();
        runTimer();
      }
    });
    super.initState();
  }

  void runTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (widget.game.myWorld.isBallTapped) {
          return;
        }
        final currentSeconds = myDuration - 1;
        if (currentSeconds == startRandomMode) {
          widget.game.isChangedMode = true;
          widget.game.myWorld.pauseResetTimer();
          widget.game.myWorld.changeMode();
        }
        if (currentSeconds == ballTime) {
          widget.game.isBallAppear = true;
        }
        if (currentSeconds < 0) {
          timer?.cancel();
          widget.game.pauseEngine();
          widget.game.overlays.add('GameOver');
          // Times up
        } else {
          myDuration = currentSeconds;

          final seconds = strDigits(myDuration.remainder(60));
          widget.game.timerNotify.value = seconds;
        }
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
