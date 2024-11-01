import 'package:animation_demo/common/user_management.dart';
import 'package:animation_demo/define_go_router.dart';
import 'package:animation_demo/resource/definition_button.dart';
import 'package:animation_demo/resource/definition_color.dart';
import 'package:animation_demo/resource/definition_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final nameController = TextEditingController();
  final imageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            RowWidget(title: 'Name', textController: nameController),
            const SizedBox(
              height: 30,
            ),
            RowWidget(title: 'Image', textController: imageController),
            const SizedBox(
              height: 30,
            ),
            EposButton(
              onOK: () async {
                if (nameController.text.isNotEmpty &&
                    imageController.text.isNotEmpty) {
                  final uuid = UserManagement().userInfo?.user?.uid ?? '';
                  UserManagement()
                      .addUser(uuid, nameController.text, imageController.text);
                  context.goNamed(
                    RouteName.homePage,
                  );
                }
              },
              title: 'Cập nhật',
              textColor: colorBlackPos,
              height: 42,
              backgroundColor: colorYellowAccent,
            ),
          ],
        ),
      ),
    );
  }
}

class RowWidget extends StatelessWidget {
  final String title;
  final TextEditingController textController;
  const RowWidget(
      {super.key, required this.title, required this.textController});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 3, child: Text(title)),
        Expanded(
          flex: 7,
          child: TextFormField(
            controller: textController,
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
        )
      ],
    );
  }
}
