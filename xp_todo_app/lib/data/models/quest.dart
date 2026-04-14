// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:xp_todo_app/data/models/data_with_id.dart';
import 'package:xp_todo_app/data/models/i_firestore_model.dart';
import 'package:xp_todo_app/util/enums/difficulty.dart';
import 'package:xp_todo_app/util/time_utils.dart';

class Quest extends IFirestoreModel {
  static String collectionName = 'Quest';
  static String completeFieldName = 'completed';
  static String riskFieldName = 'risk';

  final String id;
  final String title;
  final int xpReward;
  final int level;
  final Difficulty difficulty;
  final String description;
  final DateTime? expireDate;
  final int risk;

  final String userId;
  final String gameId;

  final bool completed;

  Quest({
    required this.id,
    required this.title,
    required this.xpReward,
    required this.level,
    required this.difficulty,
    required this.description,
    this.risk = 0,
    required this.userId,
    required this.gameId,
    required this.completed,
    this.expireDate,
    super.dateCreated,
    super.dateUpdated,
  }) : assert(title.isNotEmpty, 'Quest title cannot be empty'),
       assert(xpReward >= 0, 'XP reward cannot be negative'),
       assert(level >= 0, 'Level cannot be negative'),
       assert(risk >= 0 && risk <= 100, 'Risk must be between 0 and 100');

  Quest copyWith({
    String? id,
    String? title,
    int? xpReward,
    int? level,
    Difficulty? difficulty,
    String? description,
    int? risk,
    String? userId,
    String? gameId,
    DateTime? expireDate,
    bool? completed,
    DateTime? dateCreated,
    DateTime? dateUpdated,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      xpReward: xpReward ?? this.xpReward,
      level: level ?? this.level,
      difficulty: difficulty ?? this.difficulty,
      description: description ?? this.description,
      risk: risk ?? this.risk,
      userId: userId ?? this.userId,
      gameId: gameId ?? this.gameId,
      expireDate: expireDate ?? this.expireDate,
      completed: completed ?? this.completed,
      dateCreated: dateCreated ?? this.dateCreated,
      dateUpdated: dateUpdated ?? this.dateUpdated,
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
      'description': description,
      riskFieldName: risk,
      'userId': userId,
      'gameId': gameId,
      completeFieldName: completed,
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
      risk: map[riskFieldName] as int? ?? 0,
      userId: map['userId'] as String,
      gameId: map['gameId'] as String,
      description: map['description'] as String,
      completed: map[completeFieldName] as bool? ?? false,
      dateCreated: map['dateCreated'] != null
          ? convertToDateTime(map['dateCreated'])
          : null,
      dateUpdated: map['dateUpdated'] != null
          ? convertToDateTime(map['dateUpdated'])
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
    String? description,
    int? risk,
    String? userId,
    String? gameId,
    DateTime? expireDate,
    bool? completed,
  }) {
    Map<String, dynamic> map = {};

    if (title != null) map['title'] = title;
    if (xpReward != null) map['xpReward'] = xpReward;
    if (level != null) map['level'] = level;
    if (difficulty != null) map['difficulty'] = difficulty.toStorage();
    if (description != null) map['description'] = description;
    if (risk != null) map[riskFieldName] = risk;
    if (userId != null) map['userId'] = userId;
    if (gameId != null) map['gameId'] = gameId;
    if (completed != null) map[completeFieldName] = completed;
    if (expireDate != null) {
      map['expireDate'] = expireDate;
    }

    return map;
  }

  @override
  String toString() {
    return 'Quest(id: $id, name: $title, xpReward: $xpReward, level: $level, difficulty: $difficulty, risk: $risk, completed: $completed, expireDate: $expireDate, description: $description, dateCreated: $dateCreated, dateUpdated: $dateUpdated)';
  }

  @override
  bool operator ==(covariant Quest other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.xpReward == xpReward &&
        other.level == level &&
        other.difficulty == difficulty &&
        other.risk == risk &&
        other.description == description &&
        other.userId == userId &&
        other.gameId == gameId &&
        other.completed == completed &&
        other.expireDate == expireDate;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        xpReward.hashCode ^
        level.hashCode ^
        difficulty.hashCode ^
        risk.hashCode ^
        description.hashCode ^
        userId.hashCode ^
        gameId.hashCode ^
        completed.hashCode ^
        expireDate.hashCode;
  }
}
