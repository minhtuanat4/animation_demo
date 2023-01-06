import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

import '../../custom_package/home_packages.dart';

class AccountInfoPage extends StatelessWidget {
  const AccountInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Info Page')),
      body: Center(
        child: Column(children: [
          OptionButton(
              label: 'Next',
              onPressed: () {
                context.pushNamed('account-detail');
              }),
          OptionButton(
              label: 'Back',
              onPressed: () {
                context.pop();
              }),
          OptionButton(
              label: 'Trang chủ',
              onPressed: () {
                context.goNamed('go-router');
              }),
        ]),
      ),
    );
  }
}
