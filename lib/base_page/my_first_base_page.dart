import 'dart:async';

import 'package:flutter/material.dart';

abstract class BaseBloc {
  /// relays error information
  final StreamController<bool> _readyToDisplayTilesController =
      StreamController<bool>.broadcast();

  Function get setReadyToDisplayTiles =>
      _readyToDisplayTilesController.sink.add;
  Stream<bool> get outReadyToDisplayTiles =>
      _readyToDisplayTilesController.stream;
}

abstract class BasePage extends StatefulWidget {
  const BasePage({super.key});
}

abstract class BaseState<Page extends BasePage> extends State<Page>
    with MoreOption {
  @override
  void initState() {
    print('Initial BasePage');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: body(),
    );
  }

  @override
  void dispose() {
    print('Dispose BasePage');
    super.dispose();
  }

  PreferredSizeWidget? appBar();

  Widget body();
}

mixin MoreOption {
  void printSomething(String value) {
    print('This is message for you: ' + value);
  }
}

class MyFirstBasePage extends BasePage {
  const MyFirstBasePage({super.key});

  @override
  State<MyFirstBasePage> createState() => _MyFirstScreenState();
}

class _MyFirstScreenState extends BaseState<MyFirstBasePage> {
  @override
  void initState() {
    print('Initial MyFirstScreen');
    super.initState();
  }

  @override
  void dispose() {
    print('Dispose MyFirstScreen');
    super.dispose();
  }

  @override
  PreferredSizeWidget? appBar() {
    return null;

    // return AppBar(
    //   // backgroundColor: Colors.pinkAccent.shade100,
    //   shadowColor: Colors.red,
    //   surfaceTintColor: Colors.red,
    // );
  }

  @override
  Widget body() {
    printSomething('MyFirstScreen');
    return Container(
      padding: EdgeInsets.only(top: 0),
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue.shade400,
                    Colors.white,
                  ],
                  stops: const [
                    0.0,
                    0.2,
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(12.0),
                  margin:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back_ios),
                      Expanded(
                        child: Text(
                          'MyFirstScreen',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.amber, fontSize: 18),
                        ),
                      ),
                      Icon(Icons.close)
                    ],
                  ),
                ),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Column(
                              children: [
                                Container(
                                  color: Colors.green.shade100,
                                  height: 20,
                                  child: Center(
                                    child: Text(
                                      '',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.amber, fontSize: 30),
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Colors.black,
                                  height: 0,
                                  thickness: 0.1,
                                ),
                              ],
                            );
                          },
                          childCount: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    // return ListView(
    //   children: [
    //     Container(
    //       height: 200,
    //       color: Colors.amber,
    //       child: Center(
    //         child: Text(
    //           'MyFirstScreen',
    //           textAlign: TextAlign.center,
    //           style: TextStyle(color: Colors.amber, fontSize: 30),
    //         ),
    //       ),
    //     ),
    //     SizedBox(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Text(
    //             'MyFirstScreen',
    //             textAlign: TextAlign.center,
    //             style: TextStyle(color: Colors.amber, fontSize: 30),
    //           )
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }
}

class ListHeader extends StatelessWidget {
  const ListHeader({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Material(
        color: colorScheme.primaryContainer,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(8),
        //   side: BorderSide(width: 7, color: colorScheme.outline),
        // ),
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge!
                .copyWith(color: colorScheme.onPrimaryContainer),
          ),
        ),
      ),
    );
  }
}
