// import 'package:flutter/material.dart';
// import 'package:vtc_pay/resource/definition_color.dart';

// import 'package:vtc_pay/resource/definition_icon.dart';
// import 'package:vtc_pay/ui/widgets/buttons/vtc_button.dart';

// class MissionEventState extends StatelessWidget {
//   const MissionEventState({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Divider(
//             thickness: 4,
//             color: colorPayBG,
//           ),
//           const Text(
//             'Yayy! Bạn đã đủ điều kiện nhận',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(
//             height: 4,
//           ),
//           SizedBox(
//             height: 60,
//             child: Card(
//               shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(8))),
//               elevation: 3,
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const FittedBox(
//                       child: Image(
//                         image: AssetImage(iconVTCPay),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 12,
//                     ),
//                     Flexible(
//                       child: FittedBox(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: const [
//                             Text('2 Lượt Chơi',
//                                 style: TextStyle(
//                                     color: colorPayBlack,
//                                     fontWeight: FontWeight.bold)),
//                             Text('Nông trại kẹo',
//                                 style: TextStyle(
//                                   color: colorGrey,
//                                 )),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 24,
//                     ),
//                     VTCButton(
//                       buttonType: VTCButtonType.roundRectangeButton,
//                       heightborderRadius: 12,
//                       onPressed: () {},
//                       backgroundColor: Colors.transparent,
//                       borderSideColor: Colors.grey,
//                       height: 24,
//                       child: const Padding(
//                         padding: EdgeInsets.only(bottom: 3),
//                         child: Text(
//                           'Chơi ngay',
//                           style: TextStyle(
//                               color: colorPayBlack,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 24,
//           )
//         ],
//       ),
//     );
//   }
// }
