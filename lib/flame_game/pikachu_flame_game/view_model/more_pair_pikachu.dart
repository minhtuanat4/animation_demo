 
  // bool _hasMorePairPikachu() {
  //   int sum = 0;
  //   for (var index = 1; index <= lstPikachu.length; index++) {
  //     if (mapPikachuFollowedId[index] != null &&
  //         mapPikachuFollowedId[index]!.isNotEmpty) {
  //       final lstPikachuInOneKey = mapPikachuFollowedId[index]!;
  //       if (lstPikachuInOneKey.isNotEmpty) {
  //         for (var i = 0; i < lstPikachuInOneKey.length - 1; i++) {
  //           for (var j = i + 1; j < lstPikachuInOneKey.length;) {
  //             sum++;

  //             final lstPoint = myPoint(lstPikachuInOneKey[i].point,
  //                 lstPikachuInOneKey[j].point, matrixPikachu, rowPi, columnPi);

  //             print('Sum ${lstPikachuInOneKey.length}');
  //             print('Sum +++++++++ ${sum}');
  //             return lstPoint.isNotEmpty;
  //           }
  //         }
  //       }
  //     }
  //   }
  //   return false;
  // }