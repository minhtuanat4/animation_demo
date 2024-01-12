import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animation_demo/common/definition.dart';
import 'package:animation_demo/common/strings.dart';
import 'package:animation_demo/common/utils.dart';
import 'package:animation_demo/getx_demo/common/app_config.dart';
import 'package:animation_demo/getx_demo/common/user_management.dart';
import 'package:animation_demo/getx_demo/controller/loading_controller.dart';
import 'package:get/get.dart';

class VTCServices {
  static const String APP_SERVICE = '/mobileapis-appvtcpay/';
  static const String EVENT_HAIKHE = '/PickingStarFruitEvent/';
  static const String EVENT_SERVICE = '/mobileapis-appvtcpay-events/';
}

class EnvironmentType {
  static const int web = 1;
  static const int app = 2;
}

enum RequestMethod { requestPost, requestGet }

enum RequestFromBaseUrl { requestFromVTCPay, requestFromVTCPayFollow }

class ApiService extends GetxService {
  final appConfig = Get.find<AppConfig>();
  HttpClient httpClient = HttpClient();
  LoadingCtroller get loadingCtroller => Get.find<LoadingCtroller>();

  ///Stream chứa thông tin avatar
  // ignore: close_sinks
  StreamController<String?> linkAvatarStreamController =
      StreamController<String?>.broadcast();
  Stream<String?> get linkAvatar => linkAvatarStreamController.stream;

  ///Stream chứa thông tin balance
  // ignore: close_sinks
  StreamController<int> balanceStreamController =
      StreamController<int>.broadcast();
  Stream<int> get balance => balanceStreamController.stream;

  // ApiServiceOld({BuildContext? context}) : bcontext = context {

  // }

  void streamChangeBalance({required int balance}) {
    if (balance >= 0) {
      balanceStreamController.add(balance);
    }
  }

