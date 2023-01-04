// import 'package:flutter/material.dart';
// import 'package:flutter_social_content_share/flutter_social_content_share.dart';

// class ShareFacebookDemo extends StatefulWidget {
//   const ShareFacebookDemo({Key? key}) : super(key: key);

//   @override
//   State<ShareFacebookDemo> createState() => _ShareFacebookDemoState();
// }

// class _ShareFacebookDemoState extends State<ShareFacebookDemo> {
//   String resultShareFace = 'Nothing';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('ShareFacebookDemo')),
//       body: SizedBox.expand(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 resultShareFace = await FlutterSocialContentShare.share(
//                         imageName:
//                             'assets/images/roll_paper_roll/background.jpg',
//                         imageUrl:
//                             "https://www.google.com/url?sa=i&url=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FImage&psig=AOvVaw1olPx5bk4PlUWG1Syzxo9T&ust=1670229819100000&source=images&cd=vfe&ved=0CA8QjRxqFwoTCLCe-InJ3_sCFQAAAAAdAAAAABAE",
//                         type: ShareType.facebookWithoutImage,
//                         url: "https://www.apple.com",
//                         quote: "captions") ??
//                     'Nothing';

//                 setState(() {});
//               },
//               style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
//               child: const Text('Share Facebook'),
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             Text('ShareFacebook: $resultShareFace\n'),
//           ],
//         ),
//       ),
//     );
//   }
// }
