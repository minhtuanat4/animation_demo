import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DemoClass {
  final String text;
  const DemoClass(this.text);
}

const lstDemoClass = [
  DemoClass('Android'),
  DemoClass('Flutter'),
  DemoClass('iOS'),
];

class CupertinoSlideSegmentsControl extends StatefulWidget {
  const CupertinoSlideSegmentsControl({super.key});

  @override
  State<CupertinoSlideSegmentsControl> createState() =>
      _CupertinoSlideSegmentsControlState();
}

class _CupertinoSlideSegmentsControlState
    extends State<CupertinoSlideSegmentsControl> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('CupertinoSlideSegmentsControl'),
      ),
      body: const CupertinoWidget(),
    );
  }
}

class CupertinoWidget extends StatefulWidget {
  const CupertinoWidget({super.key});

  @override
  State<CupertinoWidget> createState() => _CupertinoWidgetState();
}

class _CupertinoWidgetState extends State<CupertinoWidget> {
  int? groupValue = 0;
  Map<int, Widget> mapLst = {};

  @override
  void initState() {
    caculateMapLst();
    super.initState();
  }

  void caculateMapLst() {
    for (var i = 0; i < lstDemoClass.length; i++) {
      mapLst.addAll(<int, Widget>{
        i: TextWidget(
          text: lstDemoClass[i].text,
        )
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoSlidingSegmentedControl(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        groupValue: groupValue,
        thumbColor: Colors.blue,
        backgroundColor: Colors.white,
        children: mapLst,
        onValueChanged: (value) {
          setState(() {
            groupValue = value as int;
          });
        },
      ),
    );
  }
}

class TextWidget extends StatelessWidget {
  final String text;
  const TextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Colors.black, fontSize: 20),
    );
  }
}
