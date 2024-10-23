class Validator {
  static bool validateEmail(String value) {
    return value.isNotEmpty;
  }

  static bool validatePassword(String value) {
    return value.isNotEmpty;
  }

  static bool isValidEmail(String input) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(input);
  }
}
