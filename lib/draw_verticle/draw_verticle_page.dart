import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';

class DrawVerticePage extends StatefulWidget {
  const DrawVerticePage({super.key});

  @override
  State<DrawVerticePage> createState() => _DrawVerticePageState();
}

class _DrawVerticePageState extends State<DrawVerticePage>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    controller.repeat();
    // animation = Tween<double>(begin: 0, end: 2 * pi).animate(controller);
    // controller
    //   ..forward()
    //   ..repeat();
    // controller.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Draw Vertice'),
      ),
      // body: SizedBox.expand(
      //     child: Center(
      //   child: AnimatedBuilder(
      //     animation: animation,
      //     builder: (context, child1) {
      //       return Transform.rotate(
      //         angle: pi,
      //         child: SizedBox(
      //           height: 800,
      //           width: 800,
      //           child: CustomPaint(
      //             foregroundPainter: DrawVertice(
      //                 countSquare: 500, sizeScreen: const Size(800, 800)),
      //           ),
      //         ),
      //       );
      //     },
      //     child: SizedBox(
      //       height: 800,
      //       width: 800,
      //       child: CustomPaint(
      //         foregroundPainter: DrawVertice(
      //             countSquare: 500, sizeScreen: const Size(800, 800)),
      //       ),
      //     ),
      //   ),
      // )),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Text(
      //       "Data",
      //       style: TextStyle(color: Colors.white),
      //     ),
      //     // Container(
      //     //     width: size.width / 3,
      //     //     padding: EdgeInsets.all(20),
      //     //     height: 50,
      //     //     child: LinearProgressIndicator()),
      //   ],
      // )
      body: Column(
        children: [
          Expanded(
            child: SizedBox.expand(
              child: CustomPaint(
                foregroundPainter: DrawVertice(
                  countSquare: 1000,
                  sizeScreen: MediaQuery.of(context).size,
                  animation: controller,
                ),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Data",
                style: TextStyle(color: Colors.white),
              ),
              Container(
                  width: MediaQuery.of(context).size.width / 3,
                  padding: EdgeInsets.all(20),
                  height: 50,
                  child: LinearProgressIndicator()),
            ],
          )
        ],
      ),
    );
  }
}

// class VerticeBody extends AnimatedWidget {
//   const VerticeBody({super.key, required super.listenable});

//   @override
//   Widget build(BuildContext context) {
//     final animation = listenable as Animation<double>;
//     return Transform.rotate(
//         alignment: Alignment.center,
//         angle: animation.value,
//         child: Center(
//           child: SizedBox(
//             height: 800,
//             width: 800,
//             child: CustomPaint(
//               foregroundPainter: DrawVertice(),
//             ),
//           ),
//         ));
//   }
// }

class DrawVertice extends CustomPainter {
  final int countSquare;
  final Size sizeScreen;
  // final int verticeCount = 6;
  // final double defaultPixel = 120;
  final lstPaint = <Paint>[
    Paint()..color = Colors.teal,
    Paint()..color = Colors.green,
    Paint()..color = Colors.amberAccent,
  ];
  // final indices = <int>[];
  // final lstColors = lstColorsFollowedByCount(6);
  late List<Offset> squares;
  DrawVertice(
      {required this.countSquare,
      required this.sizeScreen,
      required Listenable animation})
      : super(repaint: animation) {
    squares = List<Offset>.generate(
        countSquare,
        (index) => Offset(random.nextDouble() * sizeScreen.width,
            sizeScreen.height * random.nextDouble()));
    positions = Float32List(countSquare * 5 * 2);
    indices = Uint16List(countSquare * 12);
  }
  final random = Random();
  late final Float32List positions;
  late final Uint16List indices;

  @override
  void paint(Canvas canvas, Size size) {
    // final center = Offset(size.width / 2, size.height / 2);
    for (var i = 0; i < squares.length; i++) {
      squares[i] = _updatePosition(i, squares[i], size.height);
    }

    for (var i = 0; i < squares.length; i++) {
      _renderRectangle(i, squares[i]);
    }

    final vertices =
        Vertices.raw(VertexMode.triangles, positions, indices: indices);
    canvas.drawVertices(vertices, BlendMode.dst, lstPaint[0]);
  }

