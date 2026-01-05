import 'dart:io';

import 'package:animation_demo/common/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as numberFormat;
import 'package:provider/provider.dart';

import '../resource/definition_color.dart';

enum KeyBoardState {
  border,
  focused,
  error,
}

class KeyBoardController extends ChangeNotifier {
  KeyBoardController();
  void init(String initial) {
    _text = initial;
    textController.text = initial;
  }

  MethodChannel? _methodChannel;
  MethodChannel? get methodChannel => this._methodChannel;

  set methodChannel(MethodChannel? value) {
    this._methodChannel = value;
    if (autoFocus) {
      requestFocus();
    }
  }

  bool autoFocus = false;

  final TextEditingController textController = TextEditingController();

  String? Function(String?)? validator;

  final focusNode = FocusNode();

  KeyBoardState _keyBoardState = KeyBoardState.border;
  KeyBoardState get keyBoardState => this._keyBoardState;

  set keyBoardState(KeyBoardState value) {
    this._keyBoardState = value;
    notifyListeners();
  }

  String _text = '';
  String get text => Platform.isIOS ? this._text : textController.text;

  set text(String value) {
    if (Platform.isIOS) {
      this._text = value;
      methodChannel?.invokeMethod("text", {"text": value});
    } else {
      textController.text = value;
    }
  }

  String _readOnly = '';
  String get readOnly => this._readOnly;

  set readOnly(String value) {
    this._readOnly = value;
    methodChannel?.invokeMethod("readOnly", {"readOnly": value});
  }

  String? _errorText;
  String? get errorText => this._errorText;

  set errorText(String? value) {
    this._errorText = value;
    notifyListeners();
  }

  double _paddingLeftErrorText = 12;
  double get paddingLeftErrorText => this._paddingLeftErrorText;

  set paddingLeftErrorText(double value) {
    this._paddingLeftErrorText = value;
  }

  bool isFocus = false;
  bool validate() {
    if (Platform.isIOS) {
      if (validator == null) return true;
      errorText = validator!(text);
      keyBoardState = errorText == null
          ? isFocus
              ? KeyBoardState.focused
              : KeyBoardState.border
          : KeyBoardState.error;
      methodChannel?.invokeMethod("validate", {"errorText": errorText});
      return errorText == null;
    } else {
      return true;
    }
  }

  void unFocus() {
    if (Platform.isIOS) {
      methodChannel?.invokeMethod("unFocus");
    } else {
      focusNode.unfocus();
    }
  }

  void requestFocus() {
    if (Platform.isIOS) {
      methodChannel?.invokeMethod("requestFocus");
    } else {
      focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    textController.dispose();
    super.dispose();
  }
}

class CustomKeyboardFlutter extends StatefulWidget {
  const CustomKeyboardFlutter({super.key});