  ///Các tham số đã có, k cần truyền: AccountName; AccessToken; RequestID; DeviceID; DeviceDetail; deviceType
  Future<dynamic> sendRequest({
    required RequestFromBaseUrl requestFromBaseUrl,
    required RequestMethod requestMethod,
    required String requestPath,
    required Map<String, dynamic> params,
    String serviceName = VTCServices.APP_SERVICE,
    String? directLink,
  }) async {
    loadingCtroller.showLoading();
    dynamic jsonResponse;
    var reply = '';
    var logMsg = '';
    var urlRequest = '';
    final headerParams = <String, dynamic>{};
    // final bcontext = UserManagement().navigatorKey!.currentContext!;

    try {
      final _devicebrowser =
          Platform.isIOS ? 'VTCAPP-ios;OS:ios' : 'VTCAPP-Android;OS:Android';

      final _deviceSerial = UserManagement().deviceSerial;
      final _systemVersion = UserManagement().systemVersion;
      final _deviceName = UserManagement().deviceName;

      final oSName = Platform.isIOS ? 'IOS' : 'Android';
      final deviceDetail =
          'fingerprint:$_deviceSerial-$_deviceSerial;devicebrowser:$_devicebrowser-$_systemVersion;device:$_deviceName;devicetype:Mobile;resolution:Mobile';
      if (!params.containsKey('AccountName')) {
        params['AccountName'] = UserManagement().accountName;
      }

      if (UserManagement().accessToken != null &&
          UserManagement().accessToken!.isNotEmpty) {
        params['AccessToken'] = UserManagement().accessToken;
      }
      params['OSName'] = oSName;
      if (!params.containsKey('RequestID')) {
        params['RequestID'] = DateTime.now().millisecondsSinceEpoch.toString();
      }

      params['DeviceID'] = _deviceSerial;
      params['DeviceDetail'] = deviceDetail;
      params['Sign'] = params.containsKey('Sign') ? params['Sign'] : '';

      params['DeviceType'] = Platform.isIOS
          ? 3
          : Platform.isAndroid
              ? 4
              : -1;
      params['EnvironmentType'] = EnvironmentType.app;

      HttpClientRequest httpClientRequest;

      HttpClientResponse httpClientResponse;
      if (directLink != null && directLink.isNotEmpty) {
        urlRequest = directLink;
      } else {
        if (requestFromBaseUrl == RequestFromBaseUrl.requestFromVTCPay) {
          urlRequest = '${appConfig.vtcPayUrl}$serviceName$requestPath';
        } else if (requestFromBaseUrl ==
            RequestFromBaseUrl.requestFromVTCPayFollow) {
          urlRequest = '${appConfig.vtcPayFollowUrl}$requestPath';
        }
      }

      if (requestMethod == RequestMethod.requestPost) {
        httpClientRequest = await httpClient
            .postUrl(Uri.parse(urlRequest))
            .timeout(requestTimeout);
      } else {
        httpClientRequest = await httpClient
            .getUrl(Uri.parse(urlRequest))
            .timeout(requestTimeout);
      }
      httpClientRequest.headers.set('content-type', 'application/json');
      httpClientRequest.headers.set(vtcRequestSystemKey, vtcRequestSystemValue);
      headerParams['content-type'] = 'application/json';
      headerParams[vtcRequestSystemKey] = vtcRequestSystemValue;
      if (UserManagement().accessToken != null &&
          UserManagement().accessToken!.isNotEmpty) {
        headerParams['Authorization'] =
            'Bearer ${UserManagement().accessToken}';
        httpClientRequest.headers
            .set('Authorization', 'Bearer ${UserManagement().accessToken}');
      }
      if (requestMethod == RequestMethod.requestPost) {
        httpClientRequest.add(utf8.encode(json.encode(params)));
      }
      httpClientResponse =
          await httpClientRequest.close().timeout(requestTimeout);

      for (final paramKey in params.keys) {
        if (paramKey.contains('base64') || paramKey.contains('ImageName')) {
          params[paramKey] = 'replace_cho_do_dai_dong';
        }
      }
      reply = await httpClientResponse.transform(utf8.decoder).join();
      if (httpClientResponse.statusCode == 200 && reply.isNotEmpty) {
        jsonResponse = json.decode(reply);
        if (!urlRequest.contains('AccountSession_ViewPage') &&
            reply.contains('ResponseCode') &&
            jsonResponse['ResponseCode'] != null &&
            jsonResponse['ResponseCode'] < 0) {
          // final bcontext = UserManagement().navigatorKey!.currentContext!;
          final desErr = reply.contains('Description')
              ? jsonResponse['Description'] ?? Strings.systemBusy
              : Strings.systemBusy;
        }
      } else {
        jsonResponse = null;
        if (!urlRequest.contains('AccountSession_ViewPage')) {}
      }
      //\nHEADERS:${json.encode(httpClientRequest.headers)}
      // ![
      //   'MenuApp_GetByCondition',
      //   'AppNews_GetDetailById',
      //   'Banner_GetByCondition',
      //   'MenuApp_GetByCondition'
      // ].contains(requestPath)
      if (appConfig.showLogApi) {
        logMsg =
            '\n----------------------------------------------------\nAPI:$urlRequest\nHEADERS:${json.encode(headerParams)}\nPARAMS:${json.encode(params)}\nRESPONSE:$reply\n----------------------------------------------------\r\n';
        // Debug.logMessage(trace: StackTrace.current, message: logMsg);
      }
      loadingCtroller.showLoaded();
      return jsonResponse;
    } catch (e) {
      loadingCtroller.showLoaded();
      if (await Utils.checkNetwork()) {
        if (appConfig.showLogApi) {
          return jsonResponse;
        } else {
          // final bContext = UserManagement().navigatorKey?.currentContext;
          // if (bContext != null && !isCheckShowPopup) {
          //   isCheckShowPopup = true;
          // }
        }
      }
    }
  }
}
