import 'package:animation_demo/login/extension/extention.dart';
import 'package:animation_demo/login/util/util.dart';

bool loginUseCase(String? email, String? password) {
  if (email.isNullOrEmpty || password.isNullOrEmpty) {
    return false;
  }
  return Validator.isValidEmail(email!) &&
      Validator.validatePassword(password!);
}
