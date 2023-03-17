import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/user_management.dart';
import '../../custom_package/home_packages.dart';

class SecureSetupsPage extends StatelessWidget {
  const SecureSetupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SecureSetupsPage')),
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
                UserManagement().navigatorKey!.currentContext!.goNamed('/');
              }),
        ]),
      ),
    );
  }
}
