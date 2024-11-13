import 'package:daily_verse/helpers/query_helper.dart';
import 'package:daily_verse/models/verse.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentVerseListStateNotifierProvider = StateNotifierProvider<CurrentVerseListStateNotifier, List<Verse>>((ref) {
  return CurrentVerseListStateNotifier();
});

class CurrentVerseListStateNotifier extends StateNotifier<List<Verse>> {
  CurrentVerseListStateNotifier() : super([]);

  void setVerseList(WidgetRef ref, int book, int chapter, BookTranslationType bookTranslationType) {
    List<Verse> verseList = BoxQueryHelper.getVerseFromBookAndChapterNumber(book, chapter, bookTranslationType);
    state = [...verseList];
  }
}
