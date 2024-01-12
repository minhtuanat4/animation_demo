import 'package:after_layout/after_layout.dart';
import 'package:animation_demo/getx_demo/common/vtc_basic_page.dart';
import 'package:animation_demo/getx_demo/router/route_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroPage2 extends VtcBasicPage<GetxController> {
  const IntroPage2({super.key});

  @override
  AppBar? appBarCustom(BuildContext context) {
    return null;
  }

  @override
  Widget? body(BuildContext context) {
    return Center(
        child: Container(
      width: double.infinity,
      color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Home Page'),
          GestureDetector(
              onTap: () {
                Get.offAllNamed(RoutePaths.mainHomePage);
              },
              child: const Text('secondPage'))
        ],
      ),
    ));
  }
}

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);
  @override
  _IntroPage createState() => _IntroPage();
}

class _IntroPage extends State<IntroPage>
    with TickerProviderStateMixin, AfterLayoutMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late AnimationController _controller4;
  late AnimationController _controller5;
  late Animation<Size> _sizeAnimation1;
  late Animation<Size> _sizeAnimation2;
  late Animation<Size> _sizeAnimation3;
  late Animation<Size> _sizeAnimation4;
  late Animation<Size> _sizeAnimation5;
  final double widthPiston = 50;
  final double heightPiston = 200;

  Future checkFirstSeen() async {
    Future.delayed(const Duration(seconds: 2), () async {
      Get.offAllNamed(RoutePaths.mainHomePage);
    });
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();
  @override
  void initState() {
    _controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..addListener(() {
        if (!_controller1.isAnimating) {
          if (_controller1.isCompleted) {
            _controller1.reverse();
          } else {
            _controller1.forward();
          }
        }
      })
      ..forward();
    _controller2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..addListener(() {
        if (!_controller2.isAnimating) {
          if (_controller2.isCompleted) {
            _controller2.reverse();
          } else {
            _controller2.forward();
          }
        }
      })
      ..forward();
    _controller3 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..addListener(() {
        if (!_controller3.isAnimating) {
          if (_controller3.isCompleted) {
            _controller3.reverse();
          } else {
            _controller3.forward();
          }
        }
      })
      ..forward();
    _controller4 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..addListener(() {
        if (!_controller4.isAnimating) {
          if (_controller4.isCompleted) {
            _controller4.reverse();
          } else {
            _controller4.forward();
          }
        }
      })
      ..forward();
    _controller5 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..addListener(() {
        if (!_controller5.isAnimating) {
          if (_controller5.isCompleted) {
            _controller5.reverse();
          } else {
            _controller5.forward();
          }
        }
      })
      ..forward();
    _sizeAnimation1 =
        Tween<Size>(begin: Size(50, heightPiston), end: const Size(50, 50))
            .animate(_controller1);
    _sizeAnimation2 =
        Tween<Size>(begin: Size(70, heightPiston), end: const Size(70, 50))
            .animate(_controller2);
    _sizeAnimation3 =
        Tween<Size>(begin: Size(30, heightPiston), end: const Size(30, 50))
            .animate(_controller3);
    _sizeAnimation4 =
        Tween<Size>(begin: const Size(50, 50), end: Size(50, heightPiston + 20))
            .animate(_controller4);
    _sizeAnimation5 =
        Tween<Size>(begin: const Size(70, 50), end: Size(70, heightPiston + 20))
            .animate(_controller5);
    super.initState();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).size.height / 2 - 50;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: -30,
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(45 / 360),
              alignment: Alignment.bottomCenter,
              child: AnimatedBuilder(
                animation: _controller1.view,
                builder: (context, child) {
                  return Container(
                    // color: Colors.pink.shade200,
                    width: _sizeAnimation1.value.width,
                    height: _sizeAnimation1.value.height,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/intro/Rectangle5.png'),
                            fit: BoxFit.fill)),
                    // child: child,
                    // child: child,
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: 0,
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(45 / 360),
              alignment: Alignment.bottomCenter,
              child: AnimatedBuilder(
                animation: _controller2.view,
                builder: (context, child) {
                  return Container(
                    // color: Colors.blue.shade600,
                    width: _sizeAnimation2.value.width,
                    height: _sizeAnimation2.value.height,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/images/intro/Rectangle3.png'),
                      fit: BoxFit.fill,
                    )),
                    // child: child,
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(45 / 360),
              alignment: Alignment.bottomCenter,
              child: AnimatedBuilder(
                animation: _controller3.view,
                builder: (context, child) {
                  return Container(
                    // color: Colors.deepPurple.shade200,
                    width: _sizeAnimation3.value.width,
                    height: _sizeAnimation3.value.height,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/images/intro/Rectangle4.png'),
                      fit: BoxFit.fill,
                    )),
                    // child: child,
                  );
                },
              ),
            ),
          ),
          //-----------//
          Positioned(
            top: -20,
            right: -80,
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(45 / 360),
              alignment: Alignment.topCenter,
              child: AnimatedBuilder(
                animation: _controller4.view,
                builder: (context, child) {
                  return Container(
                    // color: Colors.pink.shade200,
                    width: _sizeAnimation4.value.width,
                    height: _sizeAnimation4.value.height,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/images/intro/Rectangle5.png'),
                      fit: BoxFit.fill,
                    )),
                    // child: child,
                  );
                },
              ),
            ),
          ),

          Positioned(
            top: -30,
            right: -30,
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(45 / 360),
              alignment: Alignment.topCenter,
              child: AnimatedBuilder(
                animation: _controller5.view,
                builder: (context, child) {
                  return Container(
                    // color: Colors.blue.shade600,
                    width: _sizeAnimation5.value.width,
                    height: _sizeAnimation5.value.height,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/images/intro/Rectangle5.png'),
                      fit: BoxFit.fill,
                    )),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: -10,
            right: -20,
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(45 / 360),
              alignment: Alignment.topCenter,
              child: AnimatedBuilder(
                animation: _controller3.view,
                builder: (context, child) {
                  return Container(
                    alignment: Alignment.topLeft,
                    // color: Colors.deepPurple.shade200,
                    width: _sizeAnimation3.value.width,
                    height: _sizeAnimation3.value.height,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/images/intro/Rectangle4.png'),
                      fit: BoxFit.fill,
                    )),
                  );
                },
              ),
            ),
          ),

          Positioned(
            bottom: bottom + 50,
            left: (MediaQuery.of(context).size.width - 200) / 2,
            child: Container(
                width: 200,
                height: 100,
                child: AnimatedBuilder(
                    animation: _controller2.view,
                    builder: (context, child) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        child: Image.asset('assets/images/logo.png'),
                      );
                    })),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Container(
          //     color: Colors.white,
          //     width: MediaQuery.of(context).size.width,
          //     height: 50,
          //   ),
          // ),
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: Container(
          //     color: Colors.white,
          //     width: MediaQuery.of(context).size.width,
          //     height: 50,
          //   ),
          // ),
        ],
      ),
    );
  }
}
