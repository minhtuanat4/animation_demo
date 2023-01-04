import 'package:flutter/material.dart';

import 'checkbox_package/checkbox_home.dart';

class HomePackages extends StatefulWidget {
  const HomePackages({Key? key}) : super(key: key);

  @override
  State<HomePackages> createState() => _HomePackagesState();
}

class _HomePackagesState extends State<HomePackages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Home Packages')),
      body: Column(
        children: [
          OptionButton(
            label: 'Check Box Custom Package',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const CheckBoxHome();
                },
              ));
            },
          ),
        ],
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const OptionButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12)),
          onPressed: onPressed,
          child: Text(label)),
    );
  }
}