  @override
  State<CustomKeyboardFlutter> createState() => _CustomKeyboardFlutterState();
}

class _CustomKeyboardFlutterState extends State<CustomKeyboardFlutter>
    with WidgetsBindingObserver {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  OverlayEntry? overlayEntry;

  final _offset = ValueNotifier<double>(0.0);

  @override
  void dispose() {
    _hideOverlayDialog();
    focusNode.dispose();
    controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void showOverlayDialog(String mess) {
    if (overlayEntry != null) return;
    final overlayState = Overlay.of(context);

    overlayEntry = OverlayEntry(
      builder: (_) => ValueListenableBuilder<double>(
          valueListenable: _offset,
          builder: (context, value, child) {
            return Positioned(
              bottom: value,
              right: 0,
              left: 0,
              child: Material(
                child: GestureDetector(
                  onTap: _hideOverlayDialog, // tap outside to close
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50.withOpacity(0.4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 1,
                          offset: Offset(0, -3), // Shadow position
                        ),
                      ],
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _hideOverlayDialog();
                        },
                        child: Container(
                          child: Text(
                            'Xong',
                            style: TextStyle(fontSize: 15, color: colorBluePos),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );

    overlayState.insert(overlayEntry!);
  }

  void _moveOverlay(double delta) {
    _offset.value = delta; // triggers rebuild
  }

  void _hideOverlayDialog() {
    _offset.value = 0;
    overlayEntry?.remove();
    overlayEntry = null;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeMetrics() {
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;

    print('bottomInsets $bottomInsets');
    bool isKeyboardOpen = bottomInsets != 0;
    if (isKeyboardOpen && focusNode.hasFocus) {
      _moveOverlay(bottomInsets);
      print('Custom Keyboard Flutter');
      if (overlayEntry == null) {
        showOverlayDialog('Custom Keyboard Flutter');
      }
    } else if (!focusNode.hasFocus) {
      if (overlayEntry != null && overlayEntry!.mounted) {
        _hideOverlayDialog();
      }
    }
    super.didChangeMetrics();
  }

  @override
  Widget build(BuildContext context) {
    // print('bottomInsets $bottomInsets');
    // if (isKeyboardOpen && focusNode.hasFocus) {
    //   print('Custom Keyboard Flutter');
    //   if (overlayEntry == null) {
    //     showOverlayDialog('Custom Keyboard Flutter');
    //   }
    // }
    // else if (!isKeyboardOpen) {
    //   if (overlayEntry != null && overlayEntry!.mounted) {
    //     _hideOverlayDialog();
    //   }
    // }
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType:
          const TextInputType.numberWithOptions(signed: false, decimal: true),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorBluePos,
            width: 0.5,
          ),
        ),
      ),
    );
  }
}

class FormatMoney extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    final newText = formatMoney(newValue.text.toInt());
    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}

extension NumberParsing on String {
  int toInt() {
    return int.parse(this);
  }
}

String formatMoney(
  int? number, {
  String format = '#,###',
  String locationlize = 'vi_VN',
}) {
  return number == null
      ? '0'
      : numberFormat.NumberFormat(format, locationlize)
          .format(number)
          .toString();
}

// ignore: must_be_immutable
class NumberPadKeyboardCustom extends StatefulWidget {
  final String initial;
  final KeyBoardController controller;
  final double height;
  final double? width;
  final VoidCallback? onTap;
  final Function(String)? onDone;
  final Function(String)? onChanged;
  String? Function(String?)? validator;
  final TextStyle? style;
  final InputDecoration? inputDecoration;
  final double? borderRadius;
  final int maxLength;
  final int minLines;
  final double cursorWidth;
  final bool autoFocus;
  final bool readOnly;
  final bool isFormatMoney;
  final TextAlign textAlign;

  NumberPadKeyboardCustom({
    super.key,
    this.initial = '',
    required this.controller,
    this.height = 44,
    this.width,
    this.onChanged,
    this.onTap,
    this.onDone,
    this.validator,
    this.style,
    this.inputDecoration,
    this.borderRadius,
    this.maxLength = 100,
    this.minLines = 1,
    this.cursorWidth = 2,
    this.isFormatMoney = false,
    this.readOnly = false,
    this.autoFocus = false,
    this.textAlign = TextAlign.left,
  });

  @override
  State<NumberPadKeyboardCustom> createState() =>
      _NumberPadKeyboardCustomState();
}

class _NumberPadKeyboardCustomState extends State<NumberPadKeyboardCustom>
    with WidgetsBindingObserver {
  MethodChannel? _channel;
  double borderRadius = 0;
  late KeyBoardController controller;
  final keyPrefixIcon = GlobalKey();

  @override
  void dispose() {
    if (Platform.isIOS) {
      _channel?.invokeMethod("removeView");
    }
    super.dispose();
  }

  @override
  void initState() {
    controller = widget.controller;
    if (Platform.isIOS) {
      borderRadius = widget.height / 2;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.inputDecoration?.prefixIcon != null) {
          final _positioned =
              keyPrefixIcon.currentContext?.findRenderObject() as RenderBox?;
          if (widget.inputDecoration?.border == null &&
              _positioned?.size.width != null) {
            controller.paddingLeftErrorText =
                (_positioned?.size.width ?? 12) + 8;
          }
        }
      });
      borderRadius =
          ((widget.borderRadius != null && widget.borderRadius! < borderRadius)
              ? widget.borderRadius
              : borderRadius)!;
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant NumberPadKeyboardCustom oldWidget) {
    print('didUpdateWidget NumberPadKeyboardCustom ');
    super.didUpdateWidget(oldWidget);
  }

  Widget prefixIcon() {
    return widget.inputDecoration?.prefixIcon != null
        ? Container(
            key: keyPrefixIcon,
            padding: const EdgeInsets.only(left: 12),
            child: widget.inputDecoration?.prefixIcon,
          )
        : const SizedBox();
  }

  Widget suffixIcon() {
    return widget.inputDecoration?.suffixIcon != null
        ? Container(
            padding: const EdgeInsets.only(left: 12),
            child: widget.inputDecoration?.suffixIcon,
          )
        : const SizedBox();
  }

  BoxDecoration borderCustom(Color color) {
    return BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
        border: Border.all(
          color: color,
          width: widget.inputDecoration?.border?.borderSide.width ?? 1,
        ));
  }

