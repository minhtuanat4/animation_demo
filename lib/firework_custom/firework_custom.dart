import 'dart:math';

import 'package:flutter/material.dart';

// class FireworkCustom extends StatefulWidget {
//   const FireworkCustom({super.key});

//   @override
//   State<FireworkCustom> createState() => _FireworkCustomState();
// }

// class _FireworkCustomState extends State<FireworkCustom> {
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           margin: EdgeInsets.only(top: 1.sw / 3, right: 100),
//           child: Align(
//             alignment: Alignment.topCenter,
//             child: SizedBox(
//                 height: 200,
//                 width: 200,
//                 child: const FireWorkCustom(branchCount: 12)),
//           ),
//         ),
//         Container(
//           margin: EdgeInsets.only(top: 1.sw / 3.5),
//           child: Align(
//             alignment: Alignment.topCenter,
//             child: SizedBox(
//                 height: 180,
//                 width: 180,
//                 child: Transform.rotate(
//                     angle: 90, child: const FireWorkCustom(branchCount: 18))),
//           ),
//         ),
//         Container(
//           margin: EdgeInsets.only(top: 1.sw / 2.5, left: 100),
//           child: Align(
//             alignment: Alignment.topCenter,
//             child: SizedBox(
//                 height: 220,
//                 width: 220,
//                 child: Transform.rotate(
//                     angle: 60, child: const FireWorkCustom(branchCount: 24))),
//           ),
//         ),
//         Container(
//           margin: EdgeInsets.only(
//             top: 1.sw / 3,
//           ),
//           child: Align(
//             alignment: Alignment.topCenter,
//             child: SizedBox(
//                 height: 220,
//                 width: 220,
//                 child: Transform.rotate(
//                     angle: 135, child: const FireWorkCustom(branchCount: 24))),
//           ),
//         ),
//         Container(
//           margin: EdgeInsets.only(
//             top: 1.sw / 2,
//           ),
//           child: Align(
//             alignment: Alignment.topCenter,
//             child: SizedBox(
//                 height: 220,
//                 width: 220,
//                 child: Transform.rotate(
//                     angle: 150, child: const FireWorkCustom(branchCount: 18))),
//           ),
//         ),
//         Container(
//           margin: EdgeInsets.only(top: 1.sw / 2.3, right: 80),
//           child: Align(
//             alignment: Alignment.topCenter,
//             child: SizedBox(
//                 height: 280,
//                 width: 280,
//                 child: Transform.rotate(
//                     angle: 220, child: const FireWorkCustom(branchCount: 30))),
//           ),
//         ),
//         Container(
//           margin: EdgeInsets.only(top: 1.sw / 2.2, left: 100),
//           child: Align(
//             alignment: Alignment.topCenter,
//             child: SizedBox(
//                 height: 300,
//                 width: 300,
//                 child: Transform.rotate(
//                     angle: 45, child: const FireWorkCustom(branchCount: 36))),
//           ),
//         ),
//       ],
//     );
//   }
// }

const List<Color> lst = [
  Colors.red,
  Colors.yellow,
  Colors.orange,
  Colors.deepPurple,
  Colors.green,
  Colors.blue,
  Colors.red,
  Colors.red,
  Colors.yellow,
  Colors.orange,
  Colors.deepPurple,
  Colors.green,
  Colors.blue,
  Colors.red,
  Colors.yellow,
  Colors.orange,
  Colors.deepPurple,
  Colors.green,
  Colors.blue,
  Colors.red,
  Colors.yellow,
  Colors.orange,
  Colors.deepPurple,
  Colors.green,
  Colors.blue,
  Colors.red,
  Colors.yellow,
  Colors.orange,
  Colors.deepPurple,
  Colors.green,
  Colors.blue,
  Colors.red,
  Colors.yellow,
  Colors.orange,
  Colors.deepPurple,
  Colors.green,
  Colors.blue,
  Colors.red,
  Colors.yellow,
  Colors.orange,
  Colors.deepPurple,
  Colors.green,
  Colors.blue,
];

class FireWorkCustom extends StatefulWidget {
  final int branchCount;
  final Color color;
  const FireWorkCustom({
    required this.branchCount,
    this.color = Colors.white,
    super.key,
  });

  @override
  State<FireWorkCustom> createState() => _FireWorkCustomState();
}

class _FireWorkCustomState extends State<FireWorkCustom>
    with SingleTickerProviderStateMixin {
  late AnimationController ctrol;
  late Animation<double> ani;
  @override
  void initState() {
    // TODO: implement initState
    ctrol =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    ani = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: ctrol, curve: Curves.bounceInOut));
    ctrol.forward();
    super.initState();
  }

  List<Widget> getFireWork(double widthBranch) {
    final lstWidget = <Widget>[];
    final angleDefault = (pi * 2) / widget.branchCount;
    for (var i = 0; i < widget.branchCount; i++) {
      lstWidget.add(Transform(
        transform: Matrix4.rotationY(pi),
        alignment: Alignment.center,
        child: Transform.rotate(
          angle: angleDefault * i,
          child: BranchFireWork(
            listenable: ani,
            color: lst[i],
            width: widthBranch,
            height: 3,
          ),
        ),
      ));
    }
    return lstWidget;
  }

  Widget centerPoint(double width) {
    return AnimatedBuilder(
      animation: ani,
      builder: (context, child) {
        return Transform.scale(
          scale: 1 - ani.value,
          child: child ?? const SizedBox(),
        );
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }

  @override
  void dispose() {
    ctrol.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final centerHorizol = constraints.maxWidth / 2;
      final widthCenterPoint = centerHorizol / (2 * 5);
      return Stack(alignment: Alignment.center, children: [
        ...getFireWork(centerHorizol),
        // Container(
        //   margin: EdgeInsets.only(left: centerHorizol),
        //   color: Colors.pink,
        //   width: centerHorizol,
        //   height: 10,
        // ),
        centerPoint(widthCenterPoint)
      ]);
    });
  }
}

class BranchFireWork extends StatelessWidget {
  final Animation<double> listenable;
  final Color color;
  final double width;
  final double height;
  const BranchFireWork({
    required this.listenable,
    required this.width,
    required this.height,
    this.color = Colors.yellow,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: listenable,
      builder: (context, child) {
        return listenable.isCompleted
            ? const SizedBox()
            : Container(
                margin: EdgeInsets.only(left: width),
                color: color,
                width: (1 - listenable.value) * width,
                height: height,
              );
      },
    );
  }
}
