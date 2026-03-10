// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xp_todo_app/data/models/data_with_id.dart';
import 'package:xp_todo_app/util/enums/difficulty.dart';
import 'package:xp_todo_app/util/time_utils.dart';

class Quest {
  static String collectionName = 'Quest';

  final String id;
  final String title;
  final int xpReward;
  final int level;
  final Difficulty difficulty;
  final String gameID;
  final DateTime? expireDate;

  // Metadata
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Quest({
    required this.id,
    required this.title,
    required this.xpReward,
    required this.level,
    required this.difficulty,
    required this.gameID,
    this.expireDate,
    this.createdAt,
    this.updatedAt,
  });

  Quest copyWith({
    String? id,
    String? title,
    int? xpReward,
    int? level,
    Difficulty? difficulty,
    String? gameID,
    DateTime? expireDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      xpReward: xpReward ?? this.xpReward,
      level: level ?? this.level,
      difficulty: difficulty ?? this.difficulty,
      gameID: gameID ?? this.gameID,
      expireDate: expireDate ?? this.expireDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // TODO: this version introduces a modification where ID is stored in the map.
  //  This will need to be stripped at uplaod for firestore repos.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': title,
      'xpReward': xpReward,
      'level': level,
      'difficulty': difficulty.toStorage(),
      'gameID': gameID,
      'expireDate': expireDate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Quest.fromMap(Map<String, dynamic> map) {
    return Quest(
      id: map['id'] as String? ?? '',
      title: map['name'] as String,
      xpReward: map['xpReward'] as int,
      level: map['level'] as int,
      difficulty: Difficulty.fromStorage(map['difficulty'] as String?),
      gameID: map['gameID'] as String,
      expireDate: map['expireDate'] != null
          ? convertToDateTime(map['expireDate'])
          : null,
      createdAt: map['createdAt'] != null
          ? convertToDateTime(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? convertToDateTime(map['updatedAt'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Quest.fromJson(String source) =>
      Quest.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Quest.fromDataWithId(DataWithId source) {
    Map<String, dynamic> data = source.data;
    data['id'] = source.id;
    return Quest.fromMap(data);
  }

  static Map<String, dynamic> createUpdateMap({
    String? title,
    int? xpReward,
    int? level,
    Difficulty? difficulty,
    String? gameID,
    DateTime? expireDate,
  }) {
    Map<String, dynamic> map = {'updatedAt': FieldValue.serverTimestamp()};

    if (title != null) map['title'] = title;
    if (xpReward != null) map['xpReward'] = xpReward;
    if (level != null) map['level'] = level;
    if (difficulty != null) map['difficulty'] = difficulty.toStorage();
    if (gameID != null) map['gameID'] = gameID;
    if (expireDate != null) {
      map['expireDate'] = expireDate;
    }

    return map;
  }

  @override
  String toString() {
    return 'Quest(id: $id, name: $title, xpReward: $xpReward, level: $level, difficulty: $difficulty, gameID: $gameID, expireDate: $expireDate)';
  }

  @override
  bool operator ==(covariant Quest other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.xpReward == xpReward &&
        other.level == level &&
        other.difficulty == difficulty &&
        other.gameID == gameID &&
        other.expireDate == expireDate;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        xpReward.hashCode ^
        level.hashCode ^
        difficulty.hashCode ^
        gameID.hashCode ^
        expireDate.hashCode;
  }
}
