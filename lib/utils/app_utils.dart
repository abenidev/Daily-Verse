import 'package:daily_verse/helpers/query_helper.dart';
import 'package:daily_verse/helpers/shared_prefs_helper.dart';
import 'package:daily_verse/models/app_data.dart';
import 'package:daily_verse/providers/current_verse_list_provider.dart';
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