  BoxDecoration? getBoxBorder(KeyBoardState state) {
    switch (state) {
      case KeyBoardState.border:
        return widget.inputDecoration?.border == null
            ? null
            : BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius),
                ),
                border: Border.all(
                  color: widget.inputDecoration?.border?.borderSide.color ??
                      Colors.grey,
                  width: widget.inputDecoration?.border?.borderSide.width ?? 1,
                )
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.shade200,
                //     blurRadius: 1,
                //     offset: Offset(0, 1), // Shadow position
                //   ),
                // ],
                );

      case KeyBoardState.focused:
        return widget.inputDecoration?.focusedBorder != null
            ? BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius),
                ),
                border: Border.all(
                  color:
                      widget.inputDecoration?.focusedBorder?.borderSide.color ??
                          Colors.blue,
                  width:
                      widget.inputDecoration?.focusedBorder?.borderSide.width ??
                          1,
                ))
            : widget.inputDecoration?.border != null
                ? borderCustom(Colors.blue)
                : null;

      case KeyBoardState.error:
        return widget.inputDecoration?.errorBorder != null
            ? BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius),
                ),
                border: Border.all(
                  color:
                      widget.inputDecoration?.errorBorder?.borderSide.color ??
                          Colors.red,
                  width:
                      widget.inputDecoration?.errorBorder?.borderSide.width ??
                          1,
                ))
            : widget.inputDecoration?.border != null
                ? borderCustom(Colors.red)
                : null;

      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    const viewType = 'CustomKeyboard';
    controller.validator = widget.validator;
    controller.autoFocus = widget.autoFocus;
    controller.init(widget.initial);
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return controller;
      },
      child: Platform.isIOS
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: widget.width ?? MediaQuery.sizeOf(context).width,
                  height: widget.height,
                  child: Stack(
                    children: [
                      Selector<KeyBoardController, KeyBoardState>(
                        selector: (p0, p1) => p1.keyBoardState,
                        builder: (context, keyBoardState, child) {
                          return Container(
                            decoration: getBoxBorder(keyBoardState),
                          );
                        },
                      ),
                      Row(
                        children: [
                          prefixIcon(),
                          Expanded(
                            child: Builder(builder: (context) {
                              final border = widget.inputDecoration?.border;
                              final focusedBorder =
                                  widget.inputDecoration?.focusedBorder;
                              final errorBorder =
                                  widget.inputDecoration?.errorBorder;
                              return SizedBox(
                                width: widget.width ??
                                    MediaQuery.sizeOf(context).width,
                                height: widget.height,
                                child: UiKitView(
                                  viewType: viewType,
                                  onPlatformViewCreated: (int id) {
                                    _channel =
                                        MethodChannel('custom_keyboard_$id');
                                    controller.methodChannel = _channel!;

                                    _channel!
                                        .setMethodCallHandler((call) async {
                                      if (!mounted) {
                                        return;
                                      }
                                      switch (call.method) {
                                        case "onChanged":
                                          final text = call.arguments as String;
                                          controller.text = text;
                                          widget.onChanged?.call(text);
                                          controller.isFocus = true;
                                          break;
                                        case "onTap":
                                          widget.onTap?.call();
                                          controller.isFocus = true;
                                          if (controller.keyBoardState ==
                                              KeyBoardState.error) {
                                            return;
                                          }
                                          controller.keyBoardState =
                                              KeyBoardState.focused;

                                          break;
                                        case "onDone":
                                          widget.onDone
                                              ?.call(call.arguments as String);
                                          controller.isFocus = false;
                                          if (controller.keyBoardState ==
                                              KeyBoardState.error) {
                                            return;
                                          }
                                          controller.keyBoardState =
                                              KeyBoardState.border;
                                          break;
                                      }
                                    });
                                  },
                                  creationParams: {
                                    'initial': widget.initial,
                                    'readOnly': widget.readOnly,
                                    'maxLines': 1,
                                    'minLines': widget.minLines,
                                    'textAlignment': widget.textAlign.name,
                                    'autoFocus': widget.autoFocus,
                                    'cursorWidth': widget.cursorWidth,
                                    'isFormatMoney': widget.isFormatMoney,
                                    'maxLength': widget.maxLength,
                                    'backgroundColor': Colors.white.toHex(),
                                    'style': {
                                      'fontSize': widget.style?.fontSize,
                                      'color': widget.style?.color?.toHex() ??
                                          Colors.black.toHex(),
                                      'letterSpacing':
                                          widget.isFormatMoney ? 2 : 0,
                                      'fontWeight':
                                          (widget.style?.fontWeight?.index ??
                                                      0) >
                                                  FontWeight.w500.index
                                              ? 'bold'
                                              : 'normal',
                                    },
                                    'decoration': {
                                      'contentPadding': {
                                        'left': widget
                                                .inputDecoration?.contentPadding
                                                ?.resolve(TextDirection.ltr)
                                                .left ??
                                            12,
                                        'top': widget
                                                .inputDecoration?.contentPadding
                                                ?.resolve(TextDirection.ltr)
                                                .top ??
                                            0,
                                        'right': widget
                                                .inputDecoration?.contentPadding
                                                ?.resolve(TextDirection.ltr)
                                                .right ??
                                            12,
                                        'bottom': widget
                                                .inputDecoration?.contentPadding
                                                ?.resolve(TextDirection.ltr)
                                                .bottom ??
                                            0,
                                      },
                                      'hintStyle': {
                                        'fontSize': widget.inputDecoration
                                                ?.hintStyle?.fontSize ??
                                            14,
                                        'color': widget.inputDecoration
                                                ?.hintStyle?.color
                                                ?.toHex() ??
                                            Colors.grey.toHex(),
                                        'fontStyle': widget.inputDecoration
                                                    ?.hintStyle?.fontStyle ==
                                                FontStyle.italic
                                            ? 'italic'
                                            : 'normal',
                                      },
                                      'hintText':
                                          widget.inputDecoration?.hintText ??
                                              '',
                                      'border': {
                                        'borderSide': {
                                          'width': border == null ? 1 : 0,
                                          'color': border?.borderSide.color
                                                  .toHex() ??
                                              Colors.grey.toHex(),
                                          'underline': border == null,
                                        },
                                        'borderRadius': borderRadius,
                                      },
                                      'focusedBorder': {
                                        'borderSide': {
                                          'width': border == null &&
                                                  focusedBorder == null
                                              ? 2
                                              : 0,
                                          'color': widget
                                                  .inputDecoration
                                                  ?.focusedBorder
                                                  ?.borderSide
                                                  .color
                                                  .toHex() ??
                                              Colors.blue.toHex(),
                                          'underline': border == null &&
                                              focusedBorder == null,
                                        },
                                        'borderRadius': borderRadius,
                                      },
                                      'errorBorder': {
                                        'borderSide': {
                                          'width': border == null &&
                                                  errorBorder == null
                                              ? 2
                                              : 0,
                                          'color': widget
                                                  .inputDecoration
                                                  ?.errorBorder
                                                  ?.borderSide
                                                  .color
                                                  .toHex() ??
                                              Colors.red.toHex(),
                                          'underline': border == null &&
                                              errorBorder == null,
                                        },
                                        'borderRadius': borderRadius,
                                      },
                                    }
                                  },
                                  creationParamsCodec:
                                      const StandardMessageCodec(),
                                ),
                              );
                            }),
                          ),
                          suffixIcon(),
                        ],
                      ),
                    ],
                  ),
                ),
                ErrorTextWidget()
              ],
            )
          : SizedBox(
              width: widget.width ?? MediaQuery.sizeOf(context).width,
              child: TextFormField(
                  textAlign: widget.textAlign,
                  autofocus: widget.autoFocus,
                  focusNode: controller.focusNode,
                  readOnly: widget.readOnly,
                  minLines: widget.minLines,
                  maxLines: 1,
                  cursorWidth: widget.cursorWidth,
                  controller: controller.textController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(widget.maxLength),
                    FilteringTextInputFormatter.digitsOnly,
                    if (widget.isFormatMoney) FormatMoney(),
                  ],
                  onChanged: widget.onChanged,
                  style: widget.style,
                  scrollPadding: EdgeInsets.all(0),
                  onTap: widget.onTap,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (widget.onDone != null) {
                      widget.onDone!(controller.text);
                    }
                  },
                  validator: widget.validator,
                  keyboardType: TextInputType.number,
                  decoration: widget.inputDecoration),
            ),
    );
  }
}

