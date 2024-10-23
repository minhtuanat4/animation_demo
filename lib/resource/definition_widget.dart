import 'package:animation_demo/resource/definition_color.dart';
import 'package:flutter/material.dart';

const paddingZeroDefine = EdgeInsets.all(0);

const inputBorderRed = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(10)),
  borderSide: BorderSide(
    color: Colors.red,
  ),
);

const inputBorderBlue = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(8)),
  borderSide: BorderSide(
    color: Colors.blue,
  ),
);

const inputBorderBlack = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(8)),
);

const inputBorderGray = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(8)),
  borderSide: BorderSide(
    color: Colors.grey,
  ),
);

// Dùng cho màn Login , Register
const inputLoginRegisterBorderRed = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(50)),
  borderSide: BorderSide(
    color: Colors.red,
  ),
);

const inputLoginRegisterFoucusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(50),
  ),
  borderSide: BorderSide(
    color: Colors.transparent,
  ),
);

const inputLoginRegisterEnabledBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(50),
  ),
  borderSide: BorderSide(
    width: 0,
    color: Colors.transparent,
  ),
);

const inputBorderVietQR = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(25)),
  borderSide: BorderSide(
    color: Colors.grey,
  ),
);

const inputBorderVietQRFocus = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(25)),
  borderSide: BorderSide(
    color: Colors.blue,
  ),
);

const boxDecorationShadow = BoxDecoration(
  color: Colors.white,
  boxShadow: [
    BoxShadow(blurRadius: 5),
  ],
  borderRadius: BorderRadius.all(
    Radius.circular(10),
  ),
);

const placeholderCircular = Center(
  child: SizedBox(
    width: 10,
    height: 10,
    child: CircularProgressIndicator(
        //strokeWidth: 2,
        ),
  ),
);

final progressIndicator = Container(
  width: 80,
  height: 80,
  decoration: BoxDecoration(
    color: Colors.black.withAlpha(188),
    borderRadius: BorderRadius.circular(10),
  ),
  padding: const EdgeInsets.all(22),
  child: const CircularProgressIndicator(
    backgroundColor: Colors.white,
  ),
);
const paddingBottomButton = EdgeInsets.fromLTRB(40, 0, 40, 20);

const inputBorderTable = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(25)),
  borderSide: BorderSide(
    color: colorBluePos,
  ),
);

const inputAddProduct = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  errorBorder: inputBorderRed,
  focusedErrorBorder: inputBorderRed,
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: colorBluePos,
      width: 0.5,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: colorBluePos,
      width: 0.5,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  ),
);
