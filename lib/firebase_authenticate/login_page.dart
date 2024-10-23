import 'package:animation_demo/common/definition_color.dart';
import 'package:animation_demo/common/user_management.dart';
import 'package:animation_demo/resource/definition_button.dart';
import 'package:animation_demo/resource/definition_color.dart';
import 'package:animation_demo/resource/definition_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final accountController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    accountController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextFormField(
          controller: accountController,
          onFieldSubmitted: (value) {
            FocusScope.of(context).unfocus();
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Vui lòng nhập số điện thoại';
            }

            return null;
          },
          onChanged: (value) {},
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Nhập số điện thoại',
            filled: true,
            fillColor: Colors.white,
            errorBorder: inputBorderRed,
            focusedErrorBorder: inputBorderRed,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: colorWhite,
                width: 0.5,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: colorWhite,
                width: 0.5,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: accountController,
          onFieldSubmitted: (value) {
            FocusScope.of(context).unfocus();
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Vui lòng nhập số điện thoại';
            }

            return null;
          },
          onChanged: (value) {},
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Nhập số điện thoại',
            filled: true,
            fillColor: Colors.white,
            errorBorder: inputBorderRed,
            focusedErrorBorder: inputBorderRed,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: colorWhite,
                width: 0.5,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: colorWhite,
                width: 0.5,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        EposButton(
          onOK: () async {
            signInFunc(accountController.text, passController.text);
          },
          title: 'ĐĂNG NHẬP',
          textColor: colorBlackPos,
          height: 42,
          backgroundColor: colorYellowAccent,
        ),
        const SizedBox(
          height: 20,
        ),
        EposButton(
          onOK: () async {
            signInFunc('emailAddress', 'password');
          },
          title: 'TOKEN',
          textColor: colorBlackPos,
          height: 42,
          backgroundColor: colorYellowAccent,
        ),
      ]),
    );
  }

  Future<void> signInFunc(String emailAddress, String password) async {
    final token = await UserManagement().getToken();

    if (token != null && token.isNotEmpty) {
      try {
        final credential =
            await FirebaseAuth.instance.signInWithCustomToken(token);
        if (credential.user != null) {
          // Success Login

          final token = credential.user?.uid ?? '';

          if (token.isNotEmpty) {
            UserManagement().setToken(data: token);
          }
        } else {}
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    } else {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailAddress, password: password);
        if (credential.user != null) {
          // Success Login

          final token = credential.user?.uid ?? '';

          if (token.isNotEmpty) {
            UserManagement().setToken(data: token);
          }
        } else {}
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
  }
}
