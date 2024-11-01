import 'dart:async';

import 'package:animation_demo/resource/definition_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ButtonStyleEnum {
  CircleShape,
  RRectangle,
}

class EposButtonCustom extends StatelessWidget {
  final ButtonStyleEnum buttonStyleEnum;
  final VoidCallback onPressed;
  final Color fgColor;
  final Color bgColor;
  final Color shadowColor;
  final double? width;
  final double? height;
  final double elevation;
  final double widthBorder;
  final double radiusRRectangle;
  final EdgeInsetsGeometry? padding;
  final Alignment? alignmentChild;
  final Widget child;
  final bool isBorder;
  final Color borderColor;
  final Size? miniSize;

  const EposButtonCustom({
    required this.buttonStyleEnum,
    required this.onPressed,
    required this.child,
    this.fgColor = Colors.black,
    this.bgColor = Colors.transparent,
    this.shadowColor = Colors.transparent,
    this.alignmentChild,
    this.width,
    this.height,
    this.elevation = 0,
    this.widthBorder = 1,
    this.radiusRRectangle = 28,
    this.isBorder = false,
    this.padding = const EdgeInsets.symmetric(vertical: 28),
    this.borderColor = colorPayBlack,
    this.miniSize,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final shapeButton = buttonStyleEnum == ButtonStyleEnum.RRectangle
        ? RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(radiusRRectangle),
            ),
          )
        : const CircleBorder();
    final buttonStyle = ElevatedButton.styleFrom(
      maximumSize: miniSize,
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      surfaceTintColor: Colors.transparent,
      shadowColor: shadowColor,
      elevation: elevation,
      alignment: alignmentChild,
      minimumSize: const Size(0, 0),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      padding: padding,
      shape: shapeButton,
      side: isBorder
          ? BorderSide(color: borderColor, width: widthBorder)
          : BorderSide.none,
    ).copyWith(
      overlayColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.black12;
          }

          return Colors.black12; // Defer to the widget's default.
        },
      ),
    );
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 1),
          child: child,
        ),
      ),
    );
  }
}

