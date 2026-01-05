// import 'dart:async';
// import 'dart:math';

// import 'package:animation_demo/getx_demo/common/custom/epos_popup.dart';
// import 'package:flame/components.dart';
// import 'package:flame/experimental.dart';
// import 'package:flame/game.dart';
// import 'package:flutter/material.dart';

// int isWind = 0;
// double speedWind = 100;

// class LeafFallingUI extends FlameGame {
//   final bool isPink;
//   LeafFallingUI(this.isPink);
//   final world = World();
//   late LeafManagement leafManagement;
//   @override
//   Color backgroundColor() {
//     return Colors.transparent;
//   }

//   final imageAssets = [
//     'event_2024/hoamai.png',
//     'event_2024/hoadao.png',
//   ];
//   @override
//   Future<FutureOr<void>> onLoad() async {
//     await super.onLoad();
//     await images.loadAll(imageAssets);
//     addAll([
//       world,
//       CameraComponent.withFixedResolution(
//         world: world,
//         width: 1080,
//         height: 1920,
//       )
//     ]);
//     leafManagement = LeafManagement(isPink);
//   }

//   @override
//   void onMount() {
//     add(leafManagement);
//     super.onMount();
//   }
// }

// class LeafManagement extends PositionComponent {
//   final bool isPink;
//   Timer interval = Timer(0, repeat: true);
//   int countLeaf = Random().nextInt(8);

//   LeafManagement(this.isPink);
//   String assetImage = 'event_2024/hoadao.png';
//   @override
//   FutureOr<void> onLoad() {
//     interval
//       ..start()
//       ..onTick = spawnFallingLeaf;
//     if (!isPink) {
//       assetImage = 'event_2024/hoamai.png';
//     }
//     return super.onLoad();
//   }

//   void spawnFallingLeaf() {
//     interval.limit = Random().nextDouble() * 5;
//     countLeaf = Random().nextInt(8);
//     for (var i = 0; i < countLeaf; i++) {
//       add(LeafItem(assetImage));
//     }
//   }

//   @override
//   void onRemove() {
//     interval
//       ..pause()
//       ..stop();
//     super.onRemove();
//   }

//   @override
//   void update(double dt) {
//     interval.update(dt);
//     super.update(dt);
//   }
// }

// Map<int, Anchor> mapAnchor = {
//   0: Anchor.center,
//   1: Anchor.topCenter,
//   2: Anchor.topLeft,
//   3: Anchor.topRight,
//   4: Anchor.bottomCenter,
//   5: Anchor.bottomLeft,
//   6: Anchor.bottomRight,
//   7: Anchor.centerLeft,
//   8: Anchor.centerRight,
// };
// const double fallFlowerExistTime = 24;

// class LeafItem extends SpriteComponent with HasGameRef {
//   final String spriteParam;
//   LeafItem(this.spriteParam);
//   double positionX = Random().nextDouble();
//   double speed = 32;

//   Timer interval = Timer(fallFlowerExistTime);

//   final random = Random().nextInt(9);
//   final double randomPositionY = Random().nextInt(100) + 60;
//   double rotateSpeed = 2;
//   final randomSize = Random().nextDouble() * 8 + 6;
//   @override
//   FutureOr<void> onLoad() {
//     anchor = mapAnchor[random]!;
//     sprite = Sprite(gameRef.images.fromCache(spriteParam));
//     position.x = positionX * gameRef.size.x;
//     size = Vector2(randomSize, randomSize);

//     position.y = randomPositionY;
//     interval.onTick = () {
//       removeFromParent();
//     };
//     interval.current;
//     return super.onLoad();
//   }

//   @override
//   void onRemove() {
//     interval
//       ..pause()
//       ..stop();
//     super.onRemove();
//   }

//   @override
//   void update(double dt) {
//     if (position.y >= (gameRef.size.y - 10)) {
//       interval.update(dt);

//       if (interval.current > (fallFlowerExistTime - 3)) {
//         opacity = (opacity - dt * 0.5).clamp(0, 1);
//       }

//       return;
//     }

//     angle += rotateSpeed * dt;

//     position.y += (Random().nextDouble()) * dt + dt * speed;
//     if (position.x < -40 || position.x > gameRef.size.x + 40) {
//       removeFromParent();
//     }
//     // if (speedWind > 0) {
//     //   speedWind -= dt * (speedWind / 16);
//     //   if (isWind == 2) {
//     //     position.x += dt * speedWind;
//     //   } else if (isWind == 1) {
//     //     position.x -= dt * speedWind;
//     //   }
//     // } else {
//     //   speedWind = 0;
//     // }

//     super.update(dt);
//   }
// }

// class LoginFirebasePage2 extends StatefulWidget {
//   const LoginFirebasePage2({super.key});

//   @override
//   State<LoginFirebasePage2> createState() => _LoginFirebasePage2State();
// }

