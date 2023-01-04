import 'package:flutter/material.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';

class TooltipDemo extends StatefulWidget {
  const TooltipDemo({Key? key}) : super(key: key);

  @override
  _TooltipDemoState createState() => _TooltipDemoState();
}

class _TooltipDemoState extends State<TooltipDemo> {
  final TooltipController _controller = TooltipController();
  bool done = false;

  @override
  void initState() {
    _controller.onDone(() {
      setState(() {
        done = true;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: OverlayTooltipScaffold(
        // overlayColor: Colors.red.withOpacity(.4),
        tooltipAnimationCurve: Curves.linear,
        tooltipAnimationDuration: const Duration(milliseconds: 1000),
        controller: _controller,
        startWhen: (initializedWidgetLength) async {
          await Future.delayed(const Duration(milliseconds: 500));
          return initializedWidgetLength == 3 && !done;
        },
        builder: (context) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: 70,
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              OverlayTooltipItem(
                displayIndex: 1,
                tooltip: (controller) => Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: MTooltip(title: 'Button', controller: controller),
                ),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        gradient: const LinearGradient(
                            colors: [Colors.orange, Colors.deepOrange])),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    alignment: Alignment.center,
                  ),
                ),
              )
            ],
          ),
          floatingActionButton: OverlayTooltipItem(
            displayIndex: 2,
            tooltip: (controller) => Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: MTooltip(title: 'Floating button', controller: controller),
            ),
            tooltipVerticalPosition: TooltipVerticalPosition.TOP,
            child: FloatingActionButton(
              backgroundColor: Colors.purple,
              onPressed: () {
                _controller.start(2);
                OverlayTooltipScaffold.of(context)?.controller.start(2);
              },
              child: const Icon(Icons.message),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    ...[
                      _sampleWidget(),
                      OverlayTooltipItem(
                          displayIndex: 0,
                          tooltip: (controller) => Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: MTooltip(
                                    title: 'Text Tile', controller: controller),
                              ),
                          child: _sampleWidget()),
                      _sampleWidget(),
                    ],
                    TextButton(
                        onPressed: () {
                          setState(() {
                            done = false;
                          });
                        },
                        child: const Text('reset Tooltip')),
                    TextButton(
                        onPressed: () {
                          _controller.start();
                          OverlayTooltipScaffold.of(context)
                              ?.controller
                              .start();
                        },
                        child: const Text('Start Tooltip manually')),
                    TextButton(
                        onPressed: () {
                          _controller.start(1);
                          OverlayTooltipScaffold.of(context)
                              ?.controller
                              .start(1);
                        },
                        child: const Text('Start at second item')),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OverlayTooltipItem(
                    displayIndex: 3,
                    tooltipVerticalPosition: TooltipVerticalPosition.TOP,
                    tooltipHorizontalPosition: TooltipHorizontalPosition.CENTER,
                    tooltip: (controller) => Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: MTooltip(
                          title: 'Xem lại lịch sử lượt chơi của bạn tại đây',
                          controller: controller),
                    ),
                    child: TextButton(
                        onPressed: () {
                          _controller.start(3);
                          OverlayTooltipScaffold.of(context)
                              ?.controller
                              .start(3);
                        },
                        child: const Text('Button1')),
                  ),
                  OverlayTooltipItem(
                    displayIndex: 4,
                    tooltipVerticalPosition: TooltipVerticalPosition.TOP,
                    tooltipHorizontalPosition: TooltipHorizontalPosition.CENTER,
                    tooltip: (controller) => Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: MTooltip(
                          title:
                              'Xem danh sách nhiệm vụ tại đây. Hãy chia sẻ ngay để lấy 1 lượt chơi nhé!',
                          controller: controller),
                    ),
                    child: TextButton(
                        onPressed: () {
                          _controller.start(4);
                          OverlayTooltipScaffold.of(context)
                              ?.controller
                              .start(4);
                        },
                        child: const Text('Button2')),
                  ),
                  OverlayTooltipItem(
                    displayIndex: 5,
                    tooltipVerticalPosition: TooltipVerticalPosition.TOP,
                    tooltipHorizontalPosition: TooltipHorizontalPosition.CENTER,
                    tooltip: (controller) => Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: MTooltip(
                          title:
                              'Nếu muốn share Facebook, hãy click vào đây nhé!',
                          controller: controller),
                    ),
                    child: TextButton(
                        onPressed: () {
                          _controller.start(5);
                          OverlayTooltipScaffold.of(context)
                              ?.controller
                              .start(5);
                        },
                        child: const Text('Button3')),
                  ),
                  OverlayTooltipItem(
                    displayIndex: 6,
                    tooltipVerticalPosition: TooltipVerticalPosition.TOP,
                    tooltipHorizontalPosition:
                        TooltipHorizontalPosition.WITH_WIDGET,
                    tooltip: (controller) => Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: MTooltip(
                          title: 'Hãy nhấn vào đây để chơi game nhé!',
                          controller: controller),
                    ),
                    child: TextButton(
                        onPressed: () {
                          _controller.start(6);
                          OverlayTooltipScaffold.of(context)
                              ?.controller
                              .start(6);
                        },
                        child: const Text('Button4')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sampleWidget() => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.withOpacity(.5),
            ),
            borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lorem Ipsum is simply dummy text of the printing and'
                'industry. Lorem Ipsum has been the industry\'s'
                'standard dummy text ever since the 1500s'),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Icon(Icons.bookmark_border),
                Icon(Icons.delete_outline_sharp)
              ],
            )
          ],
        ),
      );
}

class MTooltip extends StatelessWidget {
  final TooltipController controller;
  final String title;
  const MTooltip({Key? key, required this.controller, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Colors.black54,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Be Vietnam',
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
      ),
      // child: Stack(
      //   alignment: Alignment.center,
      //   children: [
      //     SizedBox(
      //         width: size.width * 0.7,
      //         height: size.height * 0.7,
      //         child: Image.asset(
      //           'assets/images/roll_paper_roll/background.jpg',
      //           fit: BoxFit.contain,
      //         )),
      //     GestureDetector(
      //       onTap: () {
      //         controller.dismiss();
      //       },
      //       child: Align(
      //         alignment: Alignment.bottomCenter,
      //         child: Padding(
      //           padding: const EdgeInsets.all(12.0),
      //           child: Text(
      //             title,
      //             style: TextStyle(
      //               fontSize: 20,
      //               fontFamily: 'Be Vietnam',
      //               color: Colors.white,
      //             ),
      //             textAlign: TextAlign.center,
      //             softWrap: true,
      //           ),
      //         ),
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}
