import 'package:get/get.dart';

class LoadingCtroller extends GetxController {
  RxBool isLoading = false.obs;

  void showLoading() {
    isLoading.value = true;
  }

  void showLoaded() {
    isLoading.value = false;
  }
}
