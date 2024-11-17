// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:daily_verse/models/bookmark.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Collection {
  @Id()
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  String name;
  String color;

  @Backlink()
  final bookmarks = ToMany<Bookmark>();

  Collection({
    this.id = 0,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    this.color = "FF8000",
  });

  Collection copyWith({
    int? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? name,
    String? color,
  }) {
    return Collection(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'name': name,
      'color': color,
    };
  }

  factory Collection.fromMap(Map<String, dynamic> map) {
    return Collection(
      id: map['id'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      name: map['name'] as String,
      color: map['color'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Collection.fromJson(String source) => Collection.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Collection(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, name: $name, color: $color)';
  }

  @override
  bool operator ==(covariant Collection other) {
    if (identical(this, other)) return true;

    return other.id == id && other.createdAt == createdAt && other.updatedAt == updatedAt && other.name == name && other.color == color;
  }

  @override
  int get hashCode {
    return id.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode ^ name.hashCode ^ color.hashCode;
  }
}
