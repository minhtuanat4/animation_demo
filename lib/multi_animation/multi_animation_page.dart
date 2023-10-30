import 'package:animation_demo/main.dart';
import 'package:flutter/material.dart';

List<double> lstSpace = [];

class MultiAnimation extends StatefulWidget {
  const MultiAnimation({super.key});

  @override
  State<MultiAnimation> createState() => _MultiAnimationState();
}

class _MultiAnimationState extends State<MultiAnimation>
    with TickerProviderStateMixin {
  List<String> lstString = [];
  List<AnimationController> lstController = [];
  List<Animation> lstAnimation = [];
  List<ValueNotifier<double>> lstNotify = [];
  List<GlobalKey<_ItemWidgetState>> lstGlobalKey = [];

  void initListString() {
    for (var i = 0; i < 81; i++) {
      lstSpace.add(10.0);
      lstGlobalKey.add(GlobalKey<_ItemWidgetState>());
      final controller = AnimationController(
          vsync: this, duration: const Duration(seconds: 1));
      lstController.add(controller);
      lstAnimation.add(Tween<double>(begin: 0, end: 1).animate(controller));
      lstNotify.add(ValueNotifier<double>(0.0));
      lstString.add('Animation $i');
    }
  }

  void runAnimation() {
    for (var i = 0; i < 12; i++) {
      lstAnimation[i]
        ..addListener(() {
          lstNotify[i].value = lstAnimation[i].value;
        })
        ..addStatusListener((status) {});
      lstController[i]
        ..reset()
        ..forward();
    }
  }

  void runTranslateAnimationByGlobalKey() {
    for (var i = 0; i < 12; i++) {
      if (i == 3 || i == 10) {
        continue;
      }
      lstSpace[i] = 200;
      final stateItem = lstGlobalKey[i].currentState!;
      stateItem.isHasText = true;
      stateItem.controllerScale.reset();
      stateItem.controllerTranslate
        ..addStatusListener((status) {})
        ..reset()
        ..forward();
    }
  }

  void runTranslateAnimationByGlobalKey2() {
    for (var i = 0; i < 12; i++) {
      if (i == 3 || i == 10) {
        continue;
      }
      lstSpace[i] = 100;
      final stateItem = lstGlobalKey[i].currentState!;

      stateItem.controllerScale.reset();
      stateItem.controllerTranslate
        ..addStatusListener((status) {})
        ..reset()
        ..forward();
    }
  }

  void runScaleAnimationByGlobalKey() {
    for (var i = 0; i < 12; i++) {
      if (i == 3 || i == 10) {
        continue;
      }
      final stateItem = lstGlobalKey[i].currentState!;
      stateItem.controllerScale
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {}
        })
        ..reset()
        ..forward();
    }
  }

  @override
  void initState() {
    initListString();
    super.initState();
  }

  @override
  void dispose() {
    disposeAnimation();
    super.dispose();
  }

  void disposeAnimation() {
    for (var element in lstController) {
      element.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Multi Animation',
      )),
      body: Column(
        children: [
          OptionButton(
            label: 'Run Animation',
            onPressed: () async {
              runAnimation();
            },
          ),
          OptionButton(
            label: 'Run Translate Animation By Global Key',
            onPressed: () async {
              runTranslateAnimationByGlobalKey();
            },
          ),
          OptionButton(
            label: 'Run Scale Animation By Global Key',
            onPressed: () async {
              runScaleAnimationByGlobalKey();
            },
          ),
          OptionButton(
            label: 'Run Scale Animation By Global Key2',
            onPressed: () async {
              runTranslateAnimationByGlobalKey();
            },
          ),
          OptionButton(
            label: 'Run Scale Animation By Global Key2',
            onPressed: () async {
              runTranslateAnimationByGlobalKey();
            },
          ),
          // Expanded(
          //   child: ListView.separated(
          //     separatorBuilder: (context, index) {
          //       return const SizedBox(height: 10);
          //     },
          //     itemCount: lstString.length,
          //     itemBuilder: (context, index) {
          //       return ValueListenableBuilder<double>(
          //           valueListenable: lstNotify[index],
          //           builder: (context, snapshot, child) {
          //             return Transform.translate(
          //               offset: Offset(10 + snapshot * 60, index * 10),
          //               child: Text(lstString[index]),
          //             );
          //           });
          //     },
          //   ),
          // ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
              itemCount: lstString.length,
              itemBuilder: (context, index) {
                return ItemWidget(
                  key: lstGlobalKey[index],
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ItemWidget extends StatefulWidget {
  final int index;
  const ItemWidget({super.key, required this.index});

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> with TickerProviderStateMixin {
  late final AnimationController controllerTranslate;
  late final AnimationController controllerScale;

  late final Animation animationTranslate;
  late final Animation animationScale;
  final translateNotify = ValueNotifier<double>(0.0);
  final opacityNotify = ValueNotifier<double>(0.0);
  bool isHasText = false;
  @override
  void initState() {
    controllerTranslate =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    controllerScale = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    animationTranslate =
        Tween<double>(begin: 0, end: 1).animate(controllerTranslate)
          ..addListener(() {
            translateNotify.value = controllerTranslate.value;
          });

    animationScale = Tween<double>(begin: 0, end: 1).animate(controllerScale)
      ..addListener(() {
        opacityNotify.value = controllerScale.value;
      });

    super.initState();
  }

  @override
  void dispose() {
    controllerTranslate.dispose();
    controllerScale.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isHasText
        ? const SizedBox()
        : ValueListenableBuilder<double>(
            valueListenable: translateNotify,
            builder: (context, snapshot, child) {
              return Transform.translate(
                offset: Offset(
                    lstSpace[widget.index] + snapshot * 60, widget.index * 10),
                child: ValueListenableBuilder<double>(
                    valueListenable: opacityNotify,
                    builder: (context, snapshot, child) {
                      print(snapshot.toString());
                      return Opacity(
                          opacity: 1.0 - snapshot,
                          child:
                              Text('Animation ${isHasText ? 'Add More' : ''}'));
                    }),
              );
            });
  }
}