// class _LoginFirebasePage2State extends State<LoginFirebasePage2>
//     with EposPopup, WidgetsBindingObserver, TickerProviderStateMixin {
//   bool isDrop = false;
//   double paddingTree = 0;
//   final x = 430;
//   final y = 495;

//   List<double> heightLanterns = [60, 120, 100, 80, 80];

//   late AnimationController darkModeController;
//   late Animation<double> darkModeAnimation;

//   late List<AnimationController> listAnimationController = [
//     AnimationController(vsync: this, duration: Duration(milliseconds: 1200)),
//     AnimationController(vsync: this, duration: Duration(milliseconds: 1200)),
//     AnimationController(vsync: this, duration: Duration(milliseconds: 1200)),
//     AnimationController(vsync: this, duration: Duration(milliseconds: 1200)),
//     AnimationController(vsync: this, duration: Duration(milliseconds: 1200)),
//     AnimationController(vsync: this, duration: Duration(milliseconds: 1200)),
//     AnimationController(vsync: this, duration: Duration(milliseconds: 1200)),
//     AnimationController(vsync: this, duration: Duration(milliseconds: 1200)),
//     AnimationController(vsync: this, duration: Duration(milliseconds: 1200)),
//   ];
//   List<Animation<double>> listDropAnimation = [];
//   int indexMoneyPocket = 0;

//   void startDropAction(int indexMoneyPocket) {
//     if (listAnimationController[indexMoneyPocket].isDismissed) {
//       listAnimationController[indexMoneyPocket]
//         ..reset()
//         ..forward()
//         ..addListener(() {
//           if (listAnimationController[indexMoneyPocket].isCompleted) {
//             listAnimationController[indexMoneyPocket].reset();
//           }
//         });
//     }
//   }

//   bool isFirstTime = true;

//   void startAnimation() {
//     if (isFirstTime) {
//       isFirstTime = false;
//     }
//     darkModeController
//       ..reset()
//       ..forward();
//   }

//   @override
//   void dispose() {
//     darkModeController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     for (var element in listAnimationController) {
//       listDropAnimation.add(Tween<double>(begin: 0, end: 1).animate(element));
//     }
//     darkModeController = AnimationController(
//         vsync: this, duration: Duration(milliseconds: 1200));
//     darkModeAnimation =
//         Tween<double>(begin: 0, end: 1).animate(darkModeController);
//     WidgetsBinding.instance.addPostFrameCallback((a) {
//       Future.delayed(Duration(milliseconds: 100), () {
//         final renderBoxRed =
//             keyFlower.currentContext!.findRenderObject() as RenderBox;
//         sizeFlower = renderBoxRed.size;
//         if (sizeFlower.isEmpty) {
//           Future.delayed(Duration(milliseconds: 100), () {
//             calculatePosition();
//           });
//         } else {
//           calculatePosition();
//         }
//       });
//     });
//     super.initState();
//   }

//   void calculatePosition() {
//     paddingTree = (MediaQuery.sizeOf(context).width - sizeFlower.width) / 2;

//     final x1 = 98 / x * sizeFlower.width;
//     final y1 = 205 / y * sizeFlower.height;
//     final x2 = 40 / x * sizeFlower.width;
//     final y2 = 80 / y * sizeFlower.height;
//     final x3 = 45 / x * sizeFlower.width;
//     final y3 = 143 / y * sizeFlower.height;
//     final x4 = 58 / x * sizeFlower.width;
//     final y4 = 317 / y * sizeFlower.height;
//     final x5 = 97 / x * sizeFlower.width;
//     final y5 = 325 / y * sizeFlower.height;
//     position1 = Size(x1, y1);
//     position2 = Size(x2, y2);
//     position3 = Size(x3, y3);
//     position4 = Size(x4, y4);
//     position5 = Size(x5, y5);
//     setState(() {});
//   }

//   final keyFlower = GlobalKey();

//   Size sizeFlower = Size.zero;

//   Size position1 = Size(-100, 0);
//   Size position2 = Size(-100, 0);
//   Size position3 = Size(-100, 0);
//   Size position4 = Size(-100, 0);
//   Size position5 = Size(-100, 0);

//   double heightFlower = 0;

//   // bool isDarkMode = false;

//   final isLightModeNotifer = ValueNotifier<bool>(true);

