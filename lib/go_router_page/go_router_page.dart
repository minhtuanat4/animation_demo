import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../custom_package/home_packages.dart';

class GoRouterPage extends StatefulWidget {
  const GoRouterPage({super.key});

  @override
  State<GoRouterPage> createState() => _GoRouterPageState();
}

class _GoRouterPageState extends State<GoRouterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Go Router')),
      body: Column(
        children: [
          OptionButton(
              label: 'Account Info Page',
              onPressed: () {
                context.pushNamed('account-info');
              }),
          OptionButton(
              label: 'Secure Setups Page',
              onPressed: () {
                context.pushNamed('secure-setups');
              }),
          OptionButton(
              label: 'Trang chu',
              onPressed: () {
                context.go('/');
              }),
        ],
      ),
    );
  }
}
