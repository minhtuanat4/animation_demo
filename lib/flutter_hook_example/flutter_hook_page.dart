// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';

// class FlutterHookExample extends HookWidget {
//   const FlutterHookExample({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final controller = useTextEditingController();
//     controller.addListener(() {});

//     return Scaffold(
//         appBar: AppBar(
//           title: Text('FlutterHookExample'),
//         ),
//         body: Center(
//           child: Column(
//             children: [
//               TextField(
//                 controller: controller,
//                 decoration: InputDecoration(
//                     hintText: 'Nhập số điện thoại',
//                     contentPadding: const EdgeInsets.all(0),
//                     border: OutlineInputBorder(
//                       borderSide:
//                           const BorderSide(width: 1, color: Colors.grey),
//                       borderRadius: BorderRadius.circular(5),
//                     )),
//                 textAlign: TextAlign.center,
//                 keyboardType: TextInputType.phone,
//                 onChanged: (value) {
//                   controller.text = value;
//                 },
//               ),
//             ],
//           ),
//         ));
//   }
// }

// class _TextEditingControllerHook extends Hook<TextEditingController> {
//   const _TextEditingControllerHook();

//   @override
//   _TextEditingControllerHookState createState() =>
//       _TextEditingControllerHookState();
// }

// class _TextEditingControllerHookState
//     extends HookState<TextEditingController, _TextEditingControllerHook> {
//   late TextEditingController controller;

//   @override
//   void initHook() {
//     super.initHook();
//     controller = TextEditingController();
//   }

//   @override
//   TextEditingController build(BuildContext context) {
//     return controller;
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
// }

// TextEditingController useTextEditingController() {
//   return use(_TextEditingControllerHookState() as Hook<TextEditingController>);
// }