//   final isPeachTreeNotifier = ValueNotifier<bool>(false);

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.sizeOf(context).height;
//     final width = MediaQuery.sizeOf(context).width;
//     final rateAspect = height / width;
//     heightFlower = height / 1.8;
//     return Scaffold(
//       appBar: null,
//       body: Container(
//         child: Stack(
//           children: [
//             /// Dark Mode
//             SizedBox(
//               width: double.infinity,
//               height: double.infinity,
//               child: ValueListenableBuilder(
//                 valueListenable: isPeachTreeNotifier,
//                 builder: (context, _, __) {
//                   final assgetImage = isPeachTreeNotifier.value
//                       ? AssetImage('assets/images/event_2024/bg_dao_dem.jpg')
//                       : AssetImage('assets/images/event_2024/bg_mai_dem.jpg');
//                   return ValueListenableBuilder(
//                     builder: (context, _, __) {
//                       return AnimatedBuilder(
//                         builder: (context, _) {
//                           return Opacity(
//                             opacity: isLightModeNotifer.value && !isFirstTime
//                                 ? (1 - darkModeAnimation.value)
//                                 : darkModeAnimation.value,
//                             child: Image(
//                               image: assgetImage,
//                               fit: BoxFit.fill,
//                             ),
//                           );
//                         },
//                         animation: darkModeAnimation,
//                       );
//                     },
//                     valueListenable: isLightModeNotifer,
//                   );
//                 },
//               ),
//             ),

//             /// Light Mode
//             SizedBox(
//               width: double.infinity,
//               height: double.infinity,
//               child: ValueListenableBuilder(
//                   valueListenable: isPeachTreeNotifier,
//                   builder: (context, _, __) {
//                     final assgetImage = isPeachTreeNotifier.value
//                         ? AssetImage('assets/images/event_2024/bg_dao.jpg')
//                         : AssetImage('assets/images/event_2024/bg_mai.jpg');
//                     return ValueListenableBuilder(
//                       builder: (context, _, __) {
//                         return AnimatedBuilder(
//                           builder: (context, _) {
//                             return Opacity(
//                               opacity: isLightModeNotifer.value && !isFirstTime
//                                   ? darkModeAnimation.value
//                                   : (1 - darkModeAnimation.value),
//                               child: Image(
//                                 image: assgetImage,
//                                 fit: BoxFit.fill,
//                               ),
//                             );
//                           },
//                           animation: darkModeAnimation,
//                         );
//                       },
//                       valueListenable: darkModeAnimation,
//                     );
//                   }),
//             ),
//             Positioned(
//               right: 0,
//               left: 0,
//               height: height / 9.2 * rateAspect,
//               child: SafeArea(
//                 child: Image(
//                   image: AssetImage('assets/images/event_2024/logo.png'),
//                 ),
//               ),
//             ),
//             Positioned(
//               right: 0,
//               left: 0,
//               top: 0,
//               bottom: 0,
//               child: Container(
//                 margin:
//                     EdgeInsets.only(top: sizeFlower.height + height / 23 + 8),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       height: height / 23,
//                       child: PlayTurnWidget(),
//                     ),
//                     const SizedBox(
//                       height: 4,
//                     ),
//                     Text(
//                       '''(Lắc điện thoại để hái lì xì)''',
//                       style: TextStyle(
//                         color: Colors.yellow.shade900,
//                         fontStyle: FontStyle.italic,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 14,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.center,
//               child: Container(
//                 margin: EdgeInsets.only(bottom: 16),
//                 height: heightFlower,
//                 child: Stack(children: [
//                   Positioned(
//                     top: position5.height,
//                     left: position5.width - heightLanterns[0] / 4,
//                     child: Container(
//                       height: heightLanterns[0],
//                       child: LongLanternWidget(opacity: 0.7),
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.topCenter,
//                     child: ValueListenableBuilder(
//                         valueListenable: isPeachTreeNotifier,
//                         builder: (contex, _, __) {
//                           return ValueListenableBuilder(
//                             valueListenable: isLightModeNotifer,
//                             builder: (contex, _, __) {
//                               return isPeachTreeNotifier.value
//                                   ? Image(
//                                       key: keyFlower,
//                                       image: AssetImage(
//                                           'assets/images/event_2024/hoa_dao.png'),
//                                     )
//                                   : Image(
//                                       key: keyFlower,
//                                       image: AssetImage(
//                                           'assets/images/event_2024/${isLightModeNotifer.value ? 'hoa_mai' : 'hoa_mai_dem'}.png'),
//                                     );
//                             },
//                           );
//                         }),
//                   ),
//                   // if (sizeFlower.height > 0)
//                   //   Container(
//                   //     margin: EdgeInsets.only(left: 24, right: 24),
//                   //     height: sizeFlower.height,
//                   //     width: sizeFlower.width,
//                   //     child: ValueListenableBuilder(
//                   //         valueListenable: isPeachTreeNotifier,
//                   //         builder: (contex, _, __) {
//                   //           return GameWidget(
//                   //             game: LeafFallingUI(isPeachTreeNotifier.value),
//                   //           );
//                   //         }),
//                   //   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: paddingTree),
//                     child: Stack(
//                       alignment: Alignment.topCenter,
//                       children: [
//                         ...lanterrns(),
//                         ...moneyPockets(width),
//                       ],
//                     ),
//                   ),
//                 ]),
//               ),
//             ),

