import 'package:flutter/material.dart';

import 'package:animation_demo/flutter_use_case/text_show_platform_phone.dart'
    if (dart.library.html) 'package:animation_demo/flutter_use_case/text_show_platform_web.dart'
    as show;
import 'package:flutter/services.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
  final platformShow = show.createAdapter();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Flutter use case: Write specific platform dart code '),
      ),
      body: Center(
        child: Text(platformShow.platformName()),
      ),
    );
  }
}
