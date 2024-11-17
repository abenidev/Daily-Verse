import 'package:daily_verse/helpers/query_helper.dart';
import 'package:daily_verse/helpers/shared_prefs_helper.dart';
import 'package:daily_verse/models/app_data.dart';
import 'package:daily_verse/providers/current_verse_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

updateVerseList(WidgetRef ref, int currentBookNum, int currentChapterNum, BookTranslationType currentBookTransType) {
  ref.read(currentVerseListStateNotifierProvider.notifier).setVerseList(
        ref,
        currentBookNum,
        currentChapterNum,
        currentBookTransType,
      );
  AppData appData = SharedPrefsHelper.getAppData();
  SharedPrefsHelper.setAppData(appData.copyWith(currentBookNum: currentBookNum, currentChapterNum: currentChapterNum));
}

Color? fromHexString(String input) {
  String normalized = input.replaceFirst('#', '');

  if (normalized.length == 6) {
    normalized = 'FF$normalized';
  }

  if (normalized.length != 8) {
    return null;
  }

  final int? decimal = int.tryParse(normalized, radix: 16);
  return decimal == null ? null : Color(decimal);
}
