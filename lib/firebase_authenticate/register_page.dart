import 'package:animation_demo/common/user_management.dart';
import 'package:animation_demo/getx_demo/common/custom/epos_popup.dart';
import 'package:animation_demo/resource/definition_button.dart';
import 'package:animation_demo/resource/definition_color.dart';
import 'package:animation_demo/resource/definition_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: accountController,
              onFieldSubmitted: (value) {
                FocusScope.of(context).unfocus();
              },
              onChanged: (value) {},
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Nhập email',
                filled: true,
                fillColor: Colors.white,
                errorBorder: inputBorderRed,
                focusedErrorBorder: inputBorderRed,
                enabledBorder: inputBorderGray,
                focusedBorder: inputBorderBlue,
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
              controller: passController,
              onFieldSubmitted: (value) {
                FocusScope.of(context).unfocus();
              },
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                errorBorder: inputBorderRed,
                focusedErrorBorder: inputBorderRed,
                enabledBorder: inputBorderGray,
                focusedBorder: inputBorderBlue,
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
                registerFunc(accountController.text, passController.text);
              },
              title: 'ĐĂNG KÝ',
              textColor: colorBlackPos,
              height: 42,
              backgroundColor: colorYellowAccent,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> registerFunc(String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailAddress, password: password);
      if (credential.user != null) {
        // Success Login

        final token = credential.user?.uid ?? '';
        UserManagement().authCredential = credential.credential;
        if (token.isNotEmpty) {
          UserManagement().setToken(data: token);
        }
        EposPopup.show(context: context, des: 'Đăng ký thành công');
      } else {
        EposPopup.show(
            context: context, des: 'Đăng ký thất bại. Vui lòng thử lại');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    }
  }
}
