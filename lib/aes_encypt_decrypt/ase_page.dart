// import 'package:encrypt/encrypt.dart' as ecpt;

import 'package:flutter/material.dart';

class AESPage extends StatelessWidget {
  const AESPage({super.key});
  // ecpt.Encrypter? encrypter;
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  // void encryptFunc() {
  //     final key = ecpt.Key.fromUtf8(enkey);
  //   final iv = ecpt.IV.fromUtf8(envect);
  //  final encrypter ??= ecpt.Encrypter(ecpt.AES(key, mode: ecpt.AESMode.cbc));
  //   final encryptData = otpAppDataToMap(lstOtpAppData);
  //   final encryptedData = encrypter!.encrypt(encryptData, iv: iv).base64;
  // }

  // void decryptFunc() {
  //        final key = ecpt.Key.fromUtf8(enkey);
  //     final iv = ecpt.IV.fromUtf8(envect);
  //     final encrypter = ecpt.Encrypter(ecpt.AES(key, mode: ecpt.AESMode.cbc));
  //     final resultData = encrypter.decrypt64(otpAppData, iv: iv);
  // }
}