//             ///Dark Mode
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 margin: EdgeInsets.only(bottom: 16),
//                 height: height / 8,
//                 child: AnimatedBuilder(
//                   builder: (context, _) {
//                     return Opacity(
//                       opacity: isLightModeNotifer.value && !isFirstTime
//                           ? (1 - darkModeAnimation.value)
//                           : darkModeAnimation.value,
//                       child: FunctionMenu(
//                         isLightMode: false,
//                       ),
//                     );
//                   },
//                   animation: darkModeAnimation,
//                 ),
//               ),
//             ),

//             /// Light Mode
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 margin: EdgeInsets.only(bottom: 16),
//                 height: height / 8,
//                 child: AnimatedBuilder(
//                   builder: (context, _) {
//                     return Opacity(
//                       opacity: isLightModeNotifer.value && !isFirstTime
//                           ? darkModeAnimation.value
//                           : (1 - darkModeAnimation.value),
//                       child: FunctionMenu(
//                         isLightMode: true,
//                       ),
//                     );
//                   },
//                   animation: darkModeAnimation,
//                 ),
//               ),
//             ),
//             Positioned(
//               left: 12,
//               top: 44,
//               child: ValueListenableBuilder(
//                 builder: (context, _, __) {
//                   return Row(
//                     children: [
//                       Switch.adaptive(
//                         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         activeColor: Colors.grey,
//                         inactiveTrackColor: Colors.yellow.shade400,
//                         value: isLightModeNotifer.value,
//                         onChanged: (value) {
//                           if (darkModeController.isAnimating) {
//                             return;
//                           }
//                           isLightModeNotifer.value = value;
//                           startAnimation();
//                         },
//                       ),
//                     ],
//                   );
//                 },
//                 valueListenable: isLightModeNotifer,
//               ),
//             ),
//             Positioned(
//               left: 12,
//               top: 88,
//               child: ValueListenableBuilder(
//                 builder: (context, _, __) {
//                   return Switch.adaptive(
//                     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                     activeColor: Colors.yellow.shade700,
//                     inactiveTrackColor: Colors.pink.shade200,
//                     value: isPeachTreeNotifier.value,
//                     onChanged: (value) {
//                       isPeachTreeNotifier.value = value;
//                     },
//                   );
//                 },
//                 valueListenable: isPeachTreeNotifier,
//               ),
//             ),
//             Positioned(
//               right: 16,
//               top: 44,
//               child: GestureDetector(
//                 onTap: () {
//                   int random = Random().nextInt(9);
//                   startDropAction(random);
//                 },
//                 child: Image(
//                     image: AssetImage('assets/images/event_2024/close.png')),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<Widget> lanterrns() {
//     return [
//       Positioned(
//         top: position1.height,
//         left: position1.width - heightLanterns[1] / 4,
//         child: Container(
//           height: heightLanterns[1],
//           child: LanternWidget(),
//         ),
//       ),
//       Positioned(
//         top: position2.height,
//         left: position2.width - heightLanterns[2] / 4,
//         child: Container(
//           height: heightLanterns[2],
//           child: LanternWidget(),
//         ),
//       ),
//       Positioned(
//         top: position3.height,
//         right: position3.width - heightLanterns[3] / 4,
//         child: Container(
//           height: heightLanterns[3],
//           child: LanternWidget(),
//         ),
//       ),
//       Positioned(
//         top: position4.height,
//         right: position4.width - heightLanterns[4] / 4,
//         child: Container(
//           height: heightLanterns[4],
//           child: LongLanternWidget(),
//         ),
//       ),
//     ];
//   }

//   List<Widget> moneyPockets(double width) {
//     return [
//       AnimatedBuilder(
//         builder: (context, child) {
//           return Positioned(
//             top: heightFlower / 1.8 +
//                 listDropAnimation[0].value *
//                     (heightFlower - heightFlower / 1.8),
//             left: -width / 5,
//             right: 0,
//             height: heightFlower / 14,
//             child: child ?? const SizedBox(),
//           );
//         },
//         child: Transform.rotate(
//           angle: -pi / 12,
//           child: MoneyPocket(image: 'assets/images/event_2024/lixi.png'),
//         ),
//         animation: listDropAnimation[0],
//       ),
//       AnimatedBuilder(
//           animation: listDropAnimation[1],
//           builder: (context, child) {
//             return Positioned(
//               top: heightFlower / 6 +
//                   listDropAnimation[1].value *
//                       (heightFlower - heightFlower / 6),
//               left: -width / 1.8,
//               right: 0,
//               height: heightFlower / 12,
//               child: Transform.rotate(
//                   angle: -pi / 12,
//                   child:
//                       MoneyPocket(image: 'assets/images/event_2024/lixi.png')),
//             );
//           }),

//       /// Right
//       AnimatedBuilder(
//           animation: listDropAnimation[2],
//           builder: (context, child) {
//             return Positioned(
//               top: heightFlower / 8 +
//                   listDropAnimation[2].value *
//                       (heightFlower - heightFlower / 8),
//               left: width / 1.8,
//               right: 0,
//               height: heightFlower / 14,
//               child: MoneyPocket(image: 'assets/images/event_2024/lixi.png'),
//             );
//           }),

