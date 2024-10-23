class SecureType {
  static const OTPSMS = 1;
  static const OTPEmail = 2;
  static const OTPApp = 3;
  static const PIN_CODE = 22;
  static const Voice_OTP = 19;
  static const TouchFaceID_OTP = 20;
  static const MANUAL_OTP_SMS = 999;
}

class StatusCode {
  static const int SESSIONLOGIN = -8103; //Hết phiên đăng nhập
  static const int INVALID_ACCESSTOKEN = -8102;
  static const int FAIL_REQUEST_BECAUSE_OF_AUTH = -401;
}
