import 'dart:math';

import '../intro_flip_flop_game.dart';

extension InitMatrix on FlipFlopGamePageState {
  List<List<PikachuObj>> initMatrix() {
    var random = Random();
    return List.generate(
      rowPi,
      growable: false,
      (indexRow) => List<PikachuObj>.generate(
        columnPi,
        growable: false,
        (indexColumn) {
          if (indexRow == 0 ||
              indexColumn == 0 ||
              indexRow == rowPi - 1 ||
              indexColumn == columnPi - 1) {
            return PikachuObj(
              pikachuID: -99,
              assetImage: '',
              point: Point(indexRow, indexColumn),
              isActive: false,
            );
          } else {
            int indexPi;
            do {
              indexPi = random.nextInt(randomLength) + 1;
            } while (mapPikachuFollowedId[indexPi]!.length >= countEveryPi);
            final pikachu = PikachuObj(
              pikachuID: lstPikachu[indexPi - 1].pikachuID,
              assetImage: lstPikachu[indexPi - 1].assetImage,
              point: Point(indexRow, indexColumn),
            );
            mapPikachuFollowedId[pikachu.pikachuID]!.add(pikachu);
            return pikachu;
          }
        },
      ),
    );
  }
}
