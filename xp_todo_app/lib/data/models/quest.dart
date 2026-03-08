// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:xp_todo_app/util/difficulty.dart';

class Quest {
  String name;
  int xpReward;
  int level;
  Difficulty difficulty;

  String gameID;
  DateTime? expireDate;
  Quest({
    required this.name,
    required this.xpReward,
    required this.level,
    required this.difficulty,
    required this.gameID,
    this.expireDate,
  });

  Quest copyWith({
    String? name,
    int? xpReward,
    int? level,
    Difficulty? difficulty,
    String? gameID,
    DateTime? expireDate,
  }) {
    return Quest(
      name: name ?? this.name,
      xpReward: xpReward ?? this.xpReward,
      level: level ?? this.level,
      difficulty: difficulty ?? this.difficulty,
      gameID: gameID ?? this.gameID,
      expireDate: expireDate ?? this.expireDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'xpReward': xpReward,
      'level': level,
      'difficulty': difficulty.toStorage(),
      'gameID': gameID,
      'expireDate': expireDate?.millisecondsSinceEpoch,
    };
  }

  factory Quest.fromMap(Map<String, dynamic> map) {
    return Quest(
      name: map['name'] as String,
      xpReward: map['xpReward'] as int,
      level: map['level'] as int,
      difficulty: Difficulty.fromStorage(map['difficulty'] as String?),
      gameID: map['gameID'] as String,
      expireDate: map['expireDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['expireDate'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Quest.fromJson(String source) =>
      Quest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Quest(name: $name, xpReward: $xpReward, level: $level, difficulty: $difficulty, gameID: $gameID, expireDate: $expireDate)';
  }

  @override
  bool operator ==(covariant Quest other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.xpReward == xpReward &&
        other.level == level &&
        other.difficulty == difficulty &&
        other.gameID == gameID &&
        other.expireDate == expireDate;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        xpReward.hashCode ^
        level.hashCode ^
        difficulty.hashCode ^
        gameID.hashCode ^
        expireDate.hashCode;
  }
}
