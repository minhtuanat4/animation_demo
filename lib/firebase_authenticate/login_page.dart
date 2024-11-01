import 'dart:async';

import 'package:animation_demo/common/user_management.dart';
import 'package:animation_demo/define_go_router.dart';
import 'package:animation_demo/getx_demo/common/custom/epos_popup.dart';
import 'package:animation_demo/resource/definition_button.dart';
import 'package:animation_demo/resource/definition_color.dart';
import 'package:animation_demo/resource/definition_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

int isWind = 0;
double speedWind = 100;

class LoginFirebasePage extends StatefulWidget {
  const LoginFirebasePage({super.key});

  @override
  State<LoginFirebasePage> createState() => _LoginFirebasePageState();
}

class _LoginFirebasePageState extends State<LoginFirebasePage>
    with EposPopup, TickerProviderStateMixin {
  final accountController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    accountController.dispose();
    passController.dispose();

    super.dispose();
  }

  bool isDrop = false;
  @override
  void initState() {
    super.initState();
  }

  Offset offsetChange = Offset(0, 0);
  final heightRope = 30.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        color: Colors.blueGrey,
        padding: const EdgeInsets.all(24.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
            onChanged: (value) {},
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
              // signInFunc('emailAddress', 'password');
              isWind = 1;
            },
            title: 'TOKEN',
            textColor: colorBlackPos,
            height: 42,
            backgroundColor: colorYellowAccent,
          ),
          const SizedBox(
            height: 20,
          ),
          EposButton(
            onOK: () async {
              context.goNamed(
                RouteName.registerPage,
              );
            },
            title: 'ĐĂNG KÝ',
            textColor: colorBlackPos,
            height: 42,
            backgroundColor: colorYellowAccent,
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }

  Future<void> signInFunc(String emailAddress, String password) async {
    final token = null;

    if (token != null && token.isNotEmpty) {
      try {
        final credential =
            await FirebaseAuth.instance.signInWithCustomToken(token);
        if (credential.user != null) {
          // Success Login

          final token = credential.user?.uid ?? '';

          if (token.isNotEmpty) {
            UserManagement().setToken(data: token);
            UserManagement().statusUser(token, true);
            context.goNamed(
              RouteName.infoPage,
            );
          }
        } else {
          EposPopup.show(context: context, des: 'Đăng nhập không thành công');
        }
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
            UserManagement().statusUser(token, true);
          }

          UserManagement().userInfo = credential;
          final name = await UserManagement()
              .databaseRef
              .child('users/$token/')
              .child('name')
              .get()
            ..value;

          if (name.exists) {
            context.goNamed(
              RouteName.homePage,
            );
          } else {
            context.goNamed(
              RouteName.infoPage,
            );
          }
        } else {
          EposPopup.show(context: context, des: 'Đăng nhập không thành công');
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        } else {
          EposPopup.show(context: context, des: e.code);
        }
      }
    }
  }
}
