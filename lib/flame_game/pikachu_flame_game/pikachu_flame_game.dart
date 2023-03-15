// import 'dart:async';
// import 'dart:ui' as ui;

// import 'package:animation_demo/flame_game/pikachu_flame_game/intro_pikachu_flame_game.dart';
// import 'package:flame/components.dart';
// import 'package:flame/game.dart';
// // ignore: implementation_imports
// import 'package:flame/src/gestures/events.dart';
// import 'package:flutter/material.dart';

// enum PikachuID {
//   turtle,
//   fish,
//   bird,
//   crocodile,
// }

// const int colPikachu = 5;

// // class PikachuObj {
// //   final PikachuID id;
// //   final String assetImage;
// //   final bool isActive;

// //   PikachuObj({
// //     required this.id,
// //     required this.assetImage,
// //     this.isActive = true,
// //   });
// // }

// // List<PikachuObj> lstAllPikachu = [];

// class PikachuFlameGame extends FlameGame with HasTappables, HasGameRef {
//   final _imageSource = [
//     'roll_paper_roll/icon_lich_su.png',
//     'roll_paper_roll/icon_nhiem_vu.png',
//     'roll_paper_roll/icon_giai_thuong.png',
//     'roll_paper_roll/icon_vinh_danh.png',
//   ];
//   final lstPikachu = [
//     PikachuObj(
//       id: PikachuID.bird,
//       assetImage: 'roll_paper_roll/icon_lich_su.png',
//     ),
//     PikachuObj(
//       id: PikachuID.fish,
//       assetImage: 'roll_paper_roll/icon_nhiem_vu.png',
//     ),
//     PikachuObj(
//       id: PikachuID.turtle,
//       assetImage: 'roll_paper_roll/icon_giai_thuong.png',
//     ),
//     PikachuObj(
//       id: PikachuID.crocodile,
//       assetImage: 'roll_paper_roll/icon_vinh_danh.png',
//     ),
//   ];

//   List<PikachuObj> lstAllPikachu = [];

//   List<List<PikachuObj>> lstPikachuMatrix = <List<PikachuObj>>[];

//   void initLstPikachu() {
//     for (var i = 0; i < colPikachu; i++) {
//       lstAllPikachu.addAll(lstPikachu);
//     }
//     lstAllPikachu.shuffle();
//   }

//   setUp() {
//     initLstPikachu();
//     final result = List.generate(
//         lstPikachu.length,
//         (row) => List.generate(colPikachu, (col) {
//               final pikachuObj = lstAllPikachu[(row) * colPikachu + (col)];

//               add(Object(col + 1, pikachuObj, row, lstPikachu.length));
//               return pikachuObj;
//             }, growable: false),
//         growable: false);

//     lstPikachuMatrix = result;
//     print('object ' + lstPikachuMatrix[0][4].assetImage);
//   }

//   @override
//   Color backgroundColor() {
//     return Colors.black;
//   }

//   @override
//   void onGameResize(Vector2 canvasSize) {
//     // gameSizePikachu = Vector2(gameSizePikachu.x, canvasSize.y);
//     super.onGameResize(canvasSize);
//   }

//   late ConnectedLineObj _connectedLineVIP;
//   final int rowPika = 4;
//   @override
//   Future<void> onLoad() async {
//     await super.onLoad();
//     await images.loadAll(_imageSource);
//     // initLstPikachu();
//     // setUpLine();
//     // _connectedLineVIP = ConnectedLineObj();
//     setUp();
//   }

//   ConnectedLineObj get connectedLineVIP => _connectedLineVIP;

//   setUpLine() {
//     add(ConnectedLineObj());
//   }
// }

// class Object extends SpriteComponent with HasGameRef<FlameGame>, Tappable {
//   final int indexColumn;
//   final int indexRow;
//   final int totalRow;
//   final PikachuObj pikachuObj;
//   Object(this.indexColumn, this.pikachuObj, this.indexRow, this.totalRow)
//       : super();
//   final int deviver = 20;
//   @override
//   Future<void> onLoad() async {
//     await super.onLoad();
//     final yColumn = (gameRef.size.x / 9 + deviver) * totalRow - deviver;
//     final yPosition = (indexRow - 1) * ((gameRef.size.x / 9) + deviver);
//     sprite = Sprite(gameRef.images.fromCache(pikachuObj.assetImage));
//     size = Vector2(gameRef.size.x / 9, gameRef.size.x / 9);
//     // anchor = Anchor.center;
//     position = Vector2((gameRef.size.x / 9) * (indexColumn + (indexColumn - 1)),
//         (gameRef.size.y / 2) - yColumn / 2 + yPosition);
//   }

//   @override
//   bool onTapDown(TapDownInfo info) {
//     // flipAxis(Axis.vertical);
//     // flipVertically()
//     final connectedLineObj = ConnectedLineObj();
//     add(connectedLineObj);

//     return super.onTapDown(info);
//   }
// }

// class ConnectedLineObj extends PositionComponent {
//   final time = Timer(0.5);
//   @override
//   FutureOr<void> onLoad() async {
//     // TODO: implement onLoad
//     await super.onLoad();
//     time.start();
//     time.onTick = () {
//       removeFromParent();
//     };
//   }

//   @override
//   void render(Canvas canvas) {
//     const pointMode = ui.PointMode.polygon;
//     final points = [
//       Offset(50, 100),
//       Offset(150, 75),
//       Offset(250, 250),
//       Offset(130, 200),
//       Offset(270, 100),
//     ];
//     final paint = Paint()
//       ..color = Colors.white
//       ..strokeWidth = 4
//       ..strokeCap = StrokeCap.round;
//     canvas.drawPoints(pointMode, points, paint);
//     super.render(canvas);
//   }

//   @override
//   void update(double dt) {
//     time.update(dt);
//     super.update(dt);
//   }
// }
