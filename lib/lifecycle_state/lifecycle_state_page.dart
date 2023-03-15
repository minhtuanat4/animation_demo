import 'dart:async';

import 'package:flutter/material.dart';

class LifecyleStatePage extends StatefulWidget {
  final String id;
  final String name;
  const LifecyleStatePage({Key? key, required this.id, required this.name})
      : super(key: key);

  @override
  State<LifecyleStatePage> createState() => _LifecyleStatePageState();
}

class _LifecyleStatePageState extends State<LifecyleStatePage>
    with WidgetsBindingObserver {
  String stateLifecylce = '';

  int _start = const Duration(seconds: 5).inSeconds;
  late Timer _timerFirstObject;
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    _timerFirstObject = Timer(
      const Duration(seconds: 4),
      () {
        print('Ontick NOT provider.isClicked ');
        // removeFirstItemSelected(firstObject);
      },
    );
    super.initState();
  }

  void _startTime(Timer? timer) {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (timer) {
      _start--;
    });
  }

  void _initTime(Timer? timer) {
    _start = const Duration(seconds: 5).inSeconds;
    if (timer != null) {
      timer.cancel();
    }
  }

  void _toDoTimerTimeout() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SizedBox.expand(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('ID ${widget.id}'),
          const SizedBox(height: 24),
          Text('Name ${widget.name}'),
          const SizedBox(height: 24),
          GestureDetector(
              onTap: () {
                print('Cancel _timerFirstObject');
                _timerFirstObject.cancel();
              },
              child: const Text('Lifecycles State Flutter')),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {},
            child: Text(
              stateLifecylce,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.red,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    Timer? _timer;
    print('Lifecyles State Flutter :::: $state');
    if (state == AppLifecycleState.paused) {
      stateLifecylce = 'Lifecycle is Paused';
      _startTime(_timer);
    } else if (state == AppLifecycleState.resumed) {
      stateLifecylce = 'Lifecycle is Resumed';

      if (_start > const Duration(seconds: 0).inSeconds) {
        // Let user continue using app
        print('AppLifecycle timer didnt complete');
      } else {
        print('AppLifecycle timer timeout');
        if (mounted) {
          _toDoTimerTimeout();
        }
      }
      _initTime(_timer);
    }

    super.didChangeAppLifecycleState(state);
  }
}
