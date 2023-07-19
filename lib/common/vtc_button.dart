import 'package:flutter/material.dart';

enum ButtonType { blockButton, primaryButton, outlinedButton }

class ButtonFactory extends StatelessWidget {
  const ButtonFactory({
    Key? key,
    required this.color,
    required this.type,
    required this.text,
    required this.onTap,
  }) : super(key: key);
  final Color color;
  final ButtonType type;
  final String text;
  final Function onTap;
  factory ButtonFactory.fromPolicyType({
    required Function() onTap,
    required ButtonType type,
  }) {
    if (type.name == ButtonType.outlinedButton.name) {
      return ButtonFactory(
        text: 'Block button',
        onTap: onTap,
        color: Colors.red,
        type: type,
      );
    }
    if (type.name == ButtonType.outlinedButton.name) {
      return ButtonFactory(
        text: 'Outlined button',
        onTap: onTap,
        color: Colors.yellow,
        type: type,
      );
    }
    return ButtonFactory(
      text: 'Primary button',
      onTap: onTap,
      color: Colors.green,
      type: type,
    );
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 180,
        margin: EdgeInsets.only(bottom: 12),
        child: ElevatedButton(onPressed: () {}, child: Text(text)),
      ),
    );
  }
}
// class Student {
//   const Student(
//     this.name,
//     this.rollNo,
//   );

//   final String name;
//   final String rollNo;

//   @override
//   int get hashCode => Object.hash(name.hashCode, rollNo.hashCode);

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is Student &&
//           runtimeType == other.runtimeType &&
//           this.hashCode == other.hashCode;
// }