import 'package:animation_demo/common/definition_color.dart';
import 'package:flutter/material.dart';

class EposButton extends StatelessWidget {
  final VoidCallback onOK;
  final String title;
  final Color textColor;
  final double height;
  final Color backgroundColor;

  const EposButton({
    required this.onOK,
    required this.title,
    required this.textColor,
    required this.height,
    required this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: height,
      child: ElevatedButton(
          onPressed: onOK,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            backgroundColor: backgroundColor,
            shadowColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child:
                Text(title, style: TextStyle(color: textColor, fontSize: 14)),
          )),
    );
  }
}

class EposButtonRadius extends StatelessWidget {
  final VoidCallback onOK;
  final String title;
  final Color textColor;
  final double height;
  final double? width;
  final Color? borderColor;
  final Color backgroundColor;

  const EposButtonRadius({
    required this.onOK,
    required this.title,
    required this.textColor,
    required this.height,
    required this.backgroundColor,
    this.borderColor,
    this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.maxFinite,
      height: height,
      child: ElevatedButton(
          onPressed: onOK,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            backgroundColor: backgroundColor,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: borderColor ?? backgroundColor, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(25)),
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child:
                  Text(title, style: TextStyle(color: textColor, fontSize: 14)),
            ),
          )),
    );
  }
}

class EposButtonRoundRect extends StatelessWidget {
  final String? text;
  final Function? onPressed;
  final Color backgroundColor;
  final Color? textColor;
  final Widget? child;
  final double? height, textSize;
  final Color? borderSideColor;
  final double blurRadius;
  final Color boxShadowColor;

  ///Chiều rộng border
  final double? borderSideWidth;

  ///
  final bool isShadowEnable;
  final double heightborderRadius;

  final double? width;
  final bool fittedText;
  // paddingZero: Bỏ padding mặc định Button
  final EdgeInsetsGeometry? paddingBtn;

  const EposButtonRoundRect({
    Key? key,
    this.text,
    this.onPressed,
    this.backgroundColor = colorBlue500,
    this.textColor = Colors.white,
    this.textSize,
    this.child,
    this.height,
    this.borderSideColor,
    this.blurRadius = 0,
    this.boxShadowColor = colorRed,
    this.isShadowEnable = false,
    this.heightborderRadius = 50,
    this.width,
    this.borderSideWidth,
    this.fittedText = false,
    this.paddingBtn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: height,
          width: width,
          decoration: isShadowEnable
              ? BoxDecoration(
                  color: boxShadowColor,
                  boxShadow: [
                    BoxShadow(
                      color: boxShadowColor,
                      blurRadius: blurRadius,
                    ),
                  ],
                )
              : const BoxDecoration(),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: paddingBtn,
              backgroundColor: backgroundColor,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular((heightborderRadius) / 2),
                side: BorderSide(
                  color: borderSideColor ?? backgroundColor,
                  width: borderSideWidth ?? 0,
                ),
              ),
            ),
            onPressed: () {
              onPressed!();
            },
            child: child ??
                (fittedText
                    ? FittedBox(
                        fit: BoxFit.none,
                        child: Text(
                          text!,
                          style: TextStyle(color: textColor),
                        ),
                      )
                    : Text(
                        text!,
                        style: TextStyle(color: textColor, fontSize: textSize),
                      )),
          ),
        ),
      ],
    );
  }
}
