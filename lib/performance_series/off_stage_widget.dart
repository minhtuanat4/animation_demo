import 'package:flutter/material.dart';

const List<int> lstExample = [1, 2, 3, 4, 5];

class PerformanceSeriesPage extends StatefulWidget {
  const PerformanceSeriesPage({super.key});

  @override
  State<PerformanceSeriesPage> createState() => _PerformanceSeriesPageState();
}

class _PerformanceSeriesPageState extends State<PerformanceSeriesPage> {
  bool isPressed = false;
  double paddingLeft = 100;

  void toggleActiion() {
    setState(() {
      // isPressed = !isPressed;
      paddingLeft = 200;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Performance Series'),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Flexible(
          child: ListView.separated(
            itemBuilder: (_, index) {
              print('object');
              return SizedBox(
                height: 8,
              );
            },
            separatorBuilder: (_, index) {
              return ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  lstExample[index].toString(),
                ),
                subtitle: Offstage(
                  offstage: index == 2,
                  child: Text('Description'),
                ),
              );
            },
            itemCount: lstExample.length,
          ),
        ),
        const MyWidget(),
        const SizedBox(
          height: 24,
        ),
        GestureDetector(
          onTap: () {
            toggleActiion();
          },
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Action Button',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
      ]),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  double paddingLeft = 100;

  void toggleActiion() {
    setState(() {
      // isPressed = !isPressed;
      paddingLeft = 200;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedContainer(
        height: paddingLeft,
        width: paddingLeft,
        duration: const Duration(seconds: 1),
        color: Colors.red,
        // Provide an optional curve to make the animation feel smoother.
        curve: Curves.fastOutSlowIn,
        margin: EdgeInsets.only(left: 12),
      ),
    );
  }
}
