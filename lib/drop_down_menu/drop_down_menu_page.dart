  // return Container(
    //   width: Get.width,
    //   child: PopupMenuButton(
    //     onSelected: (value) => controller.chooseType == value,
    //     padding: const EdgeInsets.all(0),
    //     position: PopupMenuPosition.under,
    //     shape: const RoundedRectangleBorder(
    //       borderRadius: BorderRadius.only(
    //         bottomLeft: Radius.circular(20),
    //         bottomRight: Radius.circular(20),
    //       ),
    //     ),
    //     constraints: BoxConstraints(minWidth: Get.width),
    //     itemBuilder: (context) {
    //       return controller.listTypeTraffic
    //           .map((e) => PopupMenuItem(
    //                 height: 35,
    //                 value: e,
    //                 onTap: () {
    //                   controller.chooseType = e;
    //                 },
    //                 padding: EdgeInsets.zero,
    //                 child: Container(
    //                   alignment: Alignment.centerLeft,
    //                   padding: const EdgeInsets.symmetric(horizontal: 16),
    //                   color: controller.chooseType == e
    //                       ? const Color(0xffEAF6FF)
    //                       : null,
    //                   height: 35,
    //                   child: Text(e.name),
    //                 ),
    //               ))
    //           .toList();
    //     },
    //     child: SizedBox(
    //       height: 50,
    //       width: Get.width,
    //       child: Card(
    //         elevation: 3,
    //         shadowColor: Colors.grey.shade100,
    //         margin: const EdgeInsets.all(0),
    //         color: Colors.white,
    //         shape:
    //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    //         child: Padding(
    //           padding: const EdgeInsets.only(bottom: 4, right: 12, left: 12),
    //           child: Align(
    //             alignment: Alignment.centerLeft,
    //             child: GetBuilder<OpenCloseProductController>(builder: (_) {
    //               return Text(
    //                 controller.chooseType.name,
    //                 style: const TextStyle(
    //                   color: Colors.blue,
    //                   fontSize: 16,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               );
    //             }),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );