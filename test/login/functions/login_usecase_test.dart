import 'package:animation_demo/login/functions/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Login', () {
    test('loginUseCase should return false when email and password are empty',
        () {
      String email = '';
      String password = '';
      final result = loginUseCase(email, password);
      expect(result, false);
    });
    test('loginUseCase should return false when email are empty', () {
      String email = '';
      String password = 'abc123';
      final result = loginUseCase(email, password);
      expect(result, false);
    });
    test('loginUseCase should return false when password are empty', () {
      String email = 'minhtuanat.com';
      String password = '';
      final result = loginUseCase(email, password);
      expect(result, false);
    });
    test(
        'loginUseCase should return false when email and password are not empty but not correct email',
        () {
      String email = 'minhtuanat.com';
      String password = 'abc123';
      final result = loginUseCase(email, password);
      expect(result, false);
    });
    test(
        'loginUseCase should return true when email and password are not empty',
        () {
      String email = 'minhtuanat4@gmail.com';
      String password = 'abc123';
      final result = loginUseCase(email, password);
      expect(result, true);
    });
  });
}