  void _renderRectangle(
    int squareIndex,
    Offset position,
  ) {
    int vectexCount = 4;
    final Offset center = position;
    double radius = 5;

    int positionSquareStart = squareIndex * 5 * 2;
    var positionSquareIndex = positionSquareStart;
    positions[positionSquareIndex++] = center.dx;
    positions[positionSquareIndex++] = center.dy;
    for (var i = 0; i < vectexCount; i++) {
      final dx = cos(i / vectexCount * 2 * pi) * radius;
      final dy = sin(i / vectexCount * 2 * pi) * radius;

      positions[positionSquareIndex++] = center.dx + dx;
      positions[positionSquareIndex++] = center.dy + dy;
    }

    int indiceIndex = squareIndex * 12;
    var positionIndexStartHalf = positionSquareStart ~/ 2;

    for (var i = 0; i < vectexCount - 1; i++) {
      indices[indiceIndex++] = positionIndexStartHalf;
      indices[indiceIndex++] = positionIndexStartHalf + 1 + i;
      indices[indiceIndex++] = positionIndexStartHalf + 2 + i;
    }
    indices[indiceIndex++] = positionIndexStartHalf;
    indices[indiceIndex++] = positionIndexStartHalf + 1;
    indices[indiceIndex++] = positionIndexStartHalf + vectexCount;
  }

  Offset _updatePosition(
      int squareIndex, Offset squarePosition, double sreenHeight) {
    Offset position;
    double dy = squarePosition.dy + 1;
    position = Offset(squarePosition.dx, dy);
    if (dy > sreenHeight) {
      position = Offset(random.nextDouble() * sizeScreen.width,
          random.nextDouble() * -sizeScreen.width / 2);
    }
    return position;
  }

  // @override
  // void paint(Canvas canvas, Size size) {
  //   final radius = size.shortestSide / 3;

  //   final center = Offset(size.width / 2, size.height / 2);

  //   final lstOffsetFollowedByVectice = <Offset>[];
  //   lstOffsetFollowedByVectice.add(center);
  //   for (var i = 0; i < verticeCount; i++) {
  //     lstOffsetFollowedByVectice.add(center +
  //         Offset(radius * cos(i / verticeCount * 2 * pi),
  //             radius * sin(i / verticeCount * 2 * pi)));
  //   }
  //   for (var i = 0; i < verticeCount - 1; i++) {
  //     indices.add(0);
  //     indices.add(i + 1);
  //     indices.add(i + 2);
  //   }
  //   indices.addAll([0, verticeCount, 1]);
  //   final vertices = Vertices(
  //     VertexMode.triangles,
  //     lstOffsetFollowedByVectice,
  //     colors: lstColors,
  //     indices: indices,
  //   );
  //   canvas.drawVertices(vertices, BlendMode.dst, lstPaint[0]);
  // }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

List<Color> lstColors() {
  final List<Color> lst = <Color>[];
  for (var i = 0; i < 12; i++) {
    lst.add(Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0));
  }
  return lst;
}

List<Color> lstColorsFollowedByCount(int count) {
  final List<Color> lst = <Color>[];
  // Colors.primaries[Random().nextInt(Colors.primaries.length)],
  for (var i = 0; i < count + 1; i++) {
    lst.add(Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0));
  }
  return lst;
}

List<Offset> lstOffsetCenterHecxagon(Offset center, double radius) {
  final List<Offset> lst = <Offset>[];
  const alphaAngle = 360 / 12;
  for (var i = 0; i < 12; i++) {
    final firstCoordinate = center;

    final sencondCoordinate = center +
        Offset(radius * cos(alphaAngle * (i + 1)),
            -(radius * sin(alphaAngle * (i + 1))));
    final thirdCoordinate = center +
        Offset(
            radius * cos(alphaAngle * (i)), -(radius * sin(alphaAngle * (i))));
    lst.addAll([firstCoordinate, sencondCoordinate, thirdCoordinate]);
  }
  return lst;
}
