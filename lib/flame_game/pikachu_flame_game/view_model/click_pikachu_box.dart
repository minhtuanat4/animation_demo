import 'dart:math';

import 'package:animation_demo/flame_game/pikachu_flame_game/intro_pikachu_flame_game.dart';
import 'package:animation_demo/flame_game/pikachu_flame_game/view_model/check_pikachu_map.dart';
import 'package:animation_demo/flame_game/pikachu_flame_game/view_model/notification_game.dart';

import '../check_point_function.dart';

extension ClickPikachuBox on PikachuMapState {
  void clickPikachuBox(
    PikachuObj pikachu,
  ) {
    if (pikachuObj == null) {
      pikachuObj = pikachu;
      matrixPikachu[pikachuObj!.point.x.toInt()][pikachuObj!.point.y.toInt()]
          .isPressed = true;
      setState(() {});
      print('pikachu First ${pikachuObj!.point}');
      return;
    } else {
      print('pikachu Second ${pikachu.point}');
      if (pikachuObj!.point == pikachu.point) {
        noticeSamePikachu();
        return;
      } else if (pikachuObj!.pikachuID != pikachu.pikachuID) {
        matrixPikachu[pikachuObj!.point.x.toInt()][pikachuObj!.point.y.toInt()]
            .isPressed = false;

        setState(() {});
        pikachuObj = null;
        return;
      } else {
        final lstPoint = myPoint(
            pikachuObj!.point, pikachu.point, matrixPikachu, rowPi, columnPi);

        if (lstPoint.isNotEmpty) {
          _removePairPikachuValid(lstPoint.first, pikachuObj!.pikachuID,
              lstPoint.last, pikachu.pikachuID);
          pikachuPR.lineConnectedPikachu = LineConnectedPikachu(
            lstPoint: lstPoint,
            initialPoint: initialPoint,
            heightPika: heightPika,
            widthPika: widthPika,
          );
          pikachuObj = null;
          Future.delayed(
            const Duration(milliseconds: 200),
            () {
              pikachuPR.lineConnectedPikachu = null;
              matrixPikachu[pikachu.point.x.toInt()][pikachu.point.y.toInt()]
                  .isPressed = true;
              setState(() {});
              if (isWinGame()) {
                noticeWinGame();
              } else {
                if (!hasMorePairPikachu()) {
                  noticeChangePikaPosition();
                }
              }
            },
          );

          return;
        } else {
          matrixPikachu[pikachuObj!.point.x.toInt()]
                  [pikachuObj!.point.y.toInt()]
              .isPressed = false;
          setState(() {});
          pikachuObj = null;

          return;
        }
      }
    }
  }

  void _removePairPikachuValid(Point point1, int id1, Point point2, int id2) {
    matrixPikachu[point1.x.toInt()][point1.y.toInt()].isActive = false;
    matrixPikachu[point2.x.toInt()][point2.y.toInt()].isActive = false;
    mapPikachuFollowedId[id1]
        ?.removeWhere((element) => element.point == point1);
    mapPikachuFollowedId[id2]
        ?.removeWhere((element) => element.point == point2);
    // print(
    //   ''' mapPikachuFollowedId[${id1}] ${mapPikachuFollowedId[id1]?.length}
    //   \n mapPikachuFollowedId[${id2}] ${mapPikachuFollowedId[id2]?.length}''',
    // );
  }
}