mixin EposPopup {
  static Future<void> show({
    required BuildContext context,
    String? titleNoti,
    String? des,
    bool isBtnOk = false,
    String textOk = 'Đồng ý',
    VoidCallback? onOk,
    bool isBtnClose = true,
    String textClose = 'Đóng',
    VoidCallback? onClose,
    Widget? content,
    bool canPop = true,
    bool isPrintBill = false,
    VoidCallback? onPrintBill,
  }) async {
    final closeWidget = EposButtonCustom(
      miniSize: const Size(0, 45),
      buttonStyleEnum: ButtonStyleEnum.RRectangle,
      bgColor: colorWhite,
      isBorder: true,
      borderColor: colorBlackPos,
      shadowColor: colorWhite,
      radiusRRectangle: 24,
      padding: const EdgeInsets.symmetric(vertical: 24),
      onPressed: onClose ??
          () {
            Navigator.of(context).pop();
          },
      child: Text(
        textClose,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: Get.theme.textTheme.bodyLarge?.copyWith(
          color: colorBlackPos,
        ),
      ),
    );

    final okWidget = EposButtonCustom(
      buttonStyleEnum: ButtonStyleEnum.RRectangle,
      miniSize: const Size(0, 45),
      bgColor: colorBluePos,
      radiusRRectangle: 24,
      padding: const EdgeInsets.symmetric(vertical: 24),
      onPressed: onOk ??
          () {
            Navigator.of(context).pop();
          },
      child: Text(
        textOk,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: Get.theme.textTheme.bodyLarge?.copyWith(
          color: colorWhite,
        ),
      ),
    );

    final popup = AlertDialog(
      contentPadding: EdgeInsets.all(0),
      backgroundColor: Colors.transparent,
      content: PopScope(
        canPop: canPop,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    (titleNoti ?? 'Thông báo').toUpperCase(),
                    textAlign: TextAlign.center,
                    style: Get.theme.textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w700, color: colorBluePos),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 10),
                  content ?? const SizedBox(),
                  if (des == null)
                    const SizedBox()
                  else
                    Text(
                      des,
                      style: Get.theme.textTheme.bodyLarge!
                          .copyWith(color: colorBlackPos),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (isPrintBill)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: EposButtonCustom(
                        isBorder: true,
                        borderColor: colorBluePos,
                        widthBorder: 3,
                        buttonStyleEnum: ButtonStyleEnum.RRectangle,
                        miniSize: const Size(0, 50),
                        width: 200,
                        radiusRRectangle: 24,
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        onPressed: onPrintBill ?? () {},
                        child: Text(
                          'In hoá đơn',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Get.theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorBluePos,
                          ),
                        ),
                      ),
                    )
                  else
                    const SizedBox(),
                  if (isPrintBill)
                    SizedBox(width: 180, child: closeWidget)
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (isBtnClose) Expanded(child: closeWidget),
                        if (isBtnOk) const SizedBox(width: 10),
                        if (isBtnOk) Expanded(child: okWidget)
                      ],
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return popup;
      },
    );
  }

  static Future<void> showPrintBill({
    required String bossUser,
    String? titleNoti,
    Widget? content,
    bool canPop = true,
    VoidCallback? onPrintBill,
  }) async {
    unawaited(
      Get.dialog(
        barrierDismissible: false,
        Dialog(
          child: PopScope(
            canPop: canPop,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            (titleNoti ?? 'Thông báo').toUpperCase(),
                            textAlign: TextAlign.center,
                            style: Get.theme.textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colorBluePos),
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: const Icon(Icons.close))),
                        ],
                      ),
                      content ?? const SizedBox(),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        'Cảm ơn quý khách - Hotline: $bossUser',
                        style: Get.theme.textTheme.bodySmall!.copyWith(
                            color: colorBlackPos, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Powered by VTC Pay',
                        style: Get.theme.textTheme.bodySmall!.copyWith(
                            color: colorBlackPos, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      EposButtonCustom(
                        isBorder: true,
                        borderColor: colorBluePos,
                        widthBorder: 3,
                        buttonStyleEnum: ButtonStyleEnum.RRectangle,
                        miniSize: const Size(0, 50),
                        width: 160,
                        radiusRRectangle: 22,
                        padding: const EdgeInsets.symmetric(vertical: 22),
                        onPressed: onPrintBill ?? () {},
                        child: Text(
                          'In',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Get.theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorBluePos,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> popupForPayment({
    required Widget content,
    Widget? footer,
    String? titleNoti,
    bool isBtnOk = false,
    String textOk = 'Đồng ý',
    VoidCallback? onOk,
    bool isBtnClose = true,
    String textClose = 'Đóng',
    VoidCallback? onClose,
    bool canPop = true,
  }) async {
    final widthBtn = Get.width / 3.2;
    final okWidget = EposButtonCustom(
      buttonStyleEnum: ButtonStyleEnum.RRectangle,
      bgColor: colorBluePos,
      radiusRRectangle: 24,
      width: widthBtn,
      padding: const EdgeInsets.symmetric(vertical: 24),
      onPressed: onOk ??
          () {
            Get.back();
          },
      child: Text(
        textOk,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: Get.theme.textTheme.headlineMedium
            ?.copyWith(color: colorWhite, fontWeight: FontWeight.bold),
      ),
    );
    final closeWidget = EposButtonCustom(
      buttonStyleEnum: ButtonStyleEnum.RRectangle,
      bgColor: Colors.transparent,
      isBorder: true,
      width: widthBtn,
      radiusRRectangle: 24,
      padding: const EdgeInsets.symmetric(vertical: 24),
      onPressed: onClose ??
          () {
            Get.back();
          },
      child: Text(
        textClose,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: Get.theme.textTheme.headlineMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
    unawaited(
      Get.dialog(
        barrierDismissible: !(isBtnOk && isBtnClose),
        Dialog(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          child: PopScope(
            canPop: canPop,
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: (titleNoti ?? '').isEmpty
                                        ? const SizedBox()
                                        : Text(
                                            titleNoti ?? 'THÔNG BÁO',
                                            style: Get
                                                .theme.textTheme.headlineMedium!
                                                .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: colorBluePos,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  GestureDetector(
                                    onTap: onClose ??
                                        () {
                                          Get.back();
                                        },
                                    child: const Icon(Icons.close),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: (titleNoti ?? '').isEmpty ? 0 : 10),
                          // Image.asset(AppImage.internetConnection, height: 30),
                          content,

                          if (isBtnOk && isBtnClose) ...[
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                closeWidget,
                                okWidget,
                              ],
                            )
                          ] else if (isBtnOk) ...[
                            const SizedBox(
                              height: 20,
                            ),
                            okWidget
                          ] else if (isBtnClose) ...[
                            const SizedBox(
                              height: 20,
                            ),
                            closeWidget
                          ],
                        ],
                      ),
                    ),
                    footer ?? const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showPopup({
    required String textOK,
    required VoidCallback onOK,
    String? title,
    Widget? content,
    String? message,
    String? textCancel,
    VoidCallback? onCancel,
    bool? isDismissible,
  }) {
    return Get.dialog(
      barrierDismissible: isDismissible ?? false,
      PopScope(
        canPop: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(16.5),
                    child: Column(
                      children: [
                        Text(
                          title?.toUpperCase() ?? 'Thông báo',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16.5,
                              color: colorBluePos,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(height: 10),
                        if (content != null) content,
                        if (content == null)
                          Text(
                            message ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: colorBlackPos, fontSize: 15),
                          ),
                        const SizedBox(height: 20),
                        //Buttons
                        Row(
                          children: [
                            if (textCancel != null)
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(0, 45),
                                    backgroundColor: colorWhite,
                                    side: const BorderSide(
                                      width: 1,
                                      color: colorBlackPos,
                                    ),
                                    shadowColor: colorWhite,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  onPressed: onCancel,
                                  child: Text(
                                    textCancel,
                                    textScaleFactor: 1,
                                    style: const TextStyle(
                                        color: colorBlackPos, fontSize: 15),
                                  ),
                                ),
                              ),
                            if (textCancel != null) const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(0, 45),
                                  backgroundColor: colorBluePos,
                                  shadowColor: colorWhite,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                onPressed: onOK,
                                child: Text(
                                  textOK,
                                  style: const TextStyle(
                                      color: colorWhite, fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showPopupSuccess(String success,
      {VoidCallback? onOk,
      String titleOk = 'Tiếp tục',
      String? tilleCancel,
      VoidCallback? onCancel,
      bool isDismissble = true}) async {
    unawaited(showPopup(
        isDismissible: isDismissble,
        title: 'Thông báo',
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/employee/icon-add-success.png',
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              success,
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: colorBlackPos,
              ),
            )
          ],
        ),
        textCancel: tilleCancel,
        onCancel: onCancel ??
            () {
              Get.back(closeOverlays: true);
            },
        textOK: titleOk,
        onOK: onOk ??
            () {
              Get.back();
            }));
  }

  static Future<void> showPopupImage({Widget? content}) {
    return Get.dialog(
      barrierDismissible: true,
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(16.5),
                  child: Column(
                    children: [
                      if (content != null) content,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> noticeSamePikachu(VoidCallback onOk) async {
    Get.dialog(
        barrierDismissible: false,
        Dialog(
          backgroundColor: Colors.transparent,
          child: WillPopScope(
            onWillPop: () async => false,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(
                    child: Text("No Internet Connection"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Image.asset(AppImage.internetConnection,height:30),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Please check your connection again,or connect to wi-fi.",
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  InkWell(
                    onTap: onOk,
                    child: Center(
                      child: Container(
                        height: 50,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: const Text(
                          "Refresh",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