class ErrorTextWidget extends StatelessWidget {
  const ErrorTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<KeyBoardController, String?>(
        selector: (p0, p1) => p1.errorText,
        builder: (context, errorText, __) {
          final data = errorText;
          final paddingLeftErrorText =
              context.read<KeyBoardController>().paddingLeftErrorText;
          return data == null
              ? const SizedBox()
              : Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 2, left: paddingLeftErrorText),
                    child: Text(
                      data,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                );
        });
  }
}

class CustomProgressIndicator extends StatefulWidget {
  const CustomProgressIndicator({super.key});

  @override
  State<CustomProgressIndicator> createState() =>
      _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator>
    with TickerProviderStateMixin {
  final positionNotifier = ValueNotifier<double>(0);

  double startPosition = 0.0;

  double maxRight = 105;

  double currentRight = 0.0;

  double width = 200;
  List<GlobalKey<_SlideWidgetCustomState>> lstKey = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];
  int currentSlideChange = -1;
  void resetSlide() {
    if (currentSlideChange != -1) {
      lstKey[currentSlideChange].currentState?.resetPosition();
    }
  }

  final formKey = GlobalKey<FormState>();

  final showDone = ValueNotifier<bool>(false);

  final controller1 = KeyBoardController();
  final controller2 = KeyBoardController();