//       AnimatedBuilder(
//           animation: listDropAnimation[3],
//           builder: (context, child) {
//             return Positioned(
//               top: heightFlower / 2 +
//                   listDropAnimation[3].value *
//                       (heightFlower - heightFlower / 2),
//               left: width / 1.6,
//               right: 0,
//               height: heightFlower / 14,
//               child: MoneyPocket(image: 'assets/images/event_2024/lixi.png'),
//             );
//           }),

//       AnimatedBuilder(
//           animation: listDropAnimation[4],
//           builder: (context, child) {
//             return Positioned(
//               top: heightFlower / 13 +
//                   listDropAnimation[4].value *
//                       (heightFlower - heightFlower / 13),
//               left: -width / 6,
//               right: 0,
//               height: heightFlower / 7,
//               child: MoneyPocket(image: 'assets/images/event_2024/lixi1.png'),
//             );
//           }),

//       AnimatedBuilder(
//           animation: listDropAnimation[5],
//           builder: (context, child) {
//             return Positioned(
//               top: heightFlower / 3 +
//                   listDropAnimation[5].value *
//                       (heightFlower - heightFlower / 3),
//               left: -width / 4,
//               right: 0,
//               height: heightFlower / 7,
//               child: MoneyPocket(image: 'assets/images/event_2024/lixi2.png'),
//             );
//           }),
//       AnimatedBuilder(
//           animation: listDropAnimation[6],
//           builder: (context, child) {
//             return Positioned(
//               top: heightFlower / 5 +
//                   listDropAnimation[6].value *
//                       (heightFlower - heightFlower / 5),
//               left: width / 3.5,
//               right: 0,
//               height: heightFlower / 7,
//               child: MoneyPocket(image: 'assets/images/event_2024/lixi3.png'),
//             );
//           }),
//       AnimatedBuilder(
//           animation: listDropAnimation[7],
//           builder: (context, child) {
//             return Positioned(
//               top: heightFlower / 2 +
//                   listDropAnimation[7].value *
//                       (heightFlower - heightFlower / 2),
//               left: width / 4,
//               right: 0,
//               height: heightFlower / 8,
//               child: MoneyPocket(image: 'assets/images/event_2024/lixi4.png'),
//             );
//           }),
//       AnimatedBuilder(
//           animation: listDropAnimation[8],
//           builder: (context, child) {
//             return Positioned(
//               top: heightFlower / 2.8 +
//                   listDropAnimation[8].value *
//                       (heightFlower - heightFlower / 2.8),
//               left: width / 1.8,
//               right: 0,
//               height: heightFlower / 9,
//               child: MoneyPocket(image: 'assets/images/event_2024/lixi5.png'),
//             );
//           })
//     ];
//   }
// }

// class PlayTurnWidget extends StatelessWidget {
//   const PlayTurnWidget({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.sizeOf(context).height;
//     final width = MediaQuery.sizeOf(context).width;
//     final rateAspect = height / width;
//     return Container(
//       decoration: BoxDecoration(
//         // color: Colors.red,
//         image: DecorationImage(
//           image: AssetImage('assets/images/event_2024/soluot.png'),
//           fit: BoxFit.contain,
//         ),
//       ),
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
//         child: Row(
//           // mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text.rich(TextSpan(children: [
//               TextSpan(
//                 text: 'Số lượt: ',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 13 + 1.5 * rateAspect,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               TextSpan(
//                 text: '1124',
//                 style: TextStyle(
//                   color: Colors.yellow.shade700,
//                   fontSize: 14 + 1.5 * rateAspect,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ])),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FunctionMenu extends StatelessWidget {
//   final bool isLightMode;
//   const FunctionMenu({super.key, this.isLightMode = true});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         GestureDetector(
//           onTap: () {
//             //TODO: Giải thưởng
//           },
//           child: Image(
//             image: AssetImage(
//                 'assets/images/event_2024/${isLightMode ? 'nhiemvu' : 'nhiemvu_dem'}.png'),
//           ),
//         ),
//         GestureDetector(
//           onTap: () {
//             //TODO: Thể lệ
//           },
//           child: Image(
//             image: AssetImage(
//                 'assets/images/event_2024/${isLightMode ? 'thele' : 'thele_dem'}.png'),
//           ),
//         ),
//         GestureDetector(
//           onTap: () {
//             //TODO: Vinh danh
//           },
//           child: Image(
//             image: AssetImage(
//                 'assets/images/event_2024/${isLightMode ? 'vinhdanh' : 'vinhdanh_dem'}.png'),
//           ),
//         ),
//         GestureDetector(
//           onTap: () {
//             //TODO: Lịch sử
//           },
//           child: Image(
//             image: AssetImage(
//                 'assets/images/event_2024/${isLightMode ? 'lichsu' : 'lichsu_dem'}.png'),
//           ),
//         ),
//         GestureDetector(
//           onTap: () {
//             //TODO: Nhiệm vụ
//           },
//           child: Image(
//             image: AssetImage(
//                 'assets/images/event_2024/${isLightMode ? 'nhiemvu' : 'nhiemvu_dem'}.png'),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class MoneyPocket extends StatefulWidget {
//   final String image;
//   const MoneyPocket({super.key, required this.image});

