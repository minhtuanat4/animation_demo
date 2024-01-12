import 'package:animation_demo/common/definition.dart';
import 'package:get/get.dart';

class AppConfig extends GetxService {
  late String _appTitle;
  String get appTitle => _appTitle;
  late String _buildFlavor;
  String get buildFlavor => _buildFlavor;
  late String _vtcPayUrl;

  String get vtcPayUrl => _vtcPayUrl;
  late List<int> _categoryTypesInPaymentDetail;
  List<int> get categoryTypesInPaymentDetail => _categoryTypesInPaymentDetail;
  late String _checkBackgroundGarenaCard;
  String get checkBackgroundGarenaCard => _checkBackgroundGarenaCard;
  late String _checkBackgroundFuntapCard;
  String get checkBackgroundFuntapCard => _checkBackgroundFuntapCard;
  late String _vtcPayFollowUrl;
  String get vtcPayFollowUrl => _vtcPayFollowUrl;
  late String _vtcWebUrl;
  String get vtcWebUrl => _vtcWebUrl;
  late String _oneSignalAppId;
  String get oneSignalAppId => _oneSignalAppId;

  ///0 - All, 1 - AppleStore, 2 - GooglePlay, 3 - HuaweiStore, 4 - SamsungStore, 5 - Oppo, 6 - Vivo, 7 - Xiaomi
  late int _storeConfig;
  int get storeConfig => _storeConfig;
  late bool _linkGooglePayment;
  bool get linkGooglePayment => _linkGooglePayment;
  // true: show, false: not show

  late bool _showLogApi;
  bool get showLogApi => _showLogApi;
  @override
  void onInit() {
    _appTitle = 'VTCPay';
    _buildFlavor = 'Production';
    _vtcPayUrl = baseVTCPayUrlProd;
    _vtcPayFollowUrl = baseVTCPayFollowUrlProd;
    _vtcWebUrl = webBaseUrlProd;
    _categoryTypesInPaymentDetail = const [19, 20];
    _checkBackgroundGarenaCard = 'thegarena';
    _checkBackgroundFuntapCard = 'thefuncard';
    _linkGooglePayment = false;
    _checkBackgroundGarenaCard = 'theso';
    _checkBackgroundFuntapCard = 'funtap';
    _oneSignalAppId = '79fe19ee-6e61-11e5-9e4a-07ce7d0feafc';
    _storeConfig = 2;
    _showLogApi = true;
    super.onInit();
  }

  void init({
    required String appTitle,
    required String vtcPayUrl,
    required String vtcPayFollowUrl,
    required String vtcWebUrl,
    required String buildFlavor,
    required List<int> categoryTypesInPaymentDetail,
    String checkBackgroundGarenaCard = 'theso',
    String checkBackgroundFuntapCard = 'funtap',
    String oneSignalAppId = '79fe19ee-6e61-11e5-9e4a-07ce7d0feafc',
    int storeConfig = 2,
    bool linkGooglePayment = false,
    bool showLogApi = true,
  }) {
    _appTitle = appTitle;
    _vtcPayUrl = vtcPayUrl;
    _vtcPayFollowUrl = vtcPayFollowUrl;
    _vtcWebUrl = vtcWebUrl;
    _buildFlavor = buildFlavor;
    _categoryTypesInPaymentDetail = categoryTypesInPaymentDetail;
    _checkBackgroundGarenaCard = checkBackgroundGarenaCard;
    _checkBackgroundFuntapCard = checkBackgroundFuntapCard;
    _storeConfig = storeConfig;
    _storeConfig = storeConfig;
    _linkGooglePayment = linkGooglePayment;
    _showLogApi = showLogApi;
    _oneSignalAppId = oneSignalAppId;
  }
}