  @override
  void initState() {
    super.initState();
  }

  double keyboardHeight = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Custom Progress Indicator'),
      ),
      body: GestureDetector(
        onTap: () {
          print('GestureDetector');
          FocusScope.of(context).requestFocus(FocusNode());
          // controller1.unFocus();
        },
        onVerticalDragDown: (v) {
          resetSlide();
        },
        child: Container(
          color: Colors.transparent,
          height: MediaQuery.sizeOf(context).height,
          child: Form(
            key: formKey,
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: NumberPadKeyboardCustom(
                                initial: '12312',
                                isFormatMoney: true,
                                autoFocus: true,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                inputDecoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.phone_android,
                                    color: Colors.grey,
                                  ),
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  hintText: 'Input here',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 14),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                controller: controller1,
                                onChanged: (text) {
                                  print("Keyboard1 changed: $text");
                                },
                                onTap: () => print("Keyboard1 tapped"),
                                onDone: (text) {
                                  print("Keyboard1 onDone: $text");
                                  controller2.requestFocus();
                                },
                                validator: (value) {
                                  if (value != null && value.isEmpty) {
                                    return 'khong dc de trong';
                                  } else if (value == '55') {
                                    return 'yeah';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: NumberPadKeyboardCustom(
                        borderRadius: 25,
                        inputDecoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        controller: controller2,
                        validator: (value) {
                          if (value == '55') {
                            return 'yeah';
                          }
                          return 'dasdasd';
                        },
                        onChanged: (text) {
                          print("Keyboard2 changed: $text");
                        },
                        onTap: () => print("Keyboard2 tapped"),
                        onDone: (text) => print("Keyboard2 done: $text"),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller1.text = '20';
                      },
                      child: Text('Set1'),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        controller2.text = '20';
                      },
                      child: Text('Set2'),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        // formKey.currentState?.validate();
                      },
                      child: Text('Validate 1'),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        print('Validate');
                        // keyForm.currentState?.validate();
                        controller1.requestFocus();
                      },
                      child: Text('Validate 2'),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     print('Next Focus');
                    //     // keyForm.currentState?.validate();
                    //     controller1.requestFocus();
                    //   },
                    //   child: Text('Validate 2'),
                    // ),
                    // Expanded(
                    //   child: ListView.separated(
                    //       itemBuilder: (_, index) {
                    //         return SlideWidgetCustom(
                    //           height: 80,
                    //           firstChild: Padding(
                    //             padding: const EdgeInsets.only(top: 4, left: 8),
                    //             child: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Text('Minh Tuan'),
                    //                 Text('1232312312312'),
                    //                 Text('EVN Ha Noi'),
                    //               ],
                    //             ),
                    //           ),
                    //           onEdit: () {},
                    //           onDel: () {},
                    //           key: lstKey[index],
                    //           onSlideChange: (value) {
                    //             if (value) {
                    //               if (currentSlideChange != -1 &&
                    //                   currentSlideChange != index) {
                    //                 lstKey[currentSlideChange]
                    //                     .currentState
                    //                     ?.resetPosition();
                    //               }
                    //               currentSlideChange = index;
                    //             }
                    //           },
                    //         );
                    //       },
                    //       separatorBuilder: (_, index) {
                    //         return const SizedBox(
                    //           height: 12,
                    //         );
                    //       },
                    //       itemCount: lstKey.length),
                    // )
                  ],
                ),
                // MediaQuery.viewInsetsOf(context).bottom > 20
                //     ? Positioned(
                //         right: 0,
                //         left: 0,
                //         bottom: MediaQuery.viewInsetsOf(context).bottom,
                //         child: Material(
                //           child: Container(
                //             padding: const EdgeInsets.symmetric(
                //                 horizontal: 8, vertical: 4),
                //             color: Colors.blue.shade50,
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.end,
                //               children: [
                //                 GestureDetector(
                //                   onTap: () {
                //                     print('object');

                //                     FocusScope.of(context)
                //                         .requestFocus(FocusNode());
                //                   },
                //                   child: Container(
                //                     color: Colors.transparent,
                //                     child: Text(
                //                       'Xong',
                //                       style: TextStyle(fontSize: 14),
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //       )
                //     : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SlideWidgetCustom extends StatefulWidget {
  const SlideWidgetCustom({
    super.key,
    required this.firstChild,
    required this.height,
    this.bgColorFirst,
    this.secondWidgetWidth,
    this.borderRadius,
    required this.onEdit,
    required this.onDel,
    required this.onSlideChange,
  });

  final double? secondWidgetWidth;
  final double height;
  final Widget firstChild;
  final Color? bgColorFirst;
  final double? borderRadius;
  final VoidCallback onEdit;
  final VoidCallback onDel;
  final Function(bool) onSlideChange;

  @override
  State<SlideWidgetCustom> createState() => _SlideWidgetCustomState();
}

