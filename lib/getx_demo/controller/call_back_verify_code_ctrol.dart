import 'package:get/get.dart';

class CallBackVerifyCodeCtrol extends GetxController {
  Rx<DateTime> isCallBackVerifyCode = DateTime.now().obs;
  String otp = '';

  String totp = '';

  int secureTypeID = 0;
  bool istrustDevice = false;
  String serviceID = '';
  int step = 0;
  String requestId = '';
  int signNextStep = 0;
  int otpRequestId = 0;

  void callBack({
    String otp = '',
    String totp = '',
    int secureTypeID = 0,
    bool istrustDevice = false,
    String serviceID = '',
    int step = 0,
    String requestId = '',
    int signNextStep = 0,
  }) {
    this.otp = otp;
    this.totp = totp;
    this.secureTypeID = secureTypeID;
    this.istrustDevice = istrustDevice;
    this.serviceID = serviceID;
    this.step = step;
    this.signNextStep = signNextStep;
    this.requestId = requestId;
    isCallBackVerifyCode.value = DateTime.now();
  }
}
