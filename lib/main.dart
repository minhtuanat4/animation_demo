import 'package:animation_demo/page_view/page_view.dart';
import 'package:animation_demo/validation_textfield/validation_textfield_bloc/validation_textfield_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'custom_package/home_packages.dart';
import 'lifecycle_state/lifecycle_state_page.dart';
import 'roll_paper_roll.dart/main_holiday.dart';
import 'tool_tip/tool_tip_demo.dart';
import 'validation_textfield/validation_textfield_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => ValidationTextfieldBloc())],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MyHomePage(title: 'Flutter Demo Home Page')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: const OptionWidget());
  }
}

class OptionWidget extends StatelessWidget {
  const OptionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          OptionButton(
              label: 'Page View Animation',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return const MyPageView();
                  },
                ));
              }),
          OptionButton(
              label: 'Roll Paper Roll',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return const GameHolidays();
                  },
                ));
              }),
          OptionButton(
            label: 'Lifecycles State',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const LifecyleStatePage();
                },
              ));
            },
          ),
          OptionButton(
            label: 'Custom Package',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const HomePackages();
                },
              ));
            },
          ),
          OptionButton(
            label: 'Demo Tooltip',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const TooltipDemo();
                },
              ));
            },
          ),
          OptionButton(
            label: 'Custom Validate Textfield',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const ValidationTextFieldPage();
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
