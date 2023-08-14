import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:scan/scan.dart';

import '../popup_common.dart';
import '../utils.dart';

class ScanImageQRPage extends StatefulWidget {
  const ScanImageQRPage({super.key});

  @override
  State<ScanImageQRPage> createState() => _ScanImageQRPageState();
}

class _ScanImageQRPageState extends State<ScanImageQRPage> {
  String qrcode = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Column(
        children: [
          Wrap(
            children: [
              // ElevatedButton(
              //   child: const Text("parse from image"),
              //   onPressed: () async {
              //     final status = await Utils.checkPermission(Permission.photos);
              //     if (status.isGranted) {
              //       final res = await ImagePicker().pickImage(
              //           source: ImageSource.gallery, imageQuality: 80);
              //       if (res != null) {
              //         String? str = await Scan.parse(res.path);
              //         if (str != null) {
              //           setState(() {
              //             qrcode = str;
              //           });
              //         }
              //       }
              //     } else {
              //       // ignore: use_build_context_synchronously
              //       await (showAlertDialog(
              //           finalContext: context,
              //           title: 'Thông báo',
              //           message: 'Failed Permission'));
              //     }
              //   },
              // ),
              ElevatedButton(
                child: const Text('go scan page'),
                onPressed: () {},
              ),
            ],
          ),
          Text('scan result is $qrcode'),
        ],
      ),
    );
  }
}
