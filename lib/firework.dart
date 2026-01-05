import 'package:animation_demo/flame_main.dart';
import 'package:animation_demo/widget/confetti/confetti.dart';
import 'package:animation_demo/widget/confetti/enums/blast_directionality.dart';
import 'package:flutter/material.dart';

const durationFirework = Duration(milliseconds: 100);
const durationLife = Duration(seconds: 4);

class Firework extends StatefulWidget {
  final MoleGame game;
  const Firework({
    super.key,
    required this.game,
  });

  @override
  State<Firework> createState() => _FireworkState();
}

class _FireworkState extends State<Firework>
    with SingleTickerProviderStateMixin {
  final _confettiController = ConfettiController(
    duration: durationFirework,
  );
  late AnimationController _controllerSecond;
  @override
  void initState() {
    _controllerSecond =
        AnimationController(duration: durationLife, vsync: this);
    _confettiController.play();

    _controllerSecond
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.game.overlays.remove('Firework');
          widget.game.overlays.add('BallBottom');
        }
      });

    super.initState();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _controllerSecond.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Material(
          color: Colors.transparent,
          child: Container(
            width: widget.game.size.x,
            height: widget.game.size.y,
            child: Stack(
              children: [
                Positioned(
                  left: widget.game.ballPosition.x +
                      widget.game.ballSize.x / 2 +
                      8,
                  top: widget.game.ballPosition.y +
                      widget.game.ballSize.y / 2 -
                      12,
                  child: Align(
                    alignment: const Alignment(-0.1, -0.2),
                    child: ConfettiWidget(
                      blastDirectionality: BlastDirectionality.explosive,
                      confettiController: _confettiController,
                      particleDrag: 0.05,
                      emissionFrequency: 0.1,
                      numberOfParticles: 62,
                      gravity: 0.18,
                      shouldLoop: false,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
