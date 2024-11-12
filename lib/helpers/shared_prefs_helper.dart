import 'package:daily_verse/constants/app_strings.dart';
import 'package:daily_verse/constants/shared_pref_consts.dart';
import 'package:nb_utils/nb_utils.dart';

class SharedPrefsHelper {
  SharedPrefsHelper._();

  static Future<bool> setAppTheme(String newAppTheme) async {
    return setValue(kAppTheme, newAppTheme);
  }

  static String getAppTheme() {
    return getStringAsync(kAppTheme, defaultValue: ksystemTheme);
  }

  //isFirebaseInited
  static Future<bool> setIsFirebaseInited(bool newVal) async {
    return await setValue(kIsFirebaseInited, newVal);
  }

  static bool isFirebaseInited() {
    return getBoolAsync(kIsFirebaseInited, defaultValue: false);
  }

  // isIntroShown
  static Future<bool> setIsIntroShown(bool newVal) async {
    return await setValue(kIsIntroShownKey, newVal);
  }

  static bool isIntroShown() {
    return getBoolAsync(kIsIntroShownKey, defaultValue: false);
  }
}
