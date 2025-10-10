import 'dart:io';

import 'package:animation_demo/common/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../resource/definition_color.dart';

extension a on TextFormField {}

class KeyBoardController extends ChangeNotifier {
  KeyBoardController({String? text});

  late MethodChannel methodChannel;

  final TextEditingController textController = TextEditingController();

  String _text = '';
  String get text => this._text;

  set text(String value) {
    this._text = value;
    methodChannel.invokeMethod("text", {"text": value});
  }

  String _readOnly = '';
  String get readOnly => this._readOnly;

  set readOnly(String value) {
    this._readOnly = value;
    methodChannel.invokeMethod("readOnly", {"readOnly": value});
  }

  String? _errorText;
  String? get errorText => this._errorText;

  set errorText(String? value) {
    this._errorText = value;
    notifyListeners();
  }

  String? currentErrorText = null;

  void validate() {
    errorText = currentErrorText;
    methodChannel.invokeMethod("validate", {"errorText": errorText});
  }

  @override
  void dispose() {
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

  final showOption = ValueNotifier<bool>(false);
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        // showOverlayDialog('Custom Keyboard Flutter');
      } else {
        // _hideOverlayDialog();
      }
    });
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

class CustomKeyboard extends StatefulWidget {
  final String initial;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final Function(String)? onDone;
  final String? Function(String?) validator;
  final KeyBoardController? controller;
  final InputDecoration? inputDecoration;
  final double? borderRadius;
  final double height;
  final double? width;

  const CustomKeyboard(
      {super.key,
      this.onChanged,
      this.onTap,
      this.onDone,
      this.initial = '',
      this.controller,
      required this.validator,
      this.inputDecoration,
      this.borderRadius,
      this.height = 44,
      this.width});

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard>
    with WidgetsBindingObserver {
  late MethodChannel _channel;
  double borderRadius = 0;
  @override
  void dispose() {
    _channel.invokeMethod("removeView");
    super.dispose();
  }

  @override
  void initState() {
    borderRadius = widget.height / 2;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller?.currentErrorText = widget.validator(null) ?? '';
      print(widget.validator('55') ?? '');
    });
    borderRadius =
        ((widget.borderRadius != null && widget.borderRadius! < borderRadius)
            ? widget.borderRadius
            : borderRadius)!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const viewType = 'CustomKeyboard';
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        // widget.controller?.validator = widget.validator;
        return widget.controller ?? KeyBoardController(text: widget.initial);
      },
      child: Platform.isAndroid
          ? SizedBox(
              width: widget.width ?? MediaQuery.sizeOf(context).width,
              height: widget.height,
              child: TextFormField(
                controller: widget.controller?.textController,
                scrollPadding: EdgeInsets.all(0),
                onEditingComplete: () {
                  print('Complete');
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                validator: (value) {
                  return '';
                },
                keyboardType: TextInputType.number,
                decoration: widget.inputDecoration ??
                    InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: colorBluePos,
                          width: 0.5,
                        ),
                      ),
                    ),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: widget.width ?? MediaQuery.sizeOf(context).width,
                  height: widget.height,
                  child: UiKitView(
                    viewType: viewType,
                    onPlatformViewCreated: (int id) {
                      _channel = MethodChannel('custom_keyboard_$id');
                      widget.controller?.methodChannel = _channel;
                      _channel.setMethodCallHandler((call) async {
                        switch (call.method) {
                          case "onChanged":
                            final text = call.arguments as String;
                            widget.controller?.text = text;
                            setState(() {});
                            widget.controller?.currentErrorText =
                                widget.validator(text) ?? '';
                            widget.validator(text);
                            print('widget.controller?.currentErrorText ' +
                                (widget.validator('55') ?? 'dasdas'));
                            widget.onChanged?.call(text);
                            break;
                          case "onTap":
                            widget.onTap?.call();
                            break;
                          case "onDone":
                            widget.onDone?.call(call.arguments as String);
                            break;
                        }
                      });
                    },
                    creationParams: {
                      'readOnly': false,
                      'maxLines': 1,
                      'minLines': 1,
                      'cursorWidth': 2,
                      'isFormatMoney': false,
                      'maxLength': 10,
                      'backgroundColor': Colors.white.toHex(),
                      'decoration': {
                        'border': {
                          'borderSide': {
                            'width': widget.inputDecoration?.border?.borderSide
                                    .width ??
                                1,
                            'color': widget
                                    .inputDecoration?.border?.borderSide.color
                                    .toHex() ??
                                Colors.grey.toHex(),
                          },
                          'borderRadius': borderRadius,
                        },
                        'focusedBorder': {
                          'borderSide': {
                            'width': widget.inputDecoration?.focusedBorder
                                    ?.borderSide.width ??
                                1,
                            'color': widget.inputDecoration?.focusedBorder
                                    ?.borderSide.color
                                    .toHex() ??
                                Colors.grey.toHex(),
                          },
                          'borderRadius': borderRadius,
                        },
                        'errorBorder': {
                          'borderSide': {
                            'width': widget.inputDecoration?.errorBorder
                                    ?.borderSide.width ??
                                1,
                            'color': widget.inputDecoration?.errorBorder
                                    ?.borderSide.color
                                    .toHex() ??
                                Colors.grey.toHex(),
                          },
                          'borderRadius': borderRadius,
                        },
                      }
                    },
                    creationParamsCodec: const StandardMessageCodec(),
                  ),
                ),
                ErrorTextWidget()
              ],
            ),
    );
  }
}