class _SlideWidgetCustomState extends State<SlideWidgetCustom> {
  final positionNotifier = ValueNotifier<double>(0);

  double startPosition = 0.0;

  double maxRight = 5;

  double currentRight = 0.0;

  double radius = 4;

  bool isReset = true;

  @override
  void initState() {
    radius = widget.borderRadius ?? 4;
    maxRight = maxRight + (widget.secondWidgetWidth ?? 128);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SlideWidgetCustom oldWidget) {
    // print('didUpdateWidget ChooseProductQuantity');
    if (mounted) {
      resetPosition();
    }
    super.didUpdateWidget(oldWidget);
  }

  void resetPosition() {
    positionNotifier.value = currentRight = 0;
    isReset = true;
    widget.onSlideChange(!isReset);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: widget.secondWidgetWidth ?? 128,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        resetPosition();
                        widget.onEdit();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorGrey,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(radius),
                            bottomLeft: Radius.circular(radius),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit_document,
                              color: colorWhite,
                              size: 20,
                            ),
                            Text(
                              'Chỉnh sửa',
                              style: TextStyle(
                                color: colorWhite,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        resetPosition();
                        widget.onDel();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: colorRed,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(radius),
                              bottomRight: Radius.circular(radius),
                            )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete,
                              color: colorWhite,
                              size: 20,
                            ),
                            Text(
                              'Xoá',
                              style: TextStyle(
                                color: colorWhite,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onHorizontalDragEnd: (value) {
              if (currentRight == maxRight) {
                if (positionNotifier.value > maxRight) {
                  positionNotifier.value = currentRight = maxRight;
                  isReset = false;
                  widget.onSlideChange(!isReset);
                } else {
                  resetPosition();
                }
                return;
              }
              if (positionNotifier.value > 20) {
                positionNotifier.value = currentRight = maxRight;
                isReset = false;
                widget.onSlideChange(!isReset);
                return;
              } else if (positionNotifier.value <= 20) {
                resetPosition();
                return;
              }
            },
            onHorizontalDragStart: (value) {
              startPosition = value.globalPosition.dx;
            },
            onHorizontalDragUpdate: (update) {
              final updatePosition =
                  startPosition - update.globalPosition.dx + currentRight;
              if (updatePosition < 0) {
                positionNotifier.value = 0;
                return;
              }

              positionNotifier.value = updatePosition;
            },
            child: ValueListenableBuilder(
              builder: (context, _, __) {
                return AnimatedContainer(
                  onEnd: () {
                    print('end');
                  },
                  transform:
                      Matrix4.translationValues(-positionNotifier.value, 0, 0),
                  duration: const Duration(milliseconds: 150),
                  child: Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: widget.bgColorFirst ?? colorWhite,
                      borderRadius: BorderRadius.all(
                        Radius.circular(radius),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 1,
                        ),
                      ],
                    ),
                    child: widget.firstChild,
                  ),
                );
              },
              valueListenable: positionNotifier,
            ),
          ),
        ],
      ),
    );
  }
}
