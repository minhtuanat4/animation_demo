const baseVTCPayUrlAlpha = 'https://alpha.vtcpay.vn'; //'http://117.103.207.42';
const baseVTCPayUrlBeta = 'https://beta-mobile.vtcpay.vn';
const baseVTCPayUrlProd = 'https://api.vtcpay.vn';

const baseVTCPayFollowUrlAlpha =
    'http://alpha1.vtcpay.vn/screendata-api/api/ScreenData/';
const baseVTCPayFollowUrlBeta = '';
const baseVTCPayFollowUrlProd =
    'https://vtcpay.vn/screendata-api/api/ScreenData/';

const webBaseUrlAlpha = 'https://alpha.vtcpay.vn';
const webBaseUrlBeta = 'https://beta.vtcpay.vn';
const webBaseUrlProd = 'https://vtcpay.vn';

const serviceCodeTinderAlpha = 'STEAM';
const serviceCodeTinderBetaProd = 'TINDER';

const vtcRequestSystemKey = 'vtc-request-system';
const vtcRequestSystemValue = '6d692e7d03b39ee92d142ee8cfc80b8c';
const loginQRServiceID = 100001;
const loginQRServiceKey = 'a31b868dc29b4e2b9015e055306f09e6';
const loginServiceId = 100000;
const loginServiceKey = '14ee22eaba297944c96afdbe5b16c65b';
const secretKeyIgnoreCheckDevice = 'd8a61deca2ee4027bfbc0131b1cc79de';

const channel = 'vtcpay_channel';

//Image definitions
const String defaultImage = 'assets/images/icon_app.png';
const String vtcpayConditionImg = 'assets/images/vtcpro_vcoin.png';
const String logoPay = 'assets/images/logo.png';

const String htmlPart1 =
    r'<!DOCTYPE html><html><meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"><head><link href="https://fonts.googleapis.com/css?family=Be Vietnam" rel="stylesheet"><style>body {font-family: "Be Vietnam";} img {max-width:100%;} div {text-align: justify;} text-align: justify;</style><title></title></head><body><div>';
const String htmlPart2 = '</div></body></html>' '';

String serviceCodeTinder = '';

///Sử dụng trong lúc thanh toán
String routeName = '';

///Sử dụng khi thiết lập tài khoản đẩy Popup gợi ý cho các phương thức khác cho các Screen sử dụng
String routeNameSetupRemind = '';

///Sử dụng để biết thứ tự thiết lập tài khoản 1: Email -- 2: Bank -- 3: CMT
int routeIndexSetupRemind = 0;

String screenVerifyOTP = '';

bool openOTPAppAtVerifySecureScreen = false;

/// Sử dụng khi user click phone from Contacts của Tặng mảnh ghép
String phoneSelectFromContact = '';

String isWillPop = '';

///Địa danh, vị trí máy người dùng
String locationName = 'Unknow';
String? authenRequest = '';
String? assocationID = '';
String? tokenData = '';

//Ngân hàng check show security pci
const listBankCheckPci = [
  'Vietcombank',
  'BIDV',
  'DongABank',
  'Sacombank',
  'Vietinbank',
  'NamABank',
  'MB',
  'HDBank',
  'TPBank',
  'OCB'
];
const listBankDirectLink = [
  'BIDV',
  'MSB',
  'MB',
  'Sacombank',
];
const listBankExternalLink = [
  'Vietcombank',
];

/// CategoryId của sản phẩm
int? categoryId = 0;

// //Ngân hàng không phải napas
// const listBankNotNapas = ['BIDV', 'DongABank', 'Sacombank', 'Vietinbank', 'NamABank'];

//Bankcode Sacombank
const sacombankBankCode = 'Sacombank';

const bankNoiDia = 1;
const bankQuocTe = 2;
const allBank = 0;
const String enkey = 'gUjXn2r5u8x/A?D(G+KbPeShVmYp3s6v';
const String envect = 'Ks0qIx9w7wrt0YTs';

const String enkeySmartOTP = 'mUjKn3k9x1a/K?D(M-AnMaBsHmPc4g6x';
const String envectSmartOTP = 'Mo9dKx5w5kma6JUs';

//Dùng cho OTP
int? setSecureTypeId = 0;
String? setExtend = '';
String? setDataInfo = '';
int? secureTypeIDForgot = 1;
int setStepCreateAccount = 0;

String openedNotificationPoptoRouteName = '';

String routeNameOpenByQuickAction = '';

bool openedWhenAppIsKilled = false;

const requestTimeout = Duration(seconds: 30);

///Sau khi login thành công từ login_page hoặc nhấn nút back từ launch_page thì pop về routename này.
String loginPopRouteName = '';

///Dùng để xác định kích cỡ màn hình
int factoryScale = 2;

///Thông tin người dùng(mua hàng k đăng nhập)
String mobilePayment = '';
String emailPayment = '';

const String telSupport = '19001530';
bool isCheckShowPopup = false;
int countListBillSuggest = 0;

///VTCMall
//thông tin nhà cung cấp
//lưu thông tin bộ lọc
String moneyMinimum = '';
String moneyMax = '';
String keySearch = '';
List<bool>? saveCurrentOptions = <bool>[false, false, false];
Set<int?> saveChoosenCategory = {};
Set<int?> saveChoosenProviders = {};
Set<int?> saveChoosenMoneys = {};
bool filterPayMaill = false;
bool clearListPayMaill = false;

//ProductID thanh toán nhiều hóa đơn
int productIDMultiBillPayment = 3015; //alpha: =3015, thật: =2107

// IOS VERSION
int iOSVERSION = 1;

DateTime preBackPress = DateTime.now();

int appIsReviewVersionMode = 0;

String detailEzstudy =
    '<h4><strong>EZSTUDY</strong></h4>\n<br />\n EZSTUDY cung cấp kho bài giảng phong phú và sinh động theo tiêu chuẩn của Bộ Giáo dục cùng hàng trăm ngàn câu hỏi, kiểm tra giúp học sinh nâng cao năng lực từng ngày! Kết nối với đội ngũ giáo viên và các gia sư giỏi trên toàn quốc trong việc phát triển kho học liệu cũng như tương tác trực tiếp với học sinh qua các lớp học ảo. Ứng dụng EZStudy sử dụng trên máy tính, điện thoại thông minh hay máy tính bảng. EZStudy giúp học sinh trên mọi vùng miền đều có thể tiếp cận để củng cố kiến thức và rèn luyện các kỹ năng học tập. EEZSTUDY sử dụng trí tuệ nhân tạo trong việc xây dựng ra một hệ thống “nhiệm vụ học tập” được cá thể hóa cho từng học sinh, tương ứng với trình độ năng lực của từng học sinh, tạo cho học sinh sự hứng thú khi học và tiến bộ từng ngày trong suốt quá trình học tập.';

int indexNotificationTab = 0;

/// 1: Xác nhận đăng ký Pin Code ;  2: Quên Pin Code
String requestPathConfirmPin = '';

String currentRouteName = '';

bool routeScanQR = false;
String currentPaymentTechcomBank = '';

const durationTranslateIconCandy = 800;
bool linkTechcomBank = true;
