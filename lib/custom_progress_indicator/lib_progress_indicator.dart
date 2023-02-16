import 'package:flutter/material.dart';

class LibProgressIndicator extends StatefulWidget {
  final double totalValue;
  final Function(int) onChanged;
  const LibProgressIndicator(
      {super.key, this.totalValue = 100, required this.onChanged});

  @override
  State<LibProgressIndicator> createState() => _LibProgressIndicatorState();
}

class _LibProgressIndicatorState extends State<LibProgressIndicator> {
  double widthActiveProgress = 100;
  double radiusIndicator = 10;
  late double paddingProgressLine = radiusIndicator * 2;
  double marginHorizontalAll = 5;
  double heightLine = 6;
  double currentValue = 0;
  @override
  void initState() {
    currentValue = widget.totalValue / 2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    widthActiveProgress = size.width / 2;

    return SizedBox.expand(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: marginHorizontalAll,
        ),
        child: MyWidget(
          heightLine: heightLine,
          marginHorizontalAll: marginHorizontalAll,
          paddingProgressLine: paddingProgressLine,
          radiusIndicator: radiusIndicator,
          totalValue: widget.totalValue,
          widthActiveProgressParam: widthActiveProgress,
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  final double marginHorizontalAll;
  final double radiusIndicator;
  final double widthActiveProgressParam;
  final double totalValue;
  final double paddingProgressLine;
  final double heightLine;
  final Function(int) onChanged;
  const MyWidget({
    super.key,
    required this.marginHorizontalAll,
    required this.radiusIndicator,
    required this.widthActiveProgressParam,
    required this.totalValue,
    required this.paddingProgressLine,
    required this.heightLine,
    required this.onChanged,
  });

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  double widthActiveProgress = 0;
  double currentValue = 0;
  @override
  void initState() {
    widthActiveProgress = widget.widthActiveProgressParam;
    currentValue = widget.totalValue / 2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        GestureDetector(
          onTapDown: (details) {
            final validValue =
                widget.marginHorizontalAll + widget.radiusIndicator * 2;
            if (details.globalPosition.dx >= (validValue) &&
                details.localPosition.dx <= size.width - (validValue)) {
              widthActiveProgress = details.globalPosition.dx;

              currentValue = ((widthActiveProgress - (validValue)) /
                      (size.width - 10 - (validValue * 2)) *
                      widget.totalValue)
                  .clamp(0, widget.totalValue);
              widget.onChanged(currentValue.toInt());

              setState(() {});
            }
          },
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(
                horizontal: widget.paddingProgressLine, vertical: 10),
            child: Card(
              elevation: 4,
              shadowColor: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: SizedBox(
                  height: widget.heightLine,
                  width: double.maxFinite,
                ),
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 0),
          width: widthActiveProgress - widget.radiusIndicator / 2,
          child: IgnorePointer(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: widget.paddingProgressLine),
              child: Card(
                color: Colors.blue,
                elevation: 4,
                shadowColor: Colors.grey,
                child: SizedBox(height: widget.heightLine),
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 0),
          left: widthActiveProgress -
              widget.marginHorizontalAll -
              widget.paddingProgressLine,
          child: Draggable(
            axis: Axis.horizontal,
            onDragUpdate: (details) {
              final validValue =
                  widget.marginHorizontalAll + widget.radiusIndicator * 2;
              if (details.globalPosition.dx >= (validValue) &&
                  details.localPosition.dx <= size.width - (validValue)) {
                widthActiveProgress = details.globalPosition.dx;

                currentValue = ((widthActiveProgress - (validValue)) /
                        (size.width - 10 - (validValue * 2)) *
                        widget.totalValue)
                    .clamp(0, widget.totalValue);
                widget.onChanged(currentValue.toInt());
                print('object $currentValue');
                setState(() {});
              }
            },
            feedback: SizedBox(
              height: widget.radiusIndicator * 2,
              width: widget.radiusIndicator * 2,
            ),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Card(
                color: Colors.white,
                shadowColor: Colors.grey,
                elevation: 4,
                shape: const CircleBorder(),
                child: SizedBox(
                  height: widget.radiusIndicator * 2,
                  width: widget.radiusIndicator * 2,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text('Progress:  ${currentValue.floor()}'),
              ),
            ],
          ),
        )
      ],
    );
    ;
  }
}
