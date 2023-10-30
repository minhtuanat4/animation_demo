import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Timer? timerFirstTimeGlobal;
int countInitTime = 4;

class CardObject {
  final int index;
  final AnimationController firstController;

  CardObject(this.firstController, this.index);
}

class PikachuGame extends StatelessWidget {
  const PikachuGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class TableDemoProvider extends ChangeNotifier {
  List<int> itemSelected = [];
  bool screenIsClick = true;

  CardObject? firstObject;
  CardObject? secondObject;

  List<bool> _itemIsDisplay = [true, true, true, true, true, true];
  List<bool> get itemIsDisplay => _itemIsDisplay;

  set itemIsDisplay(List<bool> value) {
    _itemIsDisplay = value;
    notifyListeners();
  }

  void changeNotifyListeners() {
    notifyListeners();
  }

  void clearItemSelected() {
    itemSelected.clear();
  }

  bool _isIgnored = false;
  bool get isIgnored => _isIgnored;

  set isIgnored(bool value) {
    _isIgnored = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _itemIsDisplay = [];
    itemSelected = [];
    screenIsClick = true;
    firstObject = null;
    secondObject = null;
    super.dispose();
  }
}

class TableDemoWidget extends StatefulWidget {
  const TableDemoWidget({super.key});

  @override
  State<TableDemoWidget> createState() => _TableDemoWidgetState();
}

class _TableDemoWidgetState extends State<TableDemoWidget>
    with TickerProviderStateMixin {
  List<GlobalKey> lstKey = [
    GlobalKey(debugLabel: '1'),
    GlobalKey(debugLabel: '2'),
    GlobalKey(debugLabel: '3'),
    GlobalKey(debugLabel: '4'),
    GlobalKey(debugLabel: '5'),
    GlobalKey(debugLabel: '6'),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TableDemoProvider(),
        )
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Table Widget Demo'),
        ),
        body: Center(
          child: Selector<TableDemoProvider, List<bool>>(
              selector: (_, pr) => pr.itemIsDisplay,
              builder: (context, itemIsDisplay, child) {
                return Column(
                  children: [
                    Row(children: <Widget>[
                      CardGame(
                        index: 1,
                        image:
                            'assets/images/roll_paper_roll/icon_facebook.png',
                        id: 1,
                      ),
                      CardGame(
                        index: 2,
                        id: 2,
                      ),
                      CardGame(
                        index: 3,
                        image:
                            'assets/images/roll_paper_roll/icon_facebook.png',
                        id: 1,
                      ),
                    ]),
                    SizedBox(
                      height: 10,
                    ),
                    Row(children: <Widget>[
                      CardGame(
                        index: 4,
                        id: 2,
                      ),
                      CardGame(
                        index: 5,
                        image:
                            'assets/images/roll_paper_roll/icon_facebook.png',
                        id: 1,
                      ),
                      CardGame(
                        index: 6,
                        id: 2,
                      ),
                    ])
                  ],
                );
              }),
        ),
      ),
    );
  }
}

class CardGame extends StatefulWidget {
  final String image;
  final int id;
  final int index;
  const CardGame({
    super.key,
    this.image = 'assets/images/roll_paper_roll/icon_vinh_danh.png',
    required this.id,
    required this.index,
  });

  @override
  State<CardGame> createState() => _CardGameState();
}

class _CardGameState extends State<CardGame>
    with SingleTickerProviderStateMixin {
  late AnimationController controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));

  late Animation<double> animation;
  double angle = pi;
  bool isVisiable = true;
  late TableDemoProvider provider;

  @override
  void initState() {
    provider = context.read<TableDemoProvider>();
    animation = Tween<double>(begin: 0, end: 1).animate(controller);

    super.initState();
  }

  @override
  void dispose() {
    provider.clearItemSelected();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<TableDemoProvider, bool>(
        selector: (_, pr) => pr.isIgnored,
        builder: (context, isIgnored, child) {
          return IgnorePointer(
            ignoring: false,
            child: GestureDetector(
              onTap: () {
                if (!provider.screenIsClick) {
                  print('screen Not Click ');
                  return;
                }
                Timer? _timerFirstObject;

                if (provider.itemSelected.length == 1 &&
                    provider.firstObject!.index == widget.index) {
                  return;
                }
                provider.itemSelected = provider.itemSelected + [widget.id];

                if (provider.itemSelected.length == 2) {
                  provider.screenIsClick = false;

                  removeTimer(_timerFirstObject);
                  controller.forward();
                  // after2Seconds(CardObject(controller, widget.index));
                  handleObjectSecond();
                } else if (provider.itemSelected.length == 1) {
                  provider.firstObject = CardObject(controller, widget.index);
                  provider.firstObject?.firstController.forward();

                  countInitTime = 4;

                  _timerFirstObject = Timer.periodic(
                    const Duration(seconds: 1),
                    (timer) {
                      if (provider.itemSelected.length == 2) {
                        timer.cancel();
                      }
                      countInitTime--;
                      print('CountInitTime CountInitTime $countInitTime');

                      if (countInitTime == 0) {
                        removeTimer(timer);
                        removeFirstItemSelected(provider.firstObject);
                      }
                    },
                  );
                }
              },
              child: Visibility(
                visible: provider.itemIsDisplay[widget.index - 1],
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateX(angle * animation.value),
                        child: animation.value >= 0 && animation.value <= 0.5
                            ? const CircleAvatar(
                                backgroundColor: Colors.grey,
                              )
                            : Image.asset(
                                widget.image,
                                gaplessPlayback: true,
                              ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        });
  }

  void removeTimer(Timer? timerFirstObject) {
    if (timerFirstObject != null) {
      print('Ontick cancel ');
      countInitTime = 4;
      timerFirstObject.cancel();
    }
  }

  void after2Seconds(CardObject? firstObject, Timer? timerFirstObject) {}

  void removeFirstItemSelected(CardObject? firstObject) {
    if (provider.screenIsClick && provider.itemSelected.length == 1) {
      final itemSelected = provider.itemSelected;
      itemSelected.remove(itemSelected.first);
      provider.itemSelected = itemSelected;
      firstObject?.firstController.reverse();
      print('Remove First Object After Limited Time ' +
          provider.itemSelected.length.toString());
    }
  }

  void handleObjectSecond() {
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        if (provider.itemSelected.length == 2 &&
            provider.itemSelected[0] == provider.itemSelected[1]) {
          final itemIsDisplay = [...provider.itemIsDisplay];

          itemIsDisplay[provider.firstObject!.index - 1] = false;
          itemIsDisplay[widget.index - 1] = false;
          provider.itemIsDisplay = itemIsDisplay;
          // provider.firstObject?.firstController.dispose();
          // controller.dispose();
        } else {
          provider.firstObject?.firstController.reverse();
          controller.reverse();
        }
        print('After 500 Remove clearItemSelected .screenIsClick = true');
        provider.clearItemSelected();
        provider.screenIsClick = true;
      },
    );
  }
}
