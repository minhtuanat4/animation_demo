import 'package:animation_demo/login/util/util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validator', () {
    test('validateEmail should return true when validateEmail is not empty',
        () {
      String emmail = 'minhtuanat@gmail.com';

      final result = Validator.validateEmail(emmail);

      expect(result, true);
    });

    test('validateEmail should return false when validateEmail is empty', () {
      String emmail = '';

      final result = Validator.validateEmail(emmail);

      expect(result, false);
    });

    test(
        'validatePassword should return true when validatePassword is not empty',
        () {
      String password = 'abc123';

      final result = Validator.validatePassword(password);

      expect(result, true);
    });
    test('validatePassword should return false when validatePassword is empty',
        () {
      String password = '';

      final result = Validator.validatePassword(password);

      expect(result, false);
    });
    test('isValidateEmail should return false when value is empty', () {
      String emmail = '';

      final result = Validator.isValidEmail(emmail);

      expect(result, false);
    });
    test('isValidateEmail should return true when value is email format', () {
      String emmail = 'minhtuanat@gmail.com';

      final result = Validator.isValidEmail(emmail);

      expect(result, true);
    });
  });
}
