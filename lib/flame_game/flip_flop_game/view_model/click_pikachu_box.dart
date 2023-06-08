import 'dart:async';
import 'dart:math';

import 'package:animation_demo/flame_game/flip_flop_game/view_model/notification_game.dart';
import 'package:flutter/material.dart';

import '../intro_flip_flop_game.dart';

extension ClickPikachuBox on ItemBoxState {
  void clickPikachuBox(
    PikachuObj pikachu,
    List<List<PikachuObj>> matrixPikachu,
  ) {
    if (pikachuObj == null) {
      print('First pikachu  ${pikachu.point}');
      pikachuObj = pikachu;
      controller.forward();
      firstController = controller;
      // matrixPikachu[pikachuObj!.point.x.toInt()][pikachuObj!.point.y.toInt()]
      //     .isPressed = true;
      // timerFirstObject = controller;

      return;
    } else {
      if (pikachuObj!.point == pikachu.point) {
        return;
      } else {
        print('Second pikachu pikachuID ${pikachu.pikachuID.toString()}');
        if (pikachuObj!.pikachuID != pikachu.pikachuID) {
          _handleNotPairItems(firstController!, controller);

          return;
        } else {
          _handleValidPairItems(
              controller,
              pikachuObj!.point,
              pikachuObj!.pikachuID,
              pikachu.point,
              pikachu.pikachuID,
              matrixPikachu);
          return;
        }
      }
      // print('Second pikachu point ${pikachu.point}');
    }
  }

  void _removePairPikachuValid(Point point1, int id1, Point point2, int id2,
      List<List<PikachuObj>> matrixPikachu) {
    matrixPikachu[point1.x.toInt()][point1.y.toInt()].isActive = false;
    matrixPikachu[point2.x.toInt()][point2.y.toInt()].isActive = false;
    mapPikachuFollowedId[id1]
        ?.removeWhere((element) => element.point == point1);
    mapPikachuFollowedId[id2]
        ?.removeWhere((element) => element.point == point2);
    // BlocProvider.of<FlipFlopGameBloc>(context).add(SetMatrixPikachuEvent());
    // print(
    //   ''' mapPikachuFollowedId[${id1}] ${mapPikachuFollowedId[id1]?.length}
    //   \n mapPikachuFollowedId[${id2}] ${mapPikachuFollowedId[id2]?.length}''',
    // );
  }

  void _resetValueItemBox() {
    // firstController = null;
  }

  Future<void> _handleNotPairItems(AnimationController firstControl,
      AnimationController secondControl) async {
    secondControl.forward();

    Timer(const Duration(milliseconds: milliseconds + milliSecondCheckPairItem),
        () {
      print('_handleNotPairItems');
      pikachuObj = null;
      firstControl.reverse();
      secondControl.reverse();
      _resetValueItemBox();
    });
  }

  // void _reverseController(List<dynamic> values) {
  //   final controller1 = values[1] as String;
  //   // final controller2 = values[2] as AnimationController;
  //   // controller1.reverse();
  //   // controller2.reverse();
  //   print('controller1 controller1controller1controller1');
  //   var sendPort = values[0] as SendPort;
  //   Isolate.exit(sendPort, values);
  // }

  Future<void> _handleValidPairItems(
    AnimationController secondControl,
    Point point1,
    int id1,
    Point point2,
    int id2,
    List<List<PikachuObj>> matrixPikachu,
  ) async {
    _removePairPikachuValid(point1, id1, point2, id2, matrixPikachu);
    secondControl.forward();

    Timer(const Duration(milliseconds: milliseconds + milliSecondCheckPairItem),
        () {
      pikachuObj = null;
      print('_handleValidPairItems');
      widget.callStateParent(matrixPikachu);
      if (isWinGame()) {
        noticeWinGame();
      }

      _resetValueItemBox();
    });
  }

  bool isWinGame() {
    for (var index = 1; index <= randomLength; index++) {
      if (mapPikachuFollowedId[index] != null &&
          mapPikachuFollowedId[index]!.isNotEmpty) {
        return false;
      }
    }
    return true;
  }
  // void _setStateMatrix(List<dynamic> values) {
  //   Timer(const Duration(milliseconds: milliseconds + milliSecondCheckPairItem),
  //       () {
  //     print('_handleValidPairItems');
  //     var sendPort = values[0] as SendPort;

  //     BlocProvider.of<FlipFlopGameBloc>(context).add(SetMatrixPikachuEvent());
  //     Isolate.exit(sendPort, values);
  //   });
  // }
}
