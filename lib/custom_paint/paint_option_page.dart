import 'package:animation_demo/define_go_router.dart';
import 'package:animation_demo/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaintOptionPage extends StatelessWidget {
  const PaintOptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paint Option Page')),
      body: SizedBox.expand(
        child: ListView(
          children: [
            OptionButton(
              label: 'Draw arcTo',
              onPressed: () {
                context.goNamed(RouteName.drawArctoPage);
              },
            ),
            OptionButton(
              label: 'CardHiddenAnimationPage',
              onPressed: () {
                context.goNamed(RouteName.cardHiddenAnimationPage);
              },
            ),
          ],
        ),
      ),
    );
  }
}
