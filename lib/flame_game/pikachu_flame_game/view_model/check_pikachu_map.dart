import 'package:animation_demo/flame_game/pikachu_flame_game/intro_pikachu_flame_game.dart';

import '../check_point_function.dart';

extension CheckPikachuMap on PikachuMapState {
  bool isWinGame() {
    for (var index = 1; index <= randomLength; index++) {
      if (mapPikachuFollowedId[index] != null &&
          mapPikachuFollowedId[index]!.isNotEmpty) {
        return false;
      }
    }
    return true;
  }

  bool hasMorePairPikachu() {
    bool isHasPair = false;
    int index = 1;
    while (index <= randomLength) {
      if (mapPikachuFollowedId[index] != null &&
          mapPikachuFollowedId[index]!.isNotEmpty) {
        final lstPikachuInOneKey = mapPikachuFollowedId[index]!;
        for (var i = 0; i < lstPikachuInOneKey.length - 1; i++) {
          for (var j = i + 1; j < lstPikachuInOneKey.length; j++) {
            final lstPoint = myPoint(
              lstPikachuInOneKey[i].point,
              lstPikachuInOneKey[j].point,
              matrixPikachu,
              rowPi,
              columnPi,
            );
            if (lstPoint.isNotEmpty) {
              return true;
            }
          }
        }
      }
      index++;
    }

    return isHasPair;
  }
}
