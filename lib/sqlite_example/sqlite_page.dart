// import 'dart:math';

// import 'package:animation_demo/common/user_management.dart';
// import 'package:animation_demo/custom_package/home_packages.dart';
// import 'package:animation_demo/sqlite_example/model/udpate_email_model.dart';
// import 'package:animation_demo/sqlite_example/sqlite_hepler.dart';
// import 'package:flutter/material.dart';

// class SqlitePage extends StatefulWidget {
//   const SqlitePage({super.key});

//   @override
//   State<SqlitePage> createState() => _SqlitePageState();
// }

// class _SqlitePageState extends State<SqlitePage> {
//   // List<UpdateEmailRequest> _list = [];
//   final notifyList = ValueNotifier<List<UpdateEmailRequest>>([]);
//   final rd = Random();
//   int countID = 0;

//   @override
//   void initState() {
//     getCurrentID();
//     super.initState();
//   }

//   Future<void> getCurrentID() async {
//     countID = await UserManagement().getCurrentID() ?? 0;
//   }

//   UpdateEmailRequest getRandomItem() {
//     final numberRandom = rd.nextInt(1000) + 1;
//     final item = UpdateEmailRequest(
//         columnId: countID,
//         email: 'email$numberRandom@gmail.com',
//         secureCode: 'code $numberRandom',
//         secureTypeId: numberRandom);
//     countID++;
//     return item;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sqflite Page'),
//       ),
//       body: Column(children: [
//         // OptionButton(
//         //   label: 'Get New for ID',
//         //   kVertical: 0,
//         //   onPressed: () {
//         //     NewsProvider().getNews(rd.nextInt(countID) + 1);
//         //   },
//         // ),
//         OptionButton(
//           label: 'Get News For PageNumber and CountItems',
//           kVertical: 0,
//           onPressed: () async {
//             final list = await NewsProvider().getNewsFollowingPage(1, 10);
//             notifyList.value = list ?? [];
//           },
//         ),
//         OptionButton(
//           label: 'Insert New',
//           kVertical: 0,
//           onPressed: () async {
//             final item = getRandomItem();
//             await NewsProvider().insertNews(item);
//             UserManagement().setCurrentID(data: countID);
//           },
//         ),
//         OptionButton(
//           kVertical: 0,
//           label: 'Delete New',
//           onPressed: () {
//             NewsProvider().delete(rd.nextInt(countID) + 1);
//           },
//         ),
//         OptionButton(
//           kVertical: 0,
//           label: 'Delete All Data',
//           onPressed: () async {
//             NewsProvider().deleteAllData();
//             final list = await NewsProvider().getNewsFollowingPage(1, 10);
//             notifyList.value = list ?? [];
//           },
//         ),
//         Expanded(
//           child: ValueListenableBuilder<List<UpdateEmailRequest>>(
//             valueListenable: notifyList,
//             builder: (context, list, _) {
//               return ListView.separated(
//                 itemBuilder: (context, index) {
//                   final item = list[index];
//                   return ListTile(
//                     leading: const Icon(Icons.headphones),
//                     title: Text('ID : ${item.columnId ?? 0}'),
//                     subtitle: Text('Email: ${item.email ?? ''}'),
//                     trailing: InkWell(
//                         onTap: () async {
//                           final id = item.columnId;
//                           if (id != null) {
//                             final idResult = await NewsProvider().delete(id);
//                             if (idResult != null) {
//                               final valueList = List<UpdateEmailRequest>.from(
//                                   notifyList.value);
//                               valueList.removeWhere(
//                                   (element) => element.columnId == id);
//                               notifyList.value = valueList;
//                             }
//                           }
//                         },
//                         child: const Icon(Icons.delete)),
//                   );
//                 },
//                 separatorBuilder: (context, index) {
//                   return const Divider(
//                     thickness: 0.8,
//                   );
//                 },
//                 itemCount: list.length,
//               );
//             },
//           ),
//         )
//       ]),
//     );
//   }
// }
