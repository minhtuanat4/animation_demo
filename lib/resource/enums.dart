class BiometricTypeDevice {
  static const int NONE = 0;
  static const int FINGER_PRINT = 1;
  static const int FACE_ID = 2;
  static const int IRIS = 3;
}

class VerifyType {
  static const int LOGIN = 1;
  static const int SETUP_TOUCH_FACE = 2;
  static const int DELETE_TOUCH_FACE = 3;
  static const int RESET_PASS = 4;
  static const int CHANGE_PASS = 5;
}

class SecureServiceID {
  ///Đăng nhập
  static const OTP_AUTHEN = 3;

  ///đăng ký
  static const OTP_REGISTER = 2;

  ///Đổi mật khẩu
  static const OTP_CHANGEPASS = 102;

  ///Quên mật khẩu
  static const OTP_FORGOTPASS = 103;
}

enum TableStatus { NOT_USE, USING }

enum TableType {
  NONE,
  NORMAL,
  TAKE_AWAY,
  ONLINE,
}
