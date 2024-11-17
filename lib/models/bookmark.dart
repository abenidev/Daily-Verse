// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:daily_verse/models/collection.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Bookmark {
  @Id()
  int id;
  int bookNum;
  int chapterNum;
  int verseNum;
  DateTime createdAt;

  final collection = ToOne<Collection>();

  Bookmark({
    this.id = 0,
    required this.bookNum,
    required this.chapterNum,
    required this.verseNum,
    required this.createdAt,
  });

  Bookmark copyWith({
    int? id,
    int? bookNum,
    int? chapterNum,
    int? verseNum,
    DateTime? createdAt,
  }) {
    return Bookmark(
      id: id ?? this.id,
      bookNum: bookNum ?? this.bookNum,
      chapterNum: chapterNum ?? this.chapterNum,
      verseNum: verseNum ?? this.verseNum,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'bookNum': bookNum,
      'chapterNum': chapterNum,
      'verseNum': verseNum,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      id: map['id'] as int,
      bookNum: map['bookNum'] as int,
      chapterNum: map['chapterNum'] as int,
      verseNum: map['verseNum'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Bookmark.fromJson(String source) => Bookmark.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Bookmark(id: $id, bookNum: $bookNum, chapterNum: $chapterNum, verseNum: $verseNum, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant Bookmark other) {
    if (identical(this, other)) return true;

    return other.id == id && other.bookNum == bookNum && other.chapterNum == chapterNum && other.verseNum == verseNum && other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ bookNum.hashCode ^ chapterNum.hashCode ^ verseNum.hashCode ^ createdAt.hashCode;
  }
}
