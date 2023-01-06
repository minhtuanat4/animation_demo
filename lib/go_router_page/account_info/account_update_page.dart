import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

import '../../custom_package/home_packages.dart';

class AccountUpdatePage extends StatelessWidget {
  const AccountUpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Update Page')),
      body: Center(
        child: Column(children: [
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
