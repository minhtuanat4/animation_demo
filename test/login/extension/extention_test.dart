import 'package:animation_demo/login/extension/extention.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isNullOrEmpty', () {
    test('should return true when string is null', () {
      String? testString;

      final result = testString.isNullOrEmpty;

      expect(result, true);
    });
    test('should return true when string is empty', () {
      String testString = '';

      final result = testString.isNullOrEmpty;

      expect(result, true);
    });
    test('should return false when string is not null and empty', () {
      String testString = 'abc123';

      final result = testString.isNullOrEmpty;

      expect(result, false);
    });
  });
}
