import 'dart:async';
import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:animation_demo/blocs/flip_flop_game_bloc/flip_flop_game_bloc.dart';
import 'package:animation_demo/flame_game/flip_flop_game/view_model/click_pikachu_box.dart';
import 'package:animation_demo/flame_game/flip_flop_game/view_model/init_matrix.dart';
import 'package:animation_demo/flame_game/flip_flop_game/view_model/init_pikachu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'provider/pikachu_pr.dart';

const double widthPika = 40;
const double heightPika = 40;
PikachuObj? pikachuObj;

AnimationController? firstController;
const milliseconds = 300;
const milliSecondCheckPairItem = 200;

class IntroPikachuFlameGame extends StatelessWidget {
  const IntroPikachuFlameGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FlipFlopPR>(create: (context) => FlipFlopPR()),
      ],
      builder: (context, child) {
        return const FlipFlopGamePage();
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

class FlipFlopGamePage extends StatefulWidget {
  const FlipFlopGamePage({super.key});

  @override
  State<FlipFlopGamePage> createState() => FlipFlopGamePageState();
}

class FlipFlopGamePageState extends State<FlipFlopGamePage>
    with AfterLayoutMixin {
  Map<int, List<PikachuObj>> mapPikachuFollowedId = {};

  late List<List<PikachuObj>> matrixPikachu;
  late Point initialPoint;
  late FlipFlopPR pikachuPR;

  int countEveryPi = 4;
  int rowPi = 0;
  int columnPi = 0;

  List<PikachuObj> lstPikachu = [];

  int randomLength = 0;

  Timer? timerFirstObject;

  @override
  void initState() {
    pikachuPR = context.read<FlipFlopPR>();
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

  void setStateMethod(List<List<PikachuObj>> value) {
    // matrixPikachu = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('randomLength ============== $randomLength');
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: null,
      body: BlocConsumer<FlipFlopGameBloc, FlipFlopGameState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Center(
            child: Stack(
              children: [
                matrixPikachu.isEmpty
                    ? const SizedBox()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var rowIndex = 1;
                              rowIndex <= rowPi - 2;
                              rowIndex++)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List<Widget>.generate(
                                  growable: false, columnPi - 2, (index) {
                                final colIndex = index + 1;

                                return ItemBox(
                                  colIndex: colIndex,
                                  matrixPikachu: matrixPikachu,
                                  rowIndex: rowIndex,
                                  callStateParent: setStateMethod,
                                  mapPikachuFollowedId: mapPikachuFollowedId,
                                  randomLength: randomLength,
                                );
                              }).toList(),
                            )
                        ],
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {}
}

class ItemBox extends StatefulWidget {
  final List<List<PikachuObj>> matrixPikachu;
  final int rowIndex;
  final int colIndex;
  final int randomLength;
  final Function(List<List<PikachuObj>>) callStateParent;
  final Map<int, List<PikachuObj>> mapPikachuFollowedId;
  const ItemBox({
    super.key,
    required this.matrixPikachu,
    required this.rowIndex,
    required this.colIndex,
    required this.callStateParent,
    required this.mapPikachuFollowedId,
    required this.randomLength,
  });

  @override
  State<ItemBox> createState() => ItemBoxState();
}

class ItemBoxState extends State<ItemBox> with SingleTickerProviderStateMixin {
  double angle = pi;
  late AnimationController controller;
  late Animation<double> animation;
  late int rowIndex;
  late int colIndex;
  late List<List<PikachuObj>> matrixPikachu;
  late Map<int, List<PikachuObj>> mapPikachuFollowedId;
  late int randomLength;
  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: milliseconds));
    animation = Tween<double>(begin: 0, end: 1).animate(controller);
    matrixPikachu = widget.matrixPikachu;
    mapPikachuFollowedId = widget.mapPikachuFollowedId;
    colIndex = widget.colIndex;
    rowIndex = widget.rowIndex;
    randomLength = widget.randomLength;
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          clickPikachuBox(matrixPikachu[rowIndex][colIndex], matrixPikachu),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: SizedBox(
          height: widthPika,
          width: heightPika,
          child: !matrixPikachu[rowIndex][colIndex].isActive
              ? null
              : AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateX(angle * animation.value),
                      child: animation.value >= 0 && animation.value <= 0.5
                          ? const ColoredBox(
                              color: Colors.grey,
                            )
                          : Image.asset(
                              matrixPikachu[rowIndex][colIndex].assetImage,
                            ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
