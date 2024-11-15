import 'package:daily_verse/models/verse.dart';

String renderHeadingText(Verse verse) {
  if (verse.hnu == null) {
    return verse.t;
  }

  String finalText = '';
  if (verse.v.contains(0) && verse.v.length > 1) {
    finalText = '\n${verse.t}';
  } else if (!verse.v.contains(0) && verse.v.isNotEmpty) {
    finalText = '\n${verse.t}';
  } else {
    finalText = verse.t;
  }

  for (int i = 0; (i < verse.hnu!.floor() && i < 2); i++) {
    finalText = '${finalText}\n';
  }
  return finalText;
}

String renderVerseNum(Verse verse) {
  if (verse.v.length == 1) {
    return '${verse.v[0]}';
  } else {
    return '${verse.v[0]} - ${verse.v[verse.v.length - 1]}';
  }
}

String renderVerseText(Verse verse) {
  return verse.t.replaceAll(RegExp(r'\*\w+'), '');
}
