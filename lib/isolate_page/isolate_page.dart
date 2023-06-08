import 'dart:async';
import 'dart:isolate';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const PerformancePage(),
      ),
    );
  }
}

class PerformancePage extends StatefulWidget {
  final String title = "Isolates Demo";

  const PerformancePage({super.key});

  @override
  _PerformancePageState createState() => _PerformancePageState();
}

class _PerformancePageState extends State<PerformancePage> {
  //
  Isolate? _isolate;
  bool _running = false;
  bool _paused = false;
  String _message = '';
  String _threadStatus = '';
  ReceivePort? _receivePort;
  Capability? _capability;

  int count = 1;

  ValueNotifier valueListenable = ValueNotifier<int>(1);

  late String platformVersion = 'Unknown';

  Future<void> initPlatformState() async {
    Future.delayed(const Duration(seconds: 2), () {
      try {
        platformVersion = 'Dont metion it';
      } catch (e) {
        platformVersion = e.toString();
      }
      if (!mounted) return;
      setState(() {});
    });
  }

  void _start() async {
    if (_running) {
      return;
    }
    setState(() {
      _running = true;
      _message = 'Starting...';
      _threadStatus = 'Running...';
    });
    _receivePort = ReceivePort();
    ThreadParams threadParams = ThreadParams(2000, _receivePort!.sendPort);
    _isolate = await Isolate.spawn(
      _isolateHandler,
      threadParams,
    );
    _receivePort!.listen(_handleMessage, onDone: () {
      setState(() {
        _threadStatus = 'Stopped';
      });
    });
  }

  void _pause() {
    if (_isolate != null) {
      _paused
          ? _isolate!.resume(_capability!)
          : _capability = _isolate!.pause();
      setState(() {
        _paused = !_paused;
        _threadStatus = _paused ? 'Paused' : 'Resumed';
      });
    }
  }

  void _stop() {
    if (_isolate != null) {
      setState(() {
        _running = false;
      });
      _receivePort!.close();
      _isolate!.kill(priority: Isolate.immediate);
      _isolate = null;
    }
  }

  void _handleMessage(dynamic data) {
    setState(() {
      _message = data;
    });
  }

  static void _isolateHandler(ThreadParams threadParams) async {
    heavyOperation(threadParams);
  }

  static void heavyOperation(ThreadParams threadParams) async {
    int count = 10000;
    while (true) {
      int sum = 0;
      for (int i = 0; i < count; i++) {
        sum += await computeSum(1000);
      }
      count += threadParams.val;
      threadParams.sendPort.send(sum.toString());
    }
  }

  static Future<int> computeSum(int num) {
    Random random = Random();
    return Future(() {
      int sum = 0;
      for (int i = 0; i < num; i++) {
        sum += random.nextInt(100);
      }
      return sum;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            !_running
                ? OutlinedButton(
                    child: const Text('Start Isolate'),
                    onPressed: () {
                      _start();
                    },
                  )
                : const SizedBox(),
            _running
                ? OutlinedButton(
                    child: Text(_paused ? 'Resume Isolate' : 'Pause Isolate'),
                    onPressed: () {
                      _pause();
                    },
                  )
                : const SizedBox(),
            _running
                ? OutlinedButton(
                    child: const Text('Stop Isolate'),
                    onPressed: () {
                      _stop();
                    },
                  )
                : const SizedBox(),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              _threadStatus,
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              _message,
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.green,
              ),
            ),
            // initPlatformState();
            const SizedBox(
              height: 50,
            ),
            OutlinedButton(
              child: const Text('GetStatusBiometics'),
              onPressed: () {
                initPlatformState();
              },
            ),

            const SizedBox(
              height: 12,
            ),
            Text(
              platformVersion,
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.green,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            OutlinedButton(
              child: const Text('Plus 1'),
              onPressed: () {
                valueListenable.value = valueListenable.value + 1;
              },
            ),
            ValueListenableBuilder(
              valueListenable: valueListenable,
              builder: (context, value, child) {
                return Text(
                  value.toString(),
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.green,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class ThreadParams {
  ThreadParams(this.val, this.sendPort);
  int val;
  SendPort sendPort;
}
