import 'package:daily_verse/firebase_options.dart';
import 'package:daily_verse/helpers/firebase_messaging.dart';
import 'package:daily_verse/helpers/shared_prefs_helper.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class FirebaseHelper {
  FirebaseHelper._();

  static Future<void> logScreenView(String screenName, String screenClass) async {
    bool isFirebaseInited = SharedPrefsHelper.isFirebaseInited();
    if (isFirebaseInited) {
      final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
      analytics.setAnalyticsCollectionEnabled(true);
      await analytics.logEvent(
        name: 'screen_view',
        parameters: {
          'firebase_screen': screenName,
          'firebase_screen_class': screenClass,
        },
      );
    }
  }

  static Future<void> logAnalyticsEvent({required String eventName, Map<String, Object>? parameters}) async {
    debugPrint('eventName: ${eventName} || parameters: ${parameters}');

    if (kReleaseMode) {
      bool isFirebaseInited = SharedPrefsHelper.isFirebaseInited();
      if (isFirebaseInited) {
        final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
        analytics.setAnalyticsCollectionEnabled(true);
        debugPrint('------------------- logging to analytics...');
        await analytics.logEvent(
          name: eventName,
          parameters: parameters,
        );
      }
    }
  }

  static Future<void> initFirebase() async {
    debugPrint('Initializing firebase -----------------');
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      //crashlytics
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };
      // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
      //messaging
      await FirebaseMessagingApi().initNotifications();
    } catch (e) {
      debugPrint('error in initFirebase: ${e}');
    }
  }
}