class ErrorTextWidget extends StatelessWidget {
  const ErrorTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<KeyBoardController>().errorText;
    return data == null
        ? const SizedBox()
        : Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 8),
              child: Text(
                data,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          );
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

  final showDone = ValueNotifier<bool>(false);

  // static const _channel = MethodChannel("custom_keyboard_channel");
  final a = TextEditingController();

  final controller1 = KeyBoardController();
  final controller2 = KeyBoardController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          FocusScope.of(context).requestFocus(FocusNode());
        },
        // onTapDown: (v) {
        //   resetSlide();
        // },
        onVerticalDragDown: (v) {
          resetSlide();
        },
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: Stack(
            children: [
              Column(
                children: [
                  // CustomKeyboardFlutter(),
                  // const SizedBox(
                  //   height: 12,
                  // ),
                  // CustomKeyboardFlutter(),
                  // const SizedBox(
                  //   height: 12,
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const SizedBox(
                          height: 100,
                          width: 100,
                        ),
                        Expanded(
                          child: CustomKeyboard(
                            borderRadius: 25,
                            inputDecoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16),
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
                            controller: controller1,
                            onChanged: (text) =>
                                print("Keyboard1 changed: $text"),
                            onTap: () => print("Keyboard1 tapped"),
                            onDone: (text) => print("Keyboard1 done: $text"),
                            validator: (value) {
                              return '';
                            },
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
                    child: CustomKeyboard(
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
                        setState(() {});
                      },
                      onTap: () => print("Keyboard2 tapped"),
                      onDone: (text) => print("Keyboard2 done: $text"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // resetSlide();
                      controller1.text = '20';
                      // showOverlayDialog();
                    },
                    child: Text('Set1'),
                  ),
                  GestureDetector(
                    onTap: () {
                      // resetSlide();
                      controller2.text = '20';
                      // showOverlayDialog();
                    },
                    child: Text('Set2'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  GestureDetector(
                    onTap: () {
                      // resetSlide();
                      controller1.validate();

                      // showOverlayDialog();
                    },
                    child: Text('Get'),
                  ),
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (_, index) {
                          return SlideWidgetCustom(
                            height: 80,
                            firstChild: Padding(
                              padding: const EdgeInsets.only(top: 4, left: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Minh Tuan'),
                                  Text('1232312312312'),
                                  Text('EVN Ha Noi'),
                                ],
                              ),
                            ),
                            onEdit: () {},
                            onDel: () {},
                            key: lstKey[index],
                            onSlideChange: (value) {
                              if (value) {
                                if (currentSlideChange != -1 &&
                                    currentSlideChange != index) {
                                  lstKey[currentSlideChange]
                                      .currentState
                                      ?.resetPosition();
                                }
                                currentSlideChange = index;
                              }
                            },
                          );
                        },
                        separatorBuilder: (_, index) {
                          return const SizedBox(
                            height: 12,
                          );
                        },
                        itemCount: lstKey.length),
                  )
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