//   @override
//   State<MoneyPocket> createState() => _MoneyPocketState();
// }

// class _MoneyPocketState extends State<MoneyPocket>
//     with TickerProviderStateMixin {
//   late AnimationController controllerAngle;
//   late Animation<num> animationAngle;

//   late AnimationController controller;
//   late Animation<Offset> animation;
//   final time = Random().nextInt(500) + 800;

//   final randomAngle = Random().nextInt(13) + 12;

//   final double randomdy = Random().nextInt(12) + 10;
//   @override
//   void initState() {
//     controller = AnimationController(
//         vsync: this, duration: Duration(milliseconds: time));
//     animation =
//         Tween<Offset>(begin: Offset(-10, -randomdy), end: Offset(15, randomdy))
//             .animate(controller);
//     controllerAngle = AnimationController(
//         vsync: this, duration: Duration(milliseconds: time));

//     animationAngle =
//         Tween<num>(begin: -pi / randomAngle, end: pi / (randomAngle + 1))
//             .animate(controllerAngle);
//     controller
//       ..forward()
//       ..repeat(reverse: true);
//     controllerAngle
//       ..forward()
//       ..repeat(reverse: true);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     controllerAngle.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       builder: (context, _) {
//         return AnimatedBuilder(
//           builder: (context, _) {
//             return Transform(
//               alignment: Alignment.topCenter,
//               transform: Matrix4.identity()
//                 ..setEntry(3, 2, 0.001)
//                 ..rotateX(animation.value.dy * pi / 270)
//                 ..rotateZ(animationAngle.value * pi / 4)
//                 ..rotateY(animation.value.dx * pi / 270),
//               child: Image(
//                 image: AssetImage(
//                   widget.image,
//                 ),
//               ),
//             );
//           },
//           animation: animation,
//         );
//       },
//       animation: animationAngle,
//     );
//   }
// }

// class PathPainter extends CustomPainter {
//   Path path;
//   PathPainter({required this.path});

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;

//   @override
//   void paint(Canvas canvas, Size size) {
//     // paint the line
//     final paint = Paint()
//       ..color = Colors.red
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.0;
//     canvas.drawPath(path, paint);
//   }
// }

// class LanternWidget extends StatefulWidget {
//   const LanternWidget({super.key});

//   @override
//   State<LanternWidget> createState() => _LanternWidgetState();
// }

// class _LanternWidgetState extends State<LanternWidget>
//     with EposPopup, TickerProviderStateMixin {
//   @override
//   void dispose() {
//     controllerRotateRopeOne.dispose();
//     controllerLantern.dispose();
//     controllerRotateRopeSecond.dispose();
//     super.dispose();
//   }

//   late AnimationController controllerRotateRopeOne;
//   late Animation<num> animationRotateRopeOne;

//   late AnimationController controllerRotateRopeSecond;
//   late Animation<num> animationRotateRopeSecond;

//   late AnimationController controllerLantern;
//   late Animation<Offset> animationLantern;

//   bool isDrop = false;

//   final timeRotate = Random().nextInt(800) + 1200;

//   final rotateRope = Random().nextInt(6) + 19;

//   final rotateZ = Random().nextInt(3) + 4;

//   @override
//   void initState() {
//     controllerRotateRopeOne = AnimationController(
//         vsync: this, duration: Duration(milliseconds: timeRotate));
//     animationRotateRopeOne =
//         Tween<num>(begin: -pi / rotateRope, end: pi / (rotateRope + 1))
//             .animate(controllerRotateRopeOne);
//     controllerRotateRopeSecond = AnimationController(
//         vsync: this, duration: Duration(milliseconds: timeRotate));
//     animationRotateRopeSecond =
//         Tween<num>(begin: -pi / (rotateRope - 6), end: pi / (rotateRope - 5))
//             .animate(controllerRotateRopeSecond);
//     controllerLantern = AnimationController(
//         vsync: this, duration: Duration(milliseconds: timeRotate + 500));
//     animationLantern =
//         Tween<Offset>(begin: Offset(-25, -10), end: Offset(20, 5))
//             .animate(controllerLantern);
//     controllerLantern
//       ..forward()
//       ..repeat(reverse: true);
//     controllerRotateRopeSecond
//       ..forward()
//       ..repeat(reverse: true);
//     controllerRotateRopeOne
//       ..forward()
//       ..repeat(reverse: true);
//     super.initState();
//   }

//   final double ropeOnePortionHeight = 0.23;

//   final double ropeTwoPortionHeight = 0.27;

//   final double tailLanternPortionHeight = 0.08;

