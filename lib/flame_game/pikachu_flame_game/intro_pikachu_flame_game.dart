import 'dart:async';
import 'dart:math';
import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';

import 'check_point_function.dart';

const double widthPika = 50;
const double heightPika = 50;

class IntroPikachuFlameGame extends StatelessWidget {
  const IntroPikachuFlameGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const PikachuMap();
  }
}

enum PikachuID {
  unknown(-99),
  reward(3),
  mission(2),
  history(1),
  achievement(4),
  cat(5),
  rain(6),
  petal(7),
  background(8),
  bgHoliday(9);

  final int id;
  const PikachuID(this.id);
}

const int colPikachu = 5;

class PikachuObj {
  PikachuID pikachuID;
  String assetImage;
  bool isActive;
  Point point;

//  Point  get getPoint => point;

//  set setPoint(Point value) => point = value;

  PikachuObj({
    required this.pikachuID,
    required this.assetImage,
    this.isActive = true,
    this.point = const Point(0, 0),
  });
}

class PikachuMap extends StatefulWidget {
  const PikachuMap({super.key});

  @override
  State<PikachuMap> createState() => _PikachuMapState();
}

class _PikachuMapState extends State<PikachuMap>
    with SingleTickerProviderStateMixin, AfterLayoutMixin {
  List<PikachuObj> _initPikachu() {
    return [
      PikachuObj(
        pikachuID: PikachuID.history,
        assetImage: 'assets/images/roll_paper_roll/icon_lich_su.png',
      ),
      PikachuObj(
        pikachuID: PikachuID.mission,
        assetImage: 'assets/images/roll_paper_roll/icon_nhiem_vu.png',
      ),
      PikachuObj(
        pikachuID: PikachuID.reward,
        assetImage: 'assets/images/roll_paper_roll/icon_giai_thuong.png',
      ),
      PikachuObj(
        pikachuID: PikachuID.achievement,
        assetImage: 'assets/images/roll_paper_roll/icon_vinh_danh.png',
      ),
      PikachuObj(
        pikachuID: PikachuID.cat,
        assetImage: 'assets/images/roll_paper_roll/meo_0.png',
      ),
      PikachuObj(
        pikachuID: PikachuID.rain,
        assetImage: 'assets/images/icon-rain.png',
      ),
      PikachuObj(
        pikachuID: PikachuID.petal,
        assetImage: 'assets/images/canh_hoa_3.png',
      ),
      PikachuObj(
        pikachuID: PikachuID.background,
        assetImage: 'assets/images/river_bg.jpeg',
      ),
      PikachuObj(
        pikachuID: PikachuID.bgHoliday,
        assetImage: 'assets/images/roll_paper_roll/background.jpg',
      ),
    ];
  }

  int caculateRow(int lengthMatrix) {
    if (lengthMatrix >= 36) {
      return 6;
    } else {
      return 4;
    }
  }

  Map<int, List<PikachuObj>> _initMapMatrix(int count) {
    Map<int, List<PikachuObj>> mapPikachuFollowedId = {};
    for (var i = 1; i <= count; i++) {
      mapPikachuFollowedId[i] = [];
    }
    return mapPikachuFollowedId;
  }

  List<List<PikachuObj>> matrix() {
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
              pikachuID: PikachuID.unknown,
              assetImage: '',
              point: Point(indexRow, indexColumn),
              isActive: false,
            );
          } else {
            int indexPi;
            do {
              indexPi = random.nextInt(lstPikachu.length) + 1;
            } while (mapPikachuFollowedId[indexPi]!.length >= countEveryPi);
            final pikachu = PikachuObj(
              pikachuID: lstPikachu[indexPi - 1].pikachuID,
              assetImage: lstPikachu[indexPi - 1].assetImage,
              point: Point(indexRow, indexColumn),
            );
            mapPikachuFollowedId[pikachu.pikachuID.id]!.add(pikachu);
            return pikachu;
          }
        },
      ),
    );
  }

  Map<int, List<PikachuObj>> mapPikachuFollowedId = {};

  late AnimationController timer =
      AnimationController(vsync: this, duration: const Duration(seconds: 1));
  late List<List<PikachuObj>> matrixPikachu;
  late Point initialPoint;

  int countEveryPi = 4;
  int rowPi = 0;
  int columnPi = 0;
  List<PikachuObj> lstPikachu = [];
  PikachuObj? pikachuObj;
  CustomPainter? lineConnectedPikachu;

  @override
  void initState() {
    lstPikachu = _initPikachu();
    mapPikachuFollowedId = _initMapMatrix(lstPikachu.length);
    final row = caculateRow(lstPikachu.length * countEveryPi);
    columnPi = ((lstPikachu.length * countEveryPi) ~/ row) + 2;
    rowPi = row + 2;
    matrixPikachu = matrix();
    super.initState();
  }

  @override
  void dispose() {
    timer.dispose();
    super.dispose();
  }

  Point _initPoint(Size sizeScreen) {
    final halfWidth = sizeScreen.width / 2 - widthPika / 2;
    final halfHeight = sizeScreen.height / 2 - widthPika / 2;

    return Point(halfWidth - ((rowPi - 2) / 2) * widthPika,
        halfHeight - ((columnPi - 2) / 2) * widthPika);
  }

  void _clickPikachuBox(PikachuObj pikachu) {
    if (pikachuObj == null) {
      pikachuObj = pikachu;
      print('pikachu First ${pikachuObj!.point}');
      return;
    } else {
      print('pikachu Second ${pikachu.point}');
      if (pikachuObj!.point == pikachu.point) {
        pikachuObj = null;
        return;
      } else if (pikachuObj!.pikachuID != pikachu.pikachuID) {
        pikachuObj = null;
        return;
      } else {
        final lstPoint = myPoint(
            pikachuObj!.point, pikachu.point, matrixPikachu, rowPi, columnPi);
        lineConnectedPikachu = LineConnectedPikachu(
          lstPoint: lstPoint,
          initialPoint: initialPoint,
          heightPika: heightPika,
          widthPika: widthPika,
        );
        if (lstPoint.isNotEmpty) {
          // timer.forward();
          _removePikachu(pikachu.point, pikachu.pikachuID.id);
          _removePikachu(pikachuObj!.point, pikachuObj!.pikachuID.id);
          pikachuObj = null;

          setState(() {});
          // if (!_hasMorePairPikachu()) {
          //   _showMyDialog();
          // }
          return;
        } else {
          pikachuObj = null;
          return;
        }
      }
    }
  }

  void _removePikachu(Point point, int id) {
    matrixPikachu[point.x.toInt()][point.y.toInt()].isActive = false;
    mapPikachuFollowedId[id]?.removeWhere((element) => element.point == point);
    print(' mapPikachuFollowedId[${id}] ${mapPikachuFollowedId[id]?.length}');
  }

  bool _hasMorePairPikachu() {
    int sum = 0;
    for (var index = 1; index <= lstPikachu.length; index++) {
      if (mapPikachuFollowedId[index] != null &&
          mapPikachuFollowedId[index]!.isNotEmpty) {
        final lstPikachuInOneKey = mapPikachuFollowedId[index]!;
        if (lstPikachuInOneKey.isNotEmpty) {
          for (var i = 0; i < lstPikachuInOneKey.length - 1; i++) {
            for (var j = i + 1; j < lstPikachuInOneKey.length;) {
              sum++;

              final lstPoint = myPoint(lstPikachuInOneKey[i].point,
                  lstPikachuInOneKey[j].point, matrixPikachu, rowPi, columnPi);

              print('Sum ${lstPikachuInOneKey.length}');
              print('Sum +++++++++ ${sum}');
              return lstPoint.isNotEmpty;
            }
          }
        }
      }
    }
    return false;
  }

  void _shuffleMatrix() {
    int intRandom;

    Map<int, List<PikachuObj>> mapPikachuChanged =
        _initMapMatrix(lstPikachu.length);
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
    mapPikachuFollowedId.clear();
    mapPikachuFollowedId.addAll(mapPikachuChanged);
    setState(() {});
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('No more pair Pikachu'),
                Text(
                    'Would you like to minus one turn to change position Pikachu?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Oke'),
              onPressed: () {
                Navigator.of(context).pop();
                _shuffleMatrix();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: null,
      body: Center(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: lineConnectedPikachu != null
                  ? CustomPaint(
                      painter: lineConnectedPikachu,
                      size: size,
                    )
                  : const SizedBox(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 1; i <= columnPi - 2; i++)
                      GestureDetector(
                        onTap: () {
                          _clickPikachuBox(matrixPikachu[1][i]);
                        },
                        child: SizedBox(
                          height: heightPika,
                          width: widthPika,
                          child: matrixPikachu[1][i].isActive
                              ? Image.asset(matrixPikachu[1][i].assetImage)
                              : const SizedBox(),
                        ),
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 1; i <= columnPi - 2; i++)
                      GestureDetector(
                        onTap: () {
                          _clickPikachuBox(
                            matrixPikachu[2][i],
                          );
                        },
                        child: SizedBox(
                          height: heightPika,
                          width: widthPika,
                          child: matrixPikachu[2][i].isActive
                              ? Image.asset(matrixPikachu[2][i].assetImage)
                              : const SizedBox(),
                        ),
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 1; i <= columnPi - 2; i++)
                      GestureDetector(
                        onTap: () {
                          _clickPikachuBox(
                            matrixPikachu[3][i],
                          );
                        },
                        child: SizedBox(
                          height: heightPika,
                          width: widthPika,
                          child: matrixPikachu[3][i].isActive
                              ? Image.asset(matrixPikachu[3][i].assetImage)
                              : const SizedBox(),
                        ),
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 1; i <= columnPi - 2; i++)
                      GestureDetector(
                        onTap: () {
                          _clickPikachuBox(
                            matrixPikachu[4][i],
                          );
                        },
                        child: SizedBox(
                          height: heightPika,
                          width: widthPika,
                          child: matrixPikachu[4][i].isActive
                              ? Image.asset(matrixPikachu[4][i].assetImage)
                              : const SizedBox(),
                        ),
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 1; i <= columnPi - 2; i++)
                      GestureDetector(
                        onTap: () {
                          _clickPikachuBox(
                            matrixPikachu[5][i],
                          );
                        },
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: matrixPikachu[5][i].isActive
                              ? Image.asset(matrixPikachu[5][i].assetImage)
                              : const SizedBox(),
                        ),
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 1; i <= columnPi - 2; i++)
                      GestureDetector(
                        onTap: () {
                          _clickPikachuBox(
                            matrixPikachu[6][i],
                          );
                        },
                        child: SizedBox(
                          height: heightPika,
                          width: widthPika,
                          child: matrixPikachu[6][i].isActive
                              ? Image.asset(matrixPikachu[6][i].assetImage)
                              : const SizedBox(),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 50),
                child: ElevatedButton(
                  onPressed: () {
                    _shuffleMatrix();
                  },
                  child: const Text('Change Matrix'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    final size = MediaQuery.of(context).size;
    initialPoint = _initPoint(size);
  }
}

class LineConnectedPikachu extends CustomPainter {
  final List<Point<num>> lstPoint;
  final double widthPika;
  final double heightPika;

  LineConnectedPikachu({
    required this.lstPoint,
    required this.initialPoint,
    required this.widthPika,
    required this.heightPika,
  });

  Point _calculatePoint(Point value) {
    final x = initialPoint.x + value.y * widthPika;
    final y = initialPoint.y + value.x * heightPika;

    return Point(x, y);
  }

  final Point initialPoint;
  late Point moveToPoint;

  @override
  void paint(Canvas canvas, Size size) {
    moveToPoint = _calculatePoint(lstPoint.first);
    final paint = Paint()
      ..strokeWidth = 5
      ..color = Colors.indigoAccent
      ..style = PaintingStyle.stroke;
    var path = Path();
    path.moveTo(moveToPoint.x.toDouble(), moveToPoint.y.toDouble());
    for (var i = 1; i < lstPoint.length; i++) {
      moveToPoint = _calculatePoint(lstPoint[i]);
      path.lineTo(moveToPoint.x.toDouble(), moveToPoint.y.toDouble());
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PikachuBox extends StatelessWidget {
  final PikachuObj pikachuObj;
  const PikachuBox({super.key, required this.pikachuObj});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        height: 30,
        width: 30,
        child: Image.asset(pikachuObj.assetImage),
      ),
    );
  }
}
