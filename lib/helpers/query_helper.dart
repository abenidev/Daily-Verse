import 'package:daily_verse/constants/app_strings.dart';
import 'package:daily_verse/helpers/object_box_helper.dart';
import 'package:daily_verse/models/verse.dart';
import 'package:daily_verse/objectbox.g.dart';

enum BookTranslationType { niv, amv }

BookTranslationType? getBookTranslationTypeFromString(String bookTranslationTypeStr) {
  switch (bookTranslationTypeStr) {
    case kNivBookTranslation:
      return BookTranslationType.niv;
    case kAmvBookTranslation:
      return BookTranslationType.amv;
    default:
      return null;
  }
}

extension MyBookTranslationTypeExtension on BookTranslationType {
  String? get name {
    switch (this) {
      case BookTranslationType.niv:
        return kNivBookTranslation;
      case BookTranslationType.amv:
        return kAmvBookTranslation;
      default:
        return null;
    }
  }
}

class BoxQueryHelper {
  BoxQueryHelper._();

  static Box<Verse> getVerseBox(BookTranslationType bookTranslationType) {
    switch (bookTranslationType) {
      case BookTranslationType.niv:
        return BoxLoader.nivVerseBox;
      case BookTranslationType.amv:
        return BoxLoader.amvVerseBox;
    }
  }

  static List<Verse> getVerseFromBookAndChapterNumber(int bookNum, int chapterNumber, BookTranslationType bookTranslationType) {
    final verseBox = getVerseBox(bookTranslationType);
    Query<Verse> query = verseBox.query(Verse_.bnu.equals(bookNum).and(Verse_.ch.equals(chapterNumber))).build();
    final results = query.find();
    query.close();
    return results;
  }

  static List<Verse> getSingleVerse(int bookNum, int chapterNumber, int verseNumber, BookTranslationType bookTranslationType) {
    final verseBox = getVerseBox(bookTranslationType);
    Query<Verse> query = verseBox.query(Verse_.bnu.equals(bookNum).and(Verse_.ch.equals(chapterNumber)).and(Verse_.v.equals(verseNumber))).build();
    final results = query.find();
    query.close();
    return results;
  }
}
