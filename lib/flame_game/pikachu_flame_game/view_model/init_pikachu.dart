import 'dart:math';

import 'package:animation_demo/flame_game/pikachu_flame_game/intro_pikachu_flame_game.dart';

const List<String> listAssetImage = [
  'assets/images/roll_paper_roll/icon_lich_su.png',
  'assets/images/roll_paper_roll/icon_nhiem_vu.png',
  'assets/images/roll_paper_roll/icon_giai_thuong.png',
  'assets/images/roll_paper_roll/icon_vinh_danh.png',
  'assets/images/roll_paper_roll/meo_0.png',
  'assets/images/icon-rain.png',
  'assets/images/canh_hoa_3.png',
  'assets/images/roll_paper_roll/background.jpg',
  'assets/images/roll_paper_roll/quakhe2.png',
  'assets/images/roll_paper_roll/haikhe_iconsk.png',
  'assets/images/roll_paper_roll/lixido-xoay.png',
  'assets/images/roll_paper_roll/quakhe3.png',
  'assets/images/roll_paper_roll/tnds_xe_may.png',
  'assets/images/roll_paper_roll/vbi_cn.4.1.png',
  'assets/images/roll_paper_roll/trau.png',
  'assets/images/roll_paper_roll/ic_vbi_oto.png',
  'assets/images/roll_paper_roll/canhbao.png',
];

extension InitPikachu on PikachuMapState {
  static int pikachuLength = listAssetImage.length;

  int randomPikachu() {
    var value = Random().nextInt(pikachuLength - 11);
    if (value == 5 || value == 7) {
      value++;
    }
    return value + 6;
  }

  int caculateRow(int lengthMatrix) {
    switch (lengthMatrix) {
      case 36:
        return 6;
      case 40:
        return 5;
      case 48:
        return 6;
      case 56:
        return 7;

      default:
        return 4;
    }
    // for (var i = 4; i <= 8; i = i + 2) {
    //   if (lengthMatrix == pow(i, 2)) {
    //     return i;
    //   }
    // }
    // return 4;
  }

  List<PikachuObj> initPikachu(int count) {
    final values = <String>[];
    values.addAll(listAssetImage);
    values.shuffle();
    var lstPikachuObj = <PikachuObj>[];
    for (var i = 0; i < count; i++) {
      lstPikachuObj.add(
        PikachuObj(
          pikachuID: i + 1,
          assetImage: values[i],
        ),
      );
    }
    return lstPikachuObj;
  }

  Map<int, List<PikachuObj>> initMapMatrix(int count) {
    Map<int, List<PikachuObj>> mapPikachuFollowedId = {};
    for (var i = 1; i <= count; i++) {
      mapPikachuFollowedId[i] = [];
    }
    return mapPikachuFollowedId;
  }
}
