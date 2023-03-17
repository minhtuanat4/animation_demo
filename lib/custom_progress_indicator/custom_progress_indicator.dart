import 'package:animation_demo/custom_progress_indicator/lib_progress_indicator.dart';
import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatefulWidget {
  const CustomProgressIndicator({super.key});

  @override
  State<CustomProgressIndicator> createState() =>
      _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Custom Progress Indicator'),
        ),
        body: Row(
          children: [
            const Text('LibProgressIndicator '),
            Expanded(
              child: LibProgressIndicator(
                onChanged: (value) {},
              ),
            ),
          ],
        ));
  }
}
