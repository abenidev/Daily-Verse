import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoHelper {
  DeviceInfoHelper._();
  static late AndroidDeviceInfo androidInfo;

  static Future<void> init() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    androidInfo = await deviceInfo.androidInfo;
  }

  static bool isAboveApi12() {
    int sdkInt = androidInfo.version.sdkInt;
    return sdkInt >= 31;
  }
}
