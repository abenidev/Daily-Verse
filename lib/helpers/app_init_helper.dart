import 'package:daily_verse/helpers/device_info_helper.dart';
import 'package:daily_verse/helpers/firebase_helper.dart';
import 'package:daily_verse/helpers/local_notifications.dart';
import 'package:daily_verse/helpers/shared_prefs_helper.dart';
import 'package:daily_verse/screens/home_screen.dart';
import 'package:daily_verse/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:nb_utils/nb_utils.dart';

class AppInit {
  AppInit._();

  static Future<void> initMain() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await initialize();
    await DeviceInfoHelper.init();
    //firebase
    bool isFirebaseInited = SharedPrefsHelper.isFirebaseInited();
    if (!isFirebaseInited) {
      bool hasInternet = await InternetConnection().hasInternetAccess;
      if (hasInternet) {
        await FirebaseHelper.initFirebase();
        await SharedPrefsHelper.setIsFirebaseInited(true);
      }
    } else {
      await FirebaseHelper.initFirebase();
    }
  }

  static Future<void> initLocalNotif() async {
    //local notifications
    await LocalNotificationshelper.configureLocalTimeZone();
    await LocalNotificationshelper.init();

    //check local notification permission
    await LocalNotificationshelper.isAndroidPermissionGranted();
    await LocalNotificationshelper.requestPermissions();
  }

  static Future<void> initAppData(BuildContext context, WidgetRef ref) async {
    bool isIntroShown = SharedPrefsHelper.isIntroShown();

    //----------------------------------------Notificaiton
    //*General Reminder
    // bool isReminderNotifEnabled = SharedPrefsHelper.getIsReminderNotificationEnabled();
    // ref.read(isReminderNotificationEnabledProvider.notifier).state = isReminderNotifEnabled;
    // DateTime reminderNotificationDate = SharedPrefsHelper.getReminderNotificationTimestamp();
    // ref.read(reminderNotificationDateProvider.notifier).state = reminderNotificationDate;

    // //
    // if (ref.read(attemptStateProvider) != null && isReminderNotifEnabled) {
    //   if (context.mounted) {
    //     AppNotificationHelper.schedule(context, kReminderNotifId, reminderNotificationDate.hour, reminderNotificationDate.minute);
    //   }
    // } else {
    //   await AppNotificationHelper.cancel(kReminderNotifId);
    // }

    //----------------------------------------Notificaiton

    if (context.mounted) {
      if (!isIntroShown) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnboardingScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    }
  }
}