//   final double lanternPortionHeight = 0.42;

//   double heightRopeOne = 0;

//   double heightRopeSecond = 0;

//   double heightTailLantern = 0;

//   double heightLantern = 0;

//   int conicPointOne = 6;

//   int conicPointSecond = 6;

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraint) {
//       final width = 10.0;

//       heightRopeOne = ropeOnePortionHeight * constraint.maxHeight;
//       heightRopeSecond = ropeTwoPortionHeight * constraint.maxHeight;
//       heightTailLantern = tailLanternPortionHeight * constraint.maxHeight;
//       heightLantern = lanternPortionHeight * constraint.maxHeight;
//       return AnimatedBuilder(
//         builder: (context, valueRotate) {
//           return Column(
//             children: [
//               CustomPaint(
//                 size: Size(width, heightRopeOne),
//                 painter: LineOnePainter(
//                   tan(animationRotateRopeOne.value) *
//                       (heightRopeOne - heightRopeOne / conicPointOne),
//                   conicPointOne,
//                 ),
//               ),
//               Transform.translate(
//                 offset: Offset(
//                     tan(animationRotateRopeOne.value) *
//                         (heightRopeOne - heightRopeOne / conicPointOne),
//                     -5),
//                 child: AnimatedBuilder(
//                   builder: (context, value) {
//                     return Transform(
//                       alignment: Alignment.topCenter,
//                       transform: Matrix4.identity()
//                         ..setEntry(3, 2, 0.001)
//                         ..rotateX(animationLantern.value.dy * pi / 270)
//                         ..rotateZ(-animationRotateRopeOne.value.toDouble() *
//                             pi /
//                             rotateZ)
//                         ..rotateY(animationLantern.value.dx * pi / 270),
//                       child: Column(
//                         children: [
//                           SizedBox(
//                             height: heightLantern,
//                             child: Image(
//                               fit: BoxFit.fitHeight,
//                               image: AssetImage(
//                                 'assets/images/event_2024/denlong.png',
//                               ),
//                             ),
//                           ),
//                           Transform.translate(
//                             offset: Offset(0, -2),
//                             child: AnimatedBuilder(
//                               builder: (context, valueRotate) {
//                                 return Column(
//                                   children: [
//                                     CustomPaint(
//                                       size: Size(width, heightRopeSecond),
//                                       painter: LineSecondPainter(
//                                         tan(animationRotateRopeSecond.value) *
//                                             (heightRopeSecond -
//                                                 heightRopeSecond /
//                                                     conicPointSecond),
//                                         conicPointSecond,
//                                       ),
//                                     ),
//                                     Transform.rotate(
//                                       angle: -animationRotateRopeSecond.value
//                                           .toDouble(),
//                                       alignment: Alignment.topCenter,
//                                       child: Transform.translate(
//                                         offset: Offset(
//                                             tan(animationRotateRopeSecond
//                                                     .value) *
//                                                 (heightRopeSecond -
//                                                     heightRopeSecond /
//                                                         conicPointSecond),
//                                             -2),
//                                         child: Container(
//                                           alignment: Alignment.topCenter,
//                                           height: heightTailLantern,
//                                           width: heightTailLantern,
//                                           child: Image(
//                                             image: AssetImage(
//                                                 'assets/images/event_2024/day-denlong.png'),
//                                           ),
//                                         ),
//                                       ),
//                                     )
//                                   ],
//                                 );
//                               },
//                               animation: animationRotateRopeSecond,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                   animation: animationLantern,
//                 ),
//               ),
//             ],
//           );
//         },
//         animation: animationRotateRopeOne,
//       );
//     });
//   }
// }

// class LongLanternWidget extends StatefulWidget {
//   final double opacity;
//   const LongLanternWidget({super.key, this.opacity = 1.0});

//   @override
//   State<LongLanternWidget> createState() => _LongLanternWidgetState();
// }

// class _LongLanternWidgetState extends State<LongLanternWidget>
//     with EposPopup, TickerProviderStateMixin {
//   @override
//   void dispose() {
//     controllerRotateRopeOne.dispose();
//     controllerLantern.dispose();
//     super.dispose();
//   }

//   late AnimationController controllerRotateRopeOne;
//   late Animation<num> animationRotateRopeOne;

//   late AnimationController controllerLantern;
//   late Animation<Offset> animationLantern;

//   bool isDrop = false;

//   final timeRotate = Random().nextInt(800) + 1200;

//   final rotateRope = Random().nextInt(6) + 24;

//   final rotateZ = Random().nextInt(3) + 4;

//   @override
//   void initState() {
//     controllerRotateRopeOne = AnimationController(
//         vsync: this, duration: Duration(milliseconds: timeRotate));
//     animationRotateRopeOne =
//         Tween<num>(begin: -pi / rotateRope, end: pi / (rotateRope + 1))
//             .animate(controllerRotateRopeOne);

//     controllerLantern = AnimationController(
//         vsync: this, duration: Duration(milliseconds: timeRotate + 500));
//     animationLantern =
//         Tween<Offset>(begin: Offset(-35, -10), end: Offset(30, 10))
//             .animate(controllerLantern);
//     controllerLantern
//       ..forward()
//       ..repeat(reverse: true);

//     controllerRotateRopeOne
//       ..forward()
//       ..repeat(reverse: true);
//     super.initState();
//   }

//   final double ropeOnePortionHeight = 0.35;

//   final double lanternPortionHeight = 0.65;

//   double heightRopeOne = 0;

//   double heightLantern = 0;

//   int conicPointOne = 4;

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraint) {
//       final width = 10.0;

//       heightRopeOne = ropeOnePortionHeight * constraint.maxHeight;
//       heightLantern = lanternPortionHeight * constraint.maxHeight;
//       return AnimatedBuilder(
//         builder: (context, valueRotate) {
//           return Column(
//             children: [
//               CustomPaint(
//                 size: Size(width, heightRopeOne),
//                 painter: LineOnePainter(
//                   tan(animationRotateRopeOne.value) *
//                       (heightRopeOne - heightRopeOne / conicPointOne),
//                   conicPointOne,
//                   opacity: widget.opacity,
//                 ),
//               ),
//               Transform.translate(
//                 offset: Offset(
//                     tan(animationRotateRopeOne.value) *
//                         (heightRopeOne - heightRopeOne / conicPointOne),
//                     -5),
//                 child: AnimatedBuilder(
//                   builder: (context, value) {
//                     return Transform(
//                       alignment: Alignment.topCenter,
//                       transform: Matrix4.identity()
//                         ..setEntry(3, 2, 0.001)
//                         ..rotateX(animationLantern.value.dy * pi / 270)
//                         ..rotateZ(-animationRotateRopeOne.value.toDouble() *
//                             pi /
//                             rotateZ)
//                         ..rotateY(animationLantern.value.dx * pi / 270),
//                       child: Column(
//                         children: [
//                           SizedBox(
//                             height: heightLantern,
//                             child: Image(
//                               opacity: AlwaysStoppedAnimation(
//                                 widget.opacity,
//                               ),
//                               fit: BoxFit.fitHeight,
//                               image: AssetImage(
//                                 'assets/images/event_2024/denlong_dai.png',
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                   animation: animationLantern,
//                 ),
//               ),
//             ],
//           );
//         },
//         animation: animationRotateRopeOne,
//       );
//     });
//   }
// }

// class LineOnePainter extends CustomPainter {
//   final double valueAnimation;

//   final double opacity;
//   final int conicPoint;
//   LineOnePainter(this.valueAnimation, this.conicPoint, {this.opacity = 1.0});

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;

//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = Colors.orange.withOpacity(opacity)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 0.8;

//     Path path = Path();
//     path.moveTo(size.width / 2, 0);
//     path.conicTo(size.width / 2, size.height / conicPoint,
//         size.width / 2 + valueAnimation, size.height, 2);
//     canvas.drawPath(path, paint);
//   }
// }

// class LineSecondPainter extends CustomPainter {
//   final double valueAnimation;
//   final double opacity;
//   final int conicPoint;
//   LineSecondPainter(this.valueAnimation, this.conicPoint, {this.opacity = 1.0});

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;

//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = Colors.orange.withOpacity(opacity)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 0.8;

//     Path path = Path();
//     path.moveTo(size.width / 2, 0);
//     path.conicTo(size.width / 2, size.height / conicPoint,
//         size.width / 2 + valueAnimation, size.height, 2);
//     canvas.drawPath(path, paint);
//   }
// }

// // class CurveLinePath extends CustomPainter {
// //   final double height;
// //   final int conicPoint;
// //   CurveLinePath(this.height, this.conicPoint);

// //   @override
// //   bool shouldRepaint(CustomPainter oldDelegate) => true;

// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     Paint paint = Paint()
// //       ..color = Colors.red
// //       ..style = PaintingStyle.stroke
// //       ..strokeWidth = 1.5;

// //     Path path = Path();
// //     path.moveTo(0, 0);

// //     path.conicTo(size.width / 2, 0 + height, size.width, 0, 1);
// //     canvas.drawPath(path, paint);
// //   }
// // }

// // class CurveLinePath2 extends CustomPainter {
// //   final double height;
// //   final int conicPoint;
// //   CurveLinePath2(this.height, this.conicPoint);

// //   @override
// //   bool shouldRepaint(CustomPainter oldDelegate) => true;

// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     Paint paint = Paint()
// //       ..color = Colors.red
// //       ..style = PaintingStyle.stroke
// //       ..strokeWidth = 1.5;

// //     Path path = Path();
// //     path.moveTo(0, 0);

// //     path.conicTo(size.width / 2, height, size.width, 0, 1);
// //     canvas.drawPath(path, paint);
// //   }
// // }
