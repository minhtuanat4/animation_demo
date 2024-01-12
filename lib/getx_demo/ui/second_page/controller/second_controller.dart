import 'dart:math';

import 'package:animation_demo/getx_demo/common/custom/epos_popup.dart';
import 'package:animation_demo/getx_demo/controller/call_back_verify_code_ctrol.dart';
import 'package:animation_demo/getx_demo/ui/second_page/funcs/call_telco_prepaid.dart';
import 'package:animation_demo/getx_demo/ui/second_page/model/telco_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecondPageBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerSecondPage());
    Get.lazyPut(() => CallBackVerifyCodeCtrol(), tag: 'SecondPageBind');
  }
}

class User {
  User({this.name = 'Name', this.age = 0});
  String name;
  int age;
}

class ControllerSecondPage extends GetxController
    with GetTickerProviderStateMixin, EposPopup {
  late AnimationController ctroler;
  late Animation<double> ani;

  int count = 0;

  late AnimationController ctrolerSecond;
  late Animation<double> aniSecond;
  late FuncSecondPgae service;

  TelCoModel? _telCoModel;

  TelCoModel? get telCoModel => _telCoModel;

  set telCoModel(TelCoModel? value) {
    _telCoModel = value;
    update();
  }

  int a = 0;
  final callback = Get.find<CallBackVerifyCodeCtrol>(tag: 'SecondPageBind');
  @override
  void onInit() {
    count = 5;
    service = FuncSecondPgae(this);
    ctroler = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    ani = Tween<double>(begin: 1, end: 1.3).animate(ctroler)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          ctroler.reverse();
        }
      });
    ctrolerSecond = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    aniSecond = Tween<double>(begin: 0, end: pi * 2).animate(ctrolerSecond)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          ctrolerSecond.reverse();
        }
      });
    super.onInit();
  }

  @override
  void onReady() {
    service.callTelcoPrepaid();

    callback.isCallBackVerifyCode.listen((val) {
      service.callTelcoPrepaid(isCallback: true);
      print('Second');
      print('OTP : ' + callback.otp);
      print('istrustDevice : ' + callback.istrustDevice.toString());
      print('secureTypeID : ' + callback.secureTypeID.toString());
      print('signNextStep : ' + callback.signNextStep.toString());
      noticeSamePikachu(() {});
    });
    super.onReady();
  }

  @override
  void onClose() {
    ctroler
      ..stop()
      ..dispose();
    ctrolerSecond
      ..stop()
      ..dispose();
    super.onClose();
  }
}
