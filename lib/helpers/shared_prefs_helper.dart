import 'package:daily_verse/constants/app_nums.dart';
import 'package:daily_verse/constants/app_strings.dart';
import 'package:daily_verse/constants/shared_pref_consts.dart';
import 'package:daily_verse/models/app_data.dart';
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

  //-------------------- isTranslationsLoaded------------------------------

  static Future<bool> setIsTranslationsLoaded(bool newVal) async {
    return await setValue(kIsTranslationsLoadedSharedPrefKey, newVal);
  }

  static bool isTranslationsLoaded() {
    return getBoolAsync(kIsTranslationsLoadedSharedPrefKey, defaultValue: false);
  }

  //-------------------- appData------------------------------
  static Future<bool> setAppData(AppData newAppData) async {
    return await setValue(kAppDataKey, newAppData.toMap());
  }

  static AppData getAppData() {
    return AppData.fromMap(
      getJSONAsync(
        kAppDataKey,
        defaultValue: AppData(
          currentBookNum: defaultCurrentBookNum,
          currentChapterNum: defaultCurrentChapterNum,
          currentVerseNum: defaultCurrentVerseNum,
        ).toMap(),
      ),
    );
  }
}
