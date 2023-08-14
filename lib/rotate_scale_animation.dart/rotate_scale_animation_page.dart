import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RotateScaleAnimationPage extends StatefulWidget {
  const RotateScaleAnimationPage({super.key});

  @override
  State<RotateScaleAnimationPage> createState() =>
      _RotateScaleAnimationPageState();
}

class _RotateScaleAnimationPageState extends State<RotateScaleAnimationPage>
    with TickerProviderStateMixin {
  late AnimationController scaleController;
  late AnimationController rotateController;
  late Tween<double> scaleTween; // <<< Tween for first animation
  late Tween<double> rotateTween; // <<< Tween for second animation
  late Animation<double> scaleAnimation; // <<< first animation
  late Animation<double> rotateAnimation; // <<< second animation
  // 1. declare a Timer
  late final Timer _timer;
  @override
  void initState() {
    // 2. initialize it
    _timer = Timer.periodic(const Duration(seconds: 8), (_) {
      rotateController.reset();
      rotateController.forward();
    });
    scaleController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    rotateController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    scaleTween = Tween<double>(begin: 0.9, end: 1.2)
      ..animate(
          CurvedAnimation(parent: scaleController, curve: Curves.bounceOut)
            ..addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                scaleController.reverse();
              }
            })); // <<< define start and end value of alignment animation
    rotateTween = Tween(begin: 0, end: 2 * pi)
      ..animate(CurvedAnimation(
              parent: rotateController, curve: Curves.bounceOut))
          .addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(
            const Duration(milliseconds: 500),
            () {
              scaleController.reset();
              scaleController.forward();
            },
          );
        }
      }); // <<< define start and end value of rotation animation
    scaleAnimation =
        scaleController.drive(scaleTween); // <<< create align animation
    rotateAnimation =
        rotateController.drive(rotateTween); // <<< create rotation animation

    rotateController.forward();

    super.initState();
  }

  @override
  void dispose() {
    scaleController.dispose();
    rotateController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RotateScaleAnimationPage'),
      ),
      body: Container(
        color: Colors.grey,
        child: SizedBox.expand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 80,
              ),
              SizedBox(
                height: 80,
                width: 80,
                child: AnimatedBuilder(
                  animation: scaleController,
                  builder: (context, child) {
                    return ScaleTransition(
                      scale: scaleAnimation,
                      child: AnimatedBuilder(
                        animation: rotateController,
                        builder: (context, child) {
                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationZ(rotateAnimation.value),
                            child: const Image(
                                image: AssetImage(
                                    'assets/images/icon_vtcpay.png')),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  color: Colors.red,
                  height: 80,
                  width: 80,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
