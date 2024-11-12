// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Verse {
  @Id()
  int id;
  final int o;
  final String biv;
  final String bna;
  final int bnu;
  final int ch;
  final List<int> v;
  final String t;
  final String? h;
  final double? hnu;

  Verse({
    this.id = 0,
    required this.o,
    required this.biv,
    required this.bna,
    required this.bnu,
    required this.ch,
    required this.v,
    required this.t,
    this.h,
    this.hnu,
  });

  Verse copyWith({
    int? id,
    int? o,
    String? biv,
    String? bna,
    int? bnu,
    int? ch,
    List<int>? v,
    String? t,
    String? h,
    double? hnu,
  }) {
    return Verse(
      id: id ?? this.id,
      o: o ?? this.o,
      biv: biv ?? this.biv,
      bna: bna ?? this.bna,
      bnu: bnu ?? this.bnu,
      ch: ch ?? this.ch,
      v: v ?? this.v,
      t: t ?? this.t,
      h: h ?? this.h,
      hnu: hnu ?? this.hnu,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'o': o,
      'biv': biv,
      'bna': bna,
      'bnu': bnu,
      'ch': ch,
      'v': v,
      't': t,
      'h': h,
      'hnu': hnu,
    };
  }

  factory Verse.fromMap(Map<String, dynamic> map) {
    return Verse(
      o: map['o'] as int,
      biv: map['biv'] as String,
      bna: map['bna'] as String,
      bnu: map['bnu'] as int,
      ch: map['ch'] as int,
      v: List<int>.from((map['v'] as List<dynamic>)),
      t: map['t'] as String,
      h: map['h'] != null ? map['h'] as String : null,
      hnu: map['hnu'] != null ? double.parse(map['hnu'].toString()) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Verse.fromJson(String source) => Verse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Verse(id: $id, o: $o, biv: $biv, bna: $bna, bnu: $bnu, ch: $ch, v: $v, t: $t, h: $h, hnu: $hnu)';
  }

  @override
  bool operator ==(covariant Verse other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.o == o &&
        other.biv == biv &&
        other.bna == bna &&
        other.bnu == bnu &&
        other.ch == ch &&
        listEquals(other.v, v) &&
        other.t == t &&
        other.h == h &&
        other.hnu == hnu;
  }

  @override
  int get hashCode {
    return id.hashCode ^ o.hashCode ^ biv.hashCode ^ bna.hashCode ^ bnu.hashCode ^ ch.hashCode ^ v.hashCode ^ t.hashCode ^ h.hashCode ^ hnu.hashCode;
  }
}
