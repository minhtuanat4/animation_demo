import 'package:permission_handler/permission_handler.dart';

class Utils {
  static Future<PermissionStatus> checkPermission(Permission permission) async {
    var status = await permission.status;
    if (status != PermissionStatus.granted) {
      status = await permission.request();
    }
    return status;
  }
}
