// import 'package:flame/game.dart';
import 'dart:async';

import 'package:animation_demo/roll_paper_roll.dart/roll_paper_roll.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spritewidget/spritewidget.dart';

import 'sprite_widget_flower_fly.dart';

late ImageMap imageMap;
final bgDimention = Vector2(1242, 2208);

class GameHolidays extends StatefulWidget {
  const GameHolidays({Key? key}) : super(key: key);

  @override
  State createState() => _GameHolidaysState();
}

class _GameHolidaysState extends State<GameHolidays> {
  bool assetsLoaded = false;
  late SnowWorld world;
  late RollPaperRoll rollPaperRoll;

  //Loading assets
  Future<void> _loadAssets(AssetBundle bundle) async {
    imageMap = ImageMap(bundle: bundle);

    await imageMap.load(<String>[
      'assets/images/weathersprites.png',
      'assets/images/canh_hoa.png',
      'assets/images/canh_hoa_1.png',
      'assets/images/canh_hoa_2.png',
      'assets/images/canh_hoa_3.png',
      'assets/images/canh_hoa_4.png',
      'assets/images/canh_hoa_5.png',
      'assets/images/canh_hoa_6.png',
      'assets/images/canh_hoa_7.png',
      'assets/images/canh_hoa_8.png',
      'assets/images/canh_hoa_9.png',
    ]);
  }

  @override
  void initState() {
    super.initState();
    _loadAssets(rootBundle).then((_) {
      setState(() {
        assetsLoaded = true;
        world = SnowWorld();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    rollPaperRoll = RollPaperRoll(size);
    return Scaffold(
      appBar: null,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/roll_paper_roll/background.jpg'),
              fit: BoxFit.fill),
        ),
        child: Stack(
          children: [
            /// Twinkle light around one frame
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        'assets/images/roll_paper_roll/nhap_nhay.gif'),
                    fit: BoxFit.fill),
              ),
            ),

            /// Flutter Flame Icon, Cat Animation
            GameWidget(game: rollPaperRoll),

            ///  Start Game Button
            const AbsorbPointer(
                absorbing: false, child: StartGameTransparentColor()),

            /// Bloom Flowers
            if (assetsLoaded)
              IgnorePointer(
                child: SpriteWidget(
                  world,
                ),
              ),

            /// Remain Turns
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.only(top: 40, right: 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.black54,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image(
                        width: size.width * 50 / bgDimention.x,
                        image: const AssetImage(
                            'assets/images/roll_paper_roll/icon_luot_choi.png')),
                    const SizedBox(width: 12),
                    const Text('10',
                        style: TextStyle(fontSize: 20, color: Colors.white60)),
                    const Text(' lượt chơi',
                        style: TextStyle(fontSize: 20, color: Colors.white60))
                  ],
                ),
              ),
            ),

            /// Share Facebook and Achievement
            Positioned(
                top: size.height * 300 / bgDimention.y,
                right: 12,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: (() {
                        print('Share Facebook');
                      }),
                      child: Image(
                        width: size.width * 190 / bgDimention.x,
                        image: const AssetImage(
                            'assets/images/roll_paper_roll/icon_facebook.png'),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        print('Achievement');
                      },
                      child: Image(
                        width: size.width * 190 / bgDimention.x,
                        image: const AssetImage(
                            'assets/images/roll_paper_roll/icon_vinh_danh.png'),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class StartGameTransparentColor extends StatelessWidget {
  const StartGameTransparentColor({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          print('Start Game');
        },
        child: Container(
          color: Colors.transparent,
          height: size.height * 1160 / bgDimention.y,
          width: size.width * 750 / bgDimention.x,
          margin: EdgeInsets.only(
              left: size.width * 245 / bgDimention.x,
              top: size.height * 490 / bgDimention.y),
        ));
  }
}
