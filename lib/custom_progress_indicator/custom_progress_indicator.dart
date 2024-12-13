import 'package:animation_demo/resource/definition_color.dart';
import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatefulWidget {
  const CustomProgressIndicator({super.key});

  @override
  State<CustomProgressIndicator> createState() =>
      _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator>
    with TickerProviderStateMixin {
  final positionNotifier = ValueNotifier<double>(0);

  double startPosition = 0.0;

  double maxRight = 105;

  double currentRight = 0.0;

  double width = 200;
  List<GlobalKey<_SlideWidgetCustomState>> lstKey = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];
  int currentSlideChange = -1;
  void resetSlide() {
    if (currentSlideChange != -1) {
      lstKey[currentSlideChange].currentState?.resetPosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Progress Indicator'),
      ),
      body: GestureDetector(
        // onTap: () {
        //   resetSlide();
        // },
        // onTapDown: (v) {
        //   resetSlide();
        // },
        onVerticalDragDown: (v) {
          resetSlide();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  resetSlide();
                },
                child: Text('data'),
              ),
              Expanded(
                child: ListView.separated(
                    itemBuilder: (_, index) {
                      return SlideWidgetCustom(
                        height: 80,
                        firstChild: Padding(
                          padding: const EdgeInsets.only(top: 4, left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Minh Tuan'),
                              Text('1232312312312'),
                              Text('EVN Ha Noi'),
                            ],
                          ),
                        ),
                        onEdit: () {},
                        onDel: () {},
                        key: lstKey[index],
                        onSlideChange: (value) {
                          if (value) {
                            if (currentSlideChange != -1 &&
                                currentSlideChange != index) {
                              lstKey[currentSlideChange]
                                  .currentState
                                  ?.resetPosition();
                            }
                            currentSlideChange = index;
                          }
                        },
                      );
                    },
                    separatorBuilder: (_, index) {
                      return const SizedBox(
                        height: 12,
                      );
                    },
                    itemCount: lstKey.length),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SlideWidgetCustom extends StatefulWidget {
  const SlideWidgetCustom({
    super.key,
    required this.firstChild,
    required this.height,
    this.bgColorFirst,
    this.secondWidgetWidth,
    this.borderRadius,
    required this.onEdit,
    required this.onDel,
    required this.onSlideChange,
  });

  final double? secondWidgetWidth;
  final double height;
  final Widget firstChild;
  final Color? bgColorFirst;
  final double? borderRadius;
  final VoidCallback onEdit;
  final VoidCallback onDel;
  final Function(bool) onSlideChange;

  @override
  State<SlideWidgetCustom> createState() => _SlideWidgetCustomState();
}

class _SlideWidgetCustomState extends State<SlideWidgetCustom> {
  final positionNotifier = ValueNotifier<double>(0);

  double startPosition = 0.0;

  double maxRight = 5;

  double currentRight = 0.0;

  double radius = 4;

  bool isReset = true;

  @override
  void initState() {
    radius = widget.borderRadius ?? 4;
    maxRight = maxRight + (widget.secondWidgetWidth ?? 128);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SlideWidgetCustom oldWidget) {
    // print('didUpdateWidget ChooseProductQuantity');
    if (mounted) {
      resetPosition();
    }
    super.didUpdateWidget(oldWidget);
  }

  void resetPosition() {
    positionNotifier.value = currentRight = 0;
    isReset = true;
    widget.onSlideChange(!isReset);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: widget.secondWidgetWidth ?? 128,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        resetPosition();
                        widget.onEdit();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorGrey,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(radius),
                            bottomLeft: Radius.circular(radius),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit_document,
                              color: colorWhite,
                              size: 20,
                            ),
                            Text(
                              'Chỉnh sửa',
                              style: TextStyle(
                                color: colorWhite,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        resetPosition();
                        widget.onDel();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: colorRed,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(radius),
                              bottomRight: Radius.circular(radius),
                            )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete,
                              color: colorWhite,
                              size: 20,
                            ),
                            Text(
                              'Xoá',
                              style: TextStyle(
                                color: colorWhite,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onHorizontalDragEnd: (value) {
              if (currentRight == maxRight) {
                if (positionNotifier.value > maxRight) {
                  positionNotifier.value = currentRight = maxRight;
                  isReset = false;
                  widget.onSlideChange(!isReset);
                } else {
                  resetPosition();
                }
                return;
              }
              if (positionNotifier.value > 20) {
                positionNotifier.value = currentRight = maxRight;
                isReset = false;
                widget.onSlideChange(!isReset);
                return;
              } else if (positionNotifier.value <= 20) {
                resetPosition();
                return;
              }
            },
            onHorizontalDragStart: (value) {
              startPosition = value.globalPosition.dx;
            },
            onHorizontalDragUpdate: (update) {
              final updatePosition =
                  startPosition - update.globalPosition.dx + currentRight;
              if (updatePosition < 0) {
                positionNotifier.value = 0;
                return;
              }

              positionNotifier.value = updatePosition;
            },
            child: ValueListenableBuilder(
              builder: (context, _, __) {
                return AnimatedContainer(
                  onEnd: () {
                    print('end');
                  },
                  transform:
                      Matrix4.translationValues(-positionNotifier.value, 0, 0),
                  duration: const Duration(milliseconds: 150),
                  child: Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: widget.bgColorFirst ?? colorWhite,
                      borderRadius: BorderRadius.all(
                        Radius.circular(radius),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 1,
                        ),
                      ],
                    ),
                    child: widget.firstChild,
                  ),
                );
              },
              valueListenable: positionNotifier,
            ),
          ),
        ],
      ),
    );
  }
}
