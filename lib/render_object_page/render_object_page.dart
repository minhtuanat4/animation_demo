import 'dart:math';
import 'package:flutter/src/semantics/semantics.dart';

import 'package:flutter/material.dart';

class RenderObjectPage extends StatefulWidget {
  const RenderObjectPage({super.key});

  @override
  State<RenderObjectPage> createState() => _RenderObjectPageState();
}

class _RenderObjectPageState extends State<RenderObjectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Render Object'),
      ),
      body: const RenderObjectWidget(),
    );
  }
}

class RenderObjectWidget extends StatefulWidget {
  const RenderObjectWidget({super.key});

  @override
  State<RenderObjectWidget> createState() => _RenderObjectWidgetState();
}

class _RenderObjectWidgetState extends State<RenderObjectWidget> {
  final TextEditingController _textController = TextEditingController();
  final initText = 'Im here';
  final controller = ValueNotifier<String>('');
  @override
  void initState() {
    _textController.text = initText;
    controller.value = initText;
    _textController.addListener(() {
      controller.value = _textController.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          color: Colors.blue[100],
          padding: const EdgeInsets.all(15),
          child: ValueListenableBuilder<String>(
              valueListenable: controller,
              builder: (context, value, child) {
                return MessgageBubble(
                  text: value,
                  textSendAt: '2 minutes ago',
                  textDirection: Directionality.of(context),
                  textStyle: const TextStyle(color: Colors.red, fontSize: 17),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: TextField(
            controller: _textController,
            decoration: const InputDecoration(
              hintText: 'Message',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}

class MessgageBubble extends LeafRenderObjectWidget {
  final String text;
  final String textSendAt;
  final TextStyle textStyle;
  final TextDirection textDirection;
  const MessgageBubble({
    super.key,
    required this.text,
    required this.textSendAt,
    required this.textStyle,
    required this.textDirection,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MessageBubbleRenderBox(text, textSendAt, textStyle, textDirection);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant MessageBubbleRenderBox renderObject) {
    renderObject.text = text;
    renderObject.texdSendAt = textSendAt;
    renderObject.style = textStyle;

    super.updateRenderObject(context, renderObject);
  }
}

class MessageBubbleRenderBox extends RenderBox {
  MessageBubbleRenderBox(
    String text,
    String textSendAt,
    TextStyle textStyle,
    TextDirection textDirection,
  ) {
    _text = text;
    _texdSendAt = textSendAt;
    _style = textStyle;
    _textDirection = textDirection;

    _textPainter = TextPainter(text: textSpan, textDirection: _textDirection);

    _sendAtTextPainter =
        TextPainter(text: sendAtTextSpan, textDirection: _textDirection);
  }

  late String _text;
  String get text => _text;

  set text(String value) {
    if (_text == value) {
      return;
    }
    _text = value;
    _textPainter.text = textSpan;
    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  late String _texdSendAt;
  String get texdSendAt => _texdSendAt;

  set texdSendAt(String value) {
    if (_texdSendAt == value) {
      return;
    }
    _texdSendAt = value;
    _sendAtTextPainter.text = sendAtTextSpan;
    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  late TextStyle _style;
  TextStyle get style => _style;

  set style(TextStyle value) {
    if (_style == value) {
      return;
    }

    _style = value;
    _textPainter.text = textSpan;
    _sendAtTextPainter.text = sendAtTextSpan;
    markNeedsLayout();
  }

  late TextDirection _textDirection;
  late TextPainter _textPainter;
  late TextPainter _sendAtTextPainter;

  TextSpan get textSpan => TextSpan(text: _text, style: _style);
  TextSpan get sendAtTextSpan => TextSpan(
      text: _texdSendAt,
      style: _style.copyWith(color: Colors.grey, fontSize: 13));

  bool _isSendAtFitsLastLine = false;

  double lineHeight = 0;

  int numberLines = 0;

  double sendAtWidth = 0;

  @override
  void performLayout() {
    _textPainter.layout(maxWidth: constraints.maxWidth);
    _sendAtTextPainter.layout(maxWidth: constraints.maxWidth);
    final textLines = _textPainter.computeLineMetrics();
    var longestLineWidth = 0.0;
    for (var line in textLines) {
      longestLineWidth = max(
        longestLineWidth,
        line.width,
      );
    }
    final lastMessageWith = textLines.last.width;

    lineHeight = textLines.last.height;

    numberLines = textLines.length;

    sendAtWidth = _sendAtTextPainter.computeLineMetrics().first.width;

    final sizeOfMessage = Size(longestLineWidth, _textPainter.height);

    final lineTextWithSendAt = lastMessageWith + (sendAtWidth * 1.1);

    if (numberLines == 1) {
      _isSendAtFitsLastLine = lineTextWithSendAt < constraints.maxWidth;
    } else {
      _isSendAtFitsLastLine =
          lineTextWithSendAt < min(constraints.maxWidth, longestLineWidth);
    }
    late Size computedSize;
    if (_isSendAtFitsLastLine) {
      if (numberLines == 1) {
        computedSize = Size(lineTextWithSendAt, sizeOfMessage.height);
      } else {
        computedSize = Size(
            max(sizeOfMessage.width, lineTextWithSendAt), sizeOfMessage.height);
      }
    } else {
      computedSize = Size(sizeOfMessage.width,
          sizeOfMessage.height + _sendAtTextPainter.height);
    }

    size = constraints.constrain(computedSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    const standardDiviation = 4.0;
    _textPainter.paint(context.canvas, offset);
    late Offset sendAtOffset;
    final sendAtOffsetdX = offset.dx + size.width - sendAtWidth;
    if (_isSendAtFitsLastLine) {
      sendAtOffset = Offset(sendAtOffsetdX,
          offset.dy + lineHeight * (numberLines - 1) + standardDiviation);
    } else {
      sendAtOffset = Offset(sendAtOffsetdX,
          offset.dy + lineHeight * numberLines + standardDiviation);
    }
    _sendAtTextPainter.paint(context.canvas, sendAtOffset);

    super.paint(context, offset);
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    config.isSemanticBoundary = true;
    config.textDirection = _textDirection;
    config.label = '$text at $_texdSendAt';
    super.describeSemanticsConfiguration(config);
  }
}
