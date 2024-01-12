class SharedPreferenceKeys {
  static const String loginInfo = 'loginInfo';
  static const String otpAppData = 'otpAppData';
  static const String suggestionTasks = 'suggestionTasks';
  static const String suggestionTasksController = 'suggestionTasksController';
  static const String invokeRemindBill = 'invokeRemindBill';
  static const String digitalBillAvailable = 'digitalBillAvailable';

  ///key gen TOTP thanh toán bằng khuôn mặt, vân tay
  static const String touchIDFaceIDSecretKey = 'touchIDFaceIDSecretKey';

  ///Mã 4 số Pin Code and SecretKey
  static const String codeSmartOTP = 'codeSmartOTP';
  static const String codeSmartOTPSecretKey = 'codeSmartOTPSecretKey';

  static const String timeBeginNotShowAgain = 'timeBeginNotShowAgain';

  static const String timeMainEventPopup = 'timeMainEventPopup';

  /// Trạng thái không hiện lại của gợi ý dùng vân tay/faceid khi chuyển tiền
  static const String noMorePopup = 'noMorePopup';

  ///aGuid chỉ dùng cho android, trường hợp người dùng clean data trong app info thì gen lại, coi như 1 thiết bị mới
  static const String aGuid = 'aGuid';

  static const String oneSignalID = 'oneSignalID';

  /// Số lần nhập sai Pin Code
  static const String countWrongSmartOTP = 'countWrongSmartOTP';

  /// show popup điều khoản khi click vietlot
  static const String showVietlotPolicy = 'showVietlotPolicy';

  static const String firstTimeEvent = 'firstTimeEvent';

  /// Thời gian bắt đầu nhập sai Pin Code quá 5 lần
  static const String timeBeginWrongSmartOTPOver5Times =
      'timeBeginWrongSmartOTPOver5Times';

  static const String bgmCandy = 'bgmCandy';

  static const String soundEffectCandy = 'effectSoundCandy';

  int? removeWarning;
}
