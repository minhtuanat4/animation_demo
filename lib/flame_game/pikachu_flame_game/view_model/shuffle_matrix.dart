import 'dart:math';

import 'package:animation_demo/flame_game/pikachu_flame_game/intro_pikachu_flame_game.dart';
import 'package:animation_demo/flame_game/pikachu_flame_game/view_model/init_pikachu.dart';

extension ShuffleMatricx on PikachuMapState {
  void shuffleMatrix() {
    int intRandom;

    Map<int, List<PikachuObj>> mapPikachuChanged = initMapMatrix(randomLength);
    final rng = Random();
    for (var i = 1; i < rowPi - 1; i++) {
      for (var j = 1; j < columnPi - 1; j++) {
        if (matrixPikachu[i][j].isActive) {
          do {
            intRandom = rng.nextInt(lstPikachu.length) + 1;
          } while (mapPikachuFollowedId[intRandom]!.isEmpty);
          final values = mapPikachuFollowedId[intRandom]!.removeLast();
          final pikachu = PikachuObj(
            pikachuID: values.pikachuID,
            assetImage: values.assetImage,
            point: Point(i, j),
          );
          mapPikachuChanged[intRandom]!.add(pikachu);
          matrixPikachu[i][j] = pikachu;
        }
      }
    }

    setState(() {});
    mapPikachuFollowedId.clear();
    mapPikachuFollowedId.addAll(mapPikachuChanged);
  }
}
