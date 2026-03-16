// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:xp_todo_app/data/models/data_with_id.dart';
import 'package:xp_todo_app/data/models/i_firestore_model.dart';
import 'package:xp_todo_app/util/enums/difficulty.dart';
import 'package:xp_todo_app/util/time_utils.dart';

class Quest extends IFirestoreModel {
  static String collectionName = 'Quest';

  final String id;
  final String title;
  final int xpReward;
  final int level;
  final Difficulty difficulty;
  final DateTime? expireDate;

  final String userId;
  final String gameId;

  final bool completed;
  final bool isActive;

  Quest({
    required this.id,
    required this.title,
    required this.xpReward,
    required this.level,
    required this.difficulty,
    required this.userId,
    required this.gameId,
    required this.completed,
    required this.isActive,
    this.expireDate,
    super.createdAt,
    super.updatedAt,
  }) : assert(title.isNotEmpty, 'Quest title cannot be empty'),
       assert(xpReward >= 0, 'XP reward cannot be negative'),
       assert(level >= 0, 'Level cannot be negative');

  Quest copyWith({
    String? id,
    String? title,
    int? xpReward,
    int? level,
    Difficulty? difficulty,
    String? userId,
    String? gameId,
    DateTime? expireDate,
    bool? completed,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      xpReward: xpReward ?? this.xpReward,
      level: level ?? this.level,
      difficulty: difficulty ?? this.difficulty,
      userId: userId ?? this.userId,
      gameId: gameId ?? this.gameId,
      expireDate: expireDate ?? this.expireDate,
      completed: completed ?? this.completed,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // TODO: this version introduces a modification where Id is stored in the map.
  //  This will need to be stripped at uplaod for firestore repos.
  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': title,
      'xpReward': xpReward,
      'level': level,
      'difficulty': difficulty.toStorage(),
      'expireDate': expireDate,
      'userId': userId,
      'gameId': gameId,
      'completed': completed,
      'isActive': isActive,
      ...super.toMap(),
    };
  }

  factory Quest.fromMap(Map<String, dynamic> map) {
    return Quest(
      id: map['id'] as String? ?? '',
      title: map['name'] as String,
      xpReward: map['xpReward'] as int,
      level: map['level'] as int,
      difficulty: Difficulty.fromStorage(map['difficulty'] as String?),
      expireDate: map['expireDate'] != null
          ? convertToDateTime(map['expireDate'])
          : null,
      userId: map['userId'] as String,
      gameId: map['gameId'] as String,
      completed: map['completed'] as bool? ?? false,
      isActive: map['isActive'] as bool? ?? true,
      createdAt: map['createdAt'] != null
          ? convertToDateTime(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? convertToDateTime(map['updatedAt'])
          : null,
    );
  }

  factory Quest.fromFirestore(String id, Map<String, dynamic> map) {
    map['id'] = id; // Ensure 'id' is included for model creation
    return Quest.fromMap(map);
  }

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
    String? userId,
    String? gameId,
    DateTime? expireDate,
    bool? completed,
    bool? isActive,
  }) {
    Map<String, dynamic> map = {};

    if (title != null) map['title'] = title;
    if (xpReward != null) map['xpReward'] = xpReward;
    if (level != null) map['level'] = level;
    if (difficulty != null) map['difficulty'] = difficulty.toStorage();
    if (userId != null) map['userId'] = userId;
    if (gameId != null) map['gameId'] = gameId;
    if (completed != null) map['completed'] = completed;
    if (isActive != null) map['isActive'] = isActive;
    if (expireDate != null) {
      map['expireDate'] = expireDate;
    }

    return map;
  }

  @override
  String toString() {
    return 'Quest(id: $id, name: $title, xpReward: $xpReward, level: $level, difficulty: $difficulty, completed: $completed, isActive: $isActive, expireDate: $expireDate)';
  }

  @override
  bool operator ==(covariant Quest other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.xpReward == xpReward &&
        other.level == level &&
        other.difficulty == difficulty &&
        other.userId == userId &&
        other.gameId == gameId &&
        other.completed == completed &&
        other.isActive == isActive &&
        other.expireDate == expireDate;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        xpReward.hashCode ^
        level.hashCode ^
        difficulty.hashCode ^
        userId.hashCode ^
        gameId.hashCode ^
        completed.hashCode ^
        isActive.hashCode ^
        expireDate.hashCode;
  }
}
