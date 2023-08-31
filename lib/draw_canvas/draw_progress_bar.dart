import 'dart:ui';

import 'package:flutter/material.dart';

// class DrawProgressBar extends StatefulWidget {
//   const DrawProgressBar({super.key});

//   @override
//   State<DrawProgressBar> createState() => _DrawProgressBarState();
// }

// class _DrawProgressBarState extends State<DrawProgressBar> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('DrawProgressBar'),
//       ),
//       body: SizedBox.expand(
//         child: Stack(
//           children: [
//             Positioned(
//                 top: 0,
//                 left: 0,
//                 child: SizedBox(
//                   height: 400,
//                   width: 400,
//                   child: CustomPaint(
//                     foregroundPainter: DashedArc(color: Colors.green),
//                   ),
//                 ))
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DashedArc extends CustomPainter {
//   final Color color;

//   DashedArc({required this.color});

//   @override
//   void paint(Canvas canvas, Size size) {
//     // TODO: remove me. This makes it easier to tell
//     // where the canvas should be
//     canvas.drawRect(
//         Offset.zero & size,
//         Paint()
//           ..color = Colors.black
//           ..style = PaintingStyle.stroke);

//     var width = 520, height = 520, scale;

//     // this is a simple Boxfit calculation for the `cover` mode. You could
//     // use the applyBoxFit function instead, but as it doesn't return a
//     // centered rect it's almost as much work to use it as to just do it
//     // manually (unless someone has a better way in which case I'm all ears!)
//     double rw = size.width / width;
//     double rh = size.height / height;

//     double actualWidth, actualHeight, offsetLeft, offsetTop;
//     if (rw > rh) {
//       // height is constraining attribute so scale to it
//       actualWidth = rh * width;
//       actualHeight = size.height;
//       offsetTop = 0.0;
//       offsetLeft = (size.width - actualWidth) / 2.0;
//       scale = rh;
//     } else {
//       // width is constraining attribute so scale to it
//       actualHeight = rw * height;
//       actualWidth = size.width;
//       offsetLeft = 0.0;
//       offsetTop = (size.height - actualHeight) / 2.0;
//       scale = rw;
//     }

//     canvas.translate(offsetLeft, offsetTop);
//     canvas.scale(scale);

//     // parameters from the original drawing (guesstimated a bit using
//     // preview...)
//     const double startX = 60;
//     const double startY = 430; // flutter starts counting from top left
//     const double dashSize = 5;
//     const double gapSize = 16;
//     canvas.drawPath(
//         dashPath(
//             Path()
//               // tell the path where to start
//               ..moveTo(startX, startY)
//               // the offset tells the arc where to end, the radius is the
//               // radius of the circle, and largeArc tells it to use the
//               // big part of the circle rather than the small one.
//               // The implied parameter `clockwise` means that it starts the arc
//               // and draw clockwise; setting this to false would result in a large
//               // arc below!
//               ..arcToPoint(Offset(520 - startX, startY),
//                   radius: Radius.circular(260), largeArc: true),
//             // dash is `dashSize` long followed by a gap `gapSize` long
//             dashArray: CircularIntervalList<double>([dashSize, gapSize]),
//             dashOffset: DashOffset.percentage(0.005)),
//         Paint()
//           ..color = Colors.black
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = dashSize);
//   }

//   @override
//   bool shouldRepaint(DashedArc oldDelegate) {
//     return oldDelegate.color != this.color;
//   }
// }

class SampleAnimation extends StatefulWidget {
  const SampleAnimation({super.key});

  @override
  State<StatefulWidget> createState() {
    return SampleAnimationState();
  }
}

class SampleAnimationState extends State<SampleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late Path _path;
  late Path _pathArcTo;

  int totalProgress = 201;

  int currentProgress = 100;
  double size = 11;

  double get percentCurrentProgress => currentProgress / totalProgress;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 5000));
    super.initState();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    // _controller.forward();
    _path = drawPath();
    _pathArcTo = drawRemainingProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade300,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            child: CustomPaint(
              painter: PathPainter(path: _path),
            ),
          ),
          Positioned(
            top: 0,
            child: CustomPaint(
              painter: PathPainter(path: _pathArcTo, color: Colors.white),
            ),
          ),
          Positioned(
            top: calculate(percentCurrentProgress).dy - size / 2,
            left: calculate(percentCurrentProgress).dx - size / 2,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          spreadRadius: size * 1.5,
                          blurRadius: size * 1.5,
                          offset:
                              const Offset(3, 3), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(size)),
                  width: size,
                  height: size,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Path drawPath() {
    Size size = const Size(300, 300);
    Path path = Path();
    path.moveTo(0, size.height);
    path.relativeQuadraticBezierTo(
        size.width / 1.5, -size.height / 3, size.width / 3, size.height / 3);
    return path;
  }

  Path drawRemainingProgress() {
    Path path = Path();
    path.moveTo(calculate(percentCurrentProgress).dx,
        calculate(percentCurrentProgress).dy);
    for (var i = percentCurrentProgress + 0.01; i < 1; i = i + 0.01) {
      path.lineTo(calculate(i).dx, calculate(i).dy);
    }

    return path;
  }

  Offset calculate(value) {
    PathMetrics pathMetrics = _path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent? pos = pathMetric.getTangentForOffset(value);
    return pos!.position;
  }
}

class PathPainter extends CustomPainter {
  final Path path;
  final Color color;

  PathPainter({required this.path, this.color = Colors.white24});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
