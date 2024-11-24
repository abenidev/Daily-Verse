import 'package:daily_verse/helpers/query_helper.dart';
import 'package:daily_verse/helpers/shared_prefs_helper.dart';
import 'package:daily_verse/models/app_data.dart';
import 'package:daily_verse/models/bookmark.dart';
import 'package:daily_verse/models/verse.dart';
import 'package:daily_verse/providers/current_verse_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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

List<Bookmark> getBookMarksFromVersesList(List<Verse> verses) {
  List<Bookmark> bookmarks = [];
  for (Verse verse in verses) {
    for (int v in verse.v) {
      bookmarks.add(Bookmark(bookNum: verse.bnu, chapterNum: verse.ch, verseNum: v, createdAt: DateTime.now()));
    }
  }
  return bookmarks;
}

String getFormattedDateStr(DateTime date) {
  final DateFormat formatter = DateFormat('yMMMEd');
  final String formatted = formatter.format(date);
  return formatted;
}

bool isBookMarkContained(List<Bookmark> bookmarkList, Bookmark toBeFoundBookmark) {
  for (Bookmark bookmark in bookmarkList) {
    if (bookmark.bookNum == toBeFoundBookmark.bookNum && bookmark.chapterNum == toBeFoundBookmark.chapterNum && bookmark.verseNum == toBeFoundBookmark.verseNum) {
      return true;
    }
  }

  return false;
}
