// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vtc_pay/blocs/account_info_bloc/account_info_bloc.dart';
// import 'package:vtc_pay/blocs/pay_bloc/pay_state.dart';
// import 'package:vtc_pay/models/account/accountinfo_model.dart';
// import 'package:vtc_pay/resource/definition_color.dart';
// import 'package:vtc_pay/resource/definition_icon.dart';
// import 'package:vtc_pay/ui/widgets/_base/vtc_stateful_page.dart';
// import 'package:vtc_pay/ui/widgets/buttons/vtc_button.dart';
// import 'package:vtc_pay/ui/widgets/library/my_checkbox.dart';
// import 'package:vtc_pay/ui/widgets/mixin/vtc_basic_page.dart';

// class AccountInfoDetailPage extends VTCStatefulPage {
//   final AccountInfoModel accountInfoModel;
//   final bool notCallApiAccountDetail;

//   const AccountInfoDetailPage({
//     required this.accountInfoModel,
//     required this.notCallApiAccountDetail,
//     Key? key,
//   }) : super(key: key);

//   @override
//   _AccountInfoDetailPageState createState() => _AccountInfoDetailPageState();
// }

// class _AccountInfoDetailPageState
//     extends VTCStatefulPageState<AccountInfoDetailPage> with VTCBasicPage {
//   @override
//   String screenName() {
//     return 'AccountInfoDetailPage';
//   }

//   final statusMethodLst = <bool>[true, false];

//   final rebuildNeededWidget = ValueNotifier<bool>(false);

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget appBar(BuildContext context) {
//     return appBarCustom(
//       isEnableCloseButton: true,
//       title: 'Thông tin tài khoản',
//     );
//   }

//   @override
//   Widget body(BuildContext context) {
//     return BlocConsumer<AccountInfoBloc, PayState>(
//       listener: (ltcontext, state) async {},
//       builder: (bdcontext, state) {
//         return Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
//                   child: Column(
//                     children: [
//                       const SizedBox(
//                         height: 32,
//                       ),
//                       const Text(
//                           'Chọn một trong các cách xác thực dưới đây để đăng nhập'),
//                       const SizedBox(
//                         height: 24,
//                       ),
//                       ValueListenableBuilder(
//                         valueListenable: rebuildNeededWidget,
//                         builder: (context, value, child) {
//                           return Column(
//                             children: [
//                               itemRowWidget(
//                                 'Xác thực khuôn mặt',
//                                 statusMethodLst[0],
//                                 0,
//                               ),
//                               const SizedBox(
//                                 height: 24,
//                               ),
//                               itemRowWidget(
//                                 'Nhập OTP từ tổng đài VTC Pay',
//                                 statusMethodLst[1],
//                                 1,
//                               )
//                             ],
//                           );
//                         },
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
//               child: VTCButton(
//                 onPressed: () {
//                   if (statusMethodLst[0]) {
//                     /// TODO: Liveness
//                   } else if (statusMethodLst[1]) {
//                     /// TODO: OTP
//                   }
//                 },
//                 buttonType: VTCButtonType.roundRectangeButton,
//                 text: 'Xác nhận',
//                 width: double.infinity,
//                 borderSideColor: Colors.transparent,
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget itemRowWidget(String title, bool isSelected, int index) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//       decoration: BoxDecoration(
//           border: Border.all(
//             width: 1,
//             color: isSelected ? colorPayBlue900 : colorGrey,
//           ),
//           borderRadius: const BorderRadius.all(
//             Radius.circular(8),
//           )),
//       child: Row(
//         children: [
//           const Image(
//             image: AssetImage(iconSmallFaceIdLogin),
//           ),
//           const SizedBox(
//             width: 12,
//           ),
//           Expanded(
//             child: Text(title),
//           ),
//           const SizedBox(
//             width: 8,
//           ),
//           RoundCheckBox(
//             onTap: (value) {
//               if (value != null) {
//                 statusMethodLst.setAll(0, [false, false]);
//                 statusMethodLst[index] = value;
//                 rebuildNeededWidget.value = !rebuildNeededWidget.value;
//               }
//             },
//             isChecked: isSelected,
//             checkedColor: Colors.transparent,
//             checkedWidget: const Padding(
//               padding: EdgeInsets.all(1),
//               child: FittedBox(
//                 child: Icon(
//                   Icons.circle,
//                   color: colorPayBlue900,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
