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
    return AppBar(
      title: Text('MyFirstBasePage'),
    );
  }

  @override
  Widget body() {
    printSomething('MyFirstScreen');
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'MyFirstScreen',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.amber, fontSize: 30),
          )
        ],
      ),
    );
  }
}
