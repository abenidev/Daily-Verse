// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AppData {
  int currentBookNum;
  int currentChapterNum;
  int currentVerseNum;

  AppData({
    required this.currentBookNum,
    required this.currentChapterNum,
    required this.currentVerseNum,
  });

  AppData copyWith({
    int? currentBookNum,
    int? currentChapterNum,
    int? currentVerseNum,
  }) {
    return AppData(
      currentBookNum: currentBookNum ?? this.currentBookNum,
      currentChapterNum: currentChapterNum ?? this.currentChapterNum,
      currentVerseNum: currentVerseNum ?? this.currentVerseNum,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'currentBookNum': currentBookNum,
      'currentChapterNum': currentChapterNum,
      'currentVerseNum': currentVerseNum,
    };
  }

  factory AppData.fromMap(Map<String, dynamic> map) {
    return AppData(
      currentBookNum: map['currentBookNum'] as int,
      currentChapterNum: map['currentChapterNum'] as int,
      currentVerseNum: map['currentVerseNum'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppData.fromJson(String source) => AppData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AppData(currentBookNum: $currentBookNum, currentChapterNum: $currentChapterNum, currentVerseNum: $currentVerseNum)';

  @override
  bool operator ==(covariant AppData other) {
    if (identical(this, other)) return true;

    return other.currentBookNum == currentBookNum && other.currentChapterNum == currentChapterNum && other.currentVerseNum == currentVerseNum;
  }

  @override
  int get hashCode => currentBookNum.hashCode ^ currentChapterNum.hashCode ^ currentVerseNum.hashCode;
}
