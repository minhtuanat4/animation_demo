import 'package:animation_demo/getx_demo/common/user_management.dart';
import 'package:animation_demo/getx_demo/controller/loading_controller.dart';
import 'package:get/get.dart';

import '../../../service/api_service.dart';
import '../model/telco_model.dart';

class SecondService {
  UserManagement get userManagement => Get.find<UserManagement>();
  ApiService get apiServive => Get.find<ApiService>();
  LoadingCtroller get loadingCtroller => Get.find<LoadingCtroller>();
  Future<TelCoModel?> telcoPrepaid() async {
    TelCoModel? objectResponse;

    final accountName = userManagement.accountName;

    final dynamic telcoPrepaid = await apiServive.sendRequest(
      requestFromBaseUrl: RequestFromBaseUrl.requestFromVTCPay,
      requestMethod: RequestMethod.requestPost,
      requestPath: 'Ecom/v1.0/GetTopupTelcoPrePaid',
      params: {'AccountName': accountName},
    );

    if (telcoPrepaid != null) {
      objectResponse = TelCoModel.fromJson(telcoPrepaid);
    } else {
      objectResponse = null;
    }

    return objectResponse;
  }
}
