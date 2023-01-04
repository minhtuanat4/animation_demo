import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'check_box_custom.dart';

class CheckBoxHome extends StatefulWidget {
  const CheckBoxHome({Key? key}) : super(key: key);

  @override
  State<CheckBoxHome> createState() => _CheckBoxHomeState();
}

class _CheckBoxHomeState extends State<CheckBoxHome> {
  bool isChecked = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CheckBox Custom')),
      body: SizedBox.expand(
        child: CheckBoxFormField(
          isChecked: isChecked,
          label: const Text('Please mark in square box'),
          onChanged: (bool? value) {
            isChecked = value!;
            setState(() {});
          },
        ),
      ),
    );
  }
}
