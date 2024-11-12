import 'package:daily_verse/constants/app_strings.dart';
import 'package:daily_verse/helpers/shared_prefs_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appearanceProvider = StateNotifierProvider<AppearanceStateNotifier, String>((ref) {
  return AppearanceStateNotifier();
});

class AppearanceStateNotifier extends StateNotifier<String> {
  AppearanceStateNotifier() : super(ksystemTheme);

  loadAppearance() {
    String appTheme = SharedPrefsHelper.getAppTheme();
    state = appTheme;
  }

  changeAppearance(String newMode) {
    SharedPrefsHelper.setAppTheme(newMode);
    state = newMode;
  }
}

getThemeMode(WidgetRef ref) {
  String themeMode = ref.watch(appearanceProvider);

  switch (themeMode) {
    case ksystemTheme:
      return ThemeMode.system;
    case klightTheme:
      return ThemeMode.light;
    case kdarkTheme:
      return ThemeMode.dark;
  }
}
