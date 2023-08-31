import 'dart:async';
import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:animation_demo/flame_game/pikachu_flame_game/view_model/click_pikachu_box.dart';
import 'package:animation_demo/flame_game/pikachu_flame_game/view_model/init_matrix.dart';
import 'package:animation_demo/flame_game/pikachu_flame_game/view_model/init_pikachu.dart';
import 'package:animation_demo/flame_game/pikachu_flame_game/view_model/shuffle_matrix.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/pikachu_pr.dart';

const double widthPika = 40;
const double heightPika = 40;

class IntroPikachuFlameGame extends StatelessWidget {
  const IntroPikachuFlameGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PikachuPR>(create: (context) => PikachuPR()),
      ],
      builder: (context, child) {
        return const PikachuMap();
      },
    );
  }
}

const int colPikachu = 5;

class PikachuObj {
  int pikachuID;
  String assetImage;
  bool isActive;
  Point point;
  bool isPressed;

//  Point  get getPoint => point;

//  set setPoint(Point value) => point = value;

  PikachuObj({
    required this.pikachuID,
    required this.assetImage,
    this.isActive = true,
    this.point = const Point(0, 0),
    this.isPressed = false,
  });
}

class PikachuMap extends StatefulWidget {
  const PikachuMap({super.key});

  @override
  State<PikachuMap> createState() => PikachuMapState();
}

class PikachuMapState extends State<PikachuMap>
    with SingleTickerProviderStateMixin, AfterLayoutMixin {
  Map<int, List<PikachuObj>> mapPikachuFollowedId = {};

  late List<List<PikachuObj>> matrixPikachu;
  late Point initialPoint;
  late PikachuPR pikachuPR;

  int countEveryPi = 4;
  int rowPi = 0;
  int columnPi = 0;
  List<PikachuObj> lstPikachu = [];
  PikachuObj? pikachuObj;

  int randomLength = 0;
  @override
  void initState() {
    pikachuPR = context.read<PikachuPR>();
    randomLength = randomPikachu();
    lstPikachu = initPikachu(randomLength);
    mapPikachuFollowedId = initMapMatrix(randomLength);
    final row = caculateRow(randomLength * countEveryPi);
    columnPi = ((randomLength * countEveryPi) ~/ row) + 2;
    rowPi = row + 2;
    matrixPikachu = initMatrix();

    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  Point _initPoint(Size sizeScreen) {
    final halfWidth = sizeScreen.width / 2 - widthPika / 2;
    final halfHeight = sizeScreen.height / 2 - heightPika / 2;

    return Point(halfWidth - (((columnPi - 2) / 2) * widthPika),
        halfHeight - (((rowPi - 2) / 2) * heightPika));
  }

  @override
  Widget build(BuildContext context) {
    print('randomLength ============== $randomLength');
    // final size = MediaQuery.of(context).size;
    // initialPoint = _initPoint(size);
    // for (var i = 0; i < rowPi; i++) {
    //   for (var j = 0; j < columnPi; j++) {
    //     print(
    //         ' ${matrixPikachu[i][j].point}  ${matrixPikachu[i][j].isActive}\n');
    //   }
    // }
    final size = MediaQuery.of(context).size;
    initialPoint = _initPoint(size);
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: null,
      body: Center(
        child: Stack(
          children: [
            matrixPikachu.isEmpty
                ? const SizedBox()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var rowIndex = 1; rowIndex <= rowPi - 2; rowIndex++)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List<Widget>.generate(
                              growable: false, columnPi - 2, (index) {
                            final colIndex = index + 1;
                            final isActive =
                                matrixPikachu[rowIndex][colIndex].isActive;
                            final isPressed =
                                matrixPikachu[rowIndex][colIndex].isPressed;
                            return GestureDetector(
                              onTap: () => clickPikachuBox(
                                matrixPikachu[rowIndex][colIndex],
                              ),
                              child: SizedBox(
                                height: widthPika,
                                width: heightPika,
                                child: Card(
                                  color: isPressed && isActive
                                      ? Colors.white60
                                      : Colors.white12,
                                  child: isActive
                                      ? Image.asset(matrixPikachu[rowIndex]
                                              [colIndex]
                                          .assetImage)
                                      : const SizedBox(),
                                ),
                              ),
                            );
                          }).toList(),
                        )
                    ],
                  ),
            const LineConnectedPikachuWidget(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 50),
                child: ElevatedButton(
                  onPressed: () {
                    shuffleMatrix();
                  },
                  child: const Text('Change Matrix'),
                ),
              ),
            ),
            // Positioned(
            //     top: initialPoint.y.toDouble(),
            //     left: initialPoint.x.toDouble(),
            //     child: Container(
            //       height: 40,
            //       width: 40,
            //       color: Colors.green,
            //     ),)
          ],
        ),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {}
}

class LineConnectedPikachuWidget extends StatelessWidget {
  const LineConnectedPikachuWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.center,
      child: IgnorePointer(
        child: Selector<PikachuPR, CustomPainter?>(
          builder: (context, lineConnectedPikachu, child) {
            print('lineConnectedPikachu');
            return lineConnectedPikachu != null
                ? CustomPaint(
                    painter: lineConnectedPikachu,
                    size: size,
                  )
                : const SizedBox();
          },
          selector: (_, pr) {
            return pr.lineConnectedPikachu;
          },
        ),
      ),
    );
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
      ..strokeWidth = 3
      ..color = Colors.white
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
