// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:xp_todo_app/data/models/data_with_id.dart';
import 'package:xp_todo_app/data/models/i_firestore_model.dart';
import 'package:xp_todo_app/util/enums/difficulty.dart';
import 'package:xp_todo_app/util/time_utils.dart';

class Game extends IFirestoreModel {
  static String collectionName = 'Game';
  static String gameActiveFieldName = 'isActive';
  static String gameArchivedFieldName = 'archived';

  final String id;

  final String title;
  final String imageUrl;
  final String description;

  final bool isActive;
  final bool archived;
  final int totalQuests;
  final int completedQuests;
  final Difficulty difficulty;
  final int availableXP;
  final int totalXP;
  final double completionPercentage;

  final String userId;

  Game({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.isActive,
    required this.archived,
    required this.totalQuests,
    required this.completedQuests,
    required this.difficulty,
    required this.availableXP,
    required this.totalXP,
    required this.completionPercentage,
    required this.userId,
    super.dateCreated,
    super.dateUpdated,
  });

  Game copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? description,
    bool? isActive,
    bool? archived,
    int? totalQuests,
    int? completedQuests,
    Difficulty? difficulty,
    int? availableXP,
    int? totalXP,
    double? completionPercentage,
    String? userId,
    DateTime? dateCreated,
    DateTime? dateUpdated,
  }) {
    return Game(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      archived: archived ?? this.archived,
      totalQuests: totalQuests ?? this.totalQuests,
      completedQuests: completedQuests ?? this.completedQuests,
      difficulty: difficulty ?? this.difficulty,
      availableXP: availableXP ?? this.availableXP,
      totalXP: totalXP ?? this.totalXP,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      userId: userId ?? this.userId,
      dateCreated: dateCreated ?? this.dateCreated,
      dateUpdated: dateUpdated ?? this.dateUpdated,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'description': description,
      gameActiveFieldName: isActive,
      gameArchivedFieldName: archived,
      'totalQuests': totalQuests,
      'completedQuests': completedQuests,
      'difficulty': difficulty.toStorage(),
      'availableXP': availableXP,
      'totalXP': totalXP,
      'completionPercentage': completionPercentage,
      'userId': userId,
      'dateCreated': dateCreated,
      'dateUpdated': dateUpdated,
    };
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'] as String,
      title: map['title'] as String,
      imageUrl: map['imageUrl'] as String,
      description: map['description'] as String,
      isActive: map[gameActiveFieldName] as bool,
      archived: map[gameArchivedFieldName] as bool? ?? false,
      totalQuests: (map['totalQuests'] as double).toInt(),
      completedQuests: (map['completedQuests'] as double).toInt(),
      difficulty: Difficulty.fromStorage(map['difficulty'] as String?),
      availableXP: (map['availableXP'] as double).toInt(),
      totalXP: (map['totalXP'] as double).toInt(),
      completionPercentage: map['completionPercentage'] as double,
      userId: map['userId'] as String,
      dateCreated: map['dateCreated'] != null
          ? convertToDateTime(map['dateCreated'])
          : null,
      dateUpdated: map['dateUpdated'] != null
          ? convertToDateTime(map['dateUpdated'])
          : null,
    );
  }

  factory Game.fromFirestore(String id, Map<String, dynamic> map) {
    map['id'] = id; // Ensure 'id' is included for model creation
    return Game.fromMap(map);
  }

  factory Game.fromJson(String source) =>
      Game.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Game.fromDataWithId(DataWithId source) {
    Map<String, dynamic> data = source.data;
    data['id'] = source.id;
    return Game.fromMap(data);
  }

  static Map<String, dynamic> createUpdateMap({
    String? title,
    String? imageUrl,
    String? description,
    bool? isActive,
    bool? archived,
    int? totalQuests,
    int? completedQuests,
    Difficulty? difficulty,
    int? availableXP,
    int? totalXP,
    double? completionPercentage,
    String? userId,
  }) {
    Map<String, dynamic> map = {};

    if (title != null) map['title'] = title;
    if (imageUrl != null) map['imageUrl'] = imageUrl;
    if (description != null) map['description'] = description;
    if (isActive != null) map[gameActiveFieldName] = isActive;
    if (archived != null) map[gameArchivedFieldName] = archived;
    if (totalQuests != null) map['totalQuests'] = totalQuests;
    if (completedQuests != null) map['completedQuests'] = completedQuests;
    if (difficulty != null) map['difficulty'] = difficulty.toStorage();
    if (availableXP != null) map['availableXP'] = availableXP;
    if (totalXP != null) map['totalXP'] = totalXP;
    if (completionPercentage != null) {
      map['completionPercentage'] = completionPercentage;
    }
    if (userId != null) map['userId'] = userId;

    return map;
  }

  @override
  String toString() {
    return 'Game(id: $id, title: $title, imageUrl: $imageUrl, description: $description, isActive: $isActive, archived: $archived, totalQuests: $totalQuests, completedQuests: $completedQuests, difficulty: $difficulty, availableXP: $availableXP, totalXP: $totalXP, completionPercentage: $completionPercentage)';
  }

  @override
  bool operator ==(covariant Game other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.imageUrl == imageUrl &&
        other.description == description &&
        other.isActive == isActive &&
        other.archived == archived &&
        other.totalQuests == totalQuests &&
        other.completedQuests == completedQuests &&
        other.difficulty == difficulty &&
        other.availableXP == availableXP &&
        other.totalXP == totalXP &&
        other.completionPercentage == completionPercentage &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        imageUrl.hashCode ^
        description.hashCode ^
        isActive.hashCode ^
        archived.hashCode ^
        totalQuests.hashCode ^
        completedQuests.hashCode ^
        difficulty.hashCode ^
        availableXP.hashCode ^
        totalXP.hashCode ^
        completionPercentage.hashCode ^
        userId.hashCode;
  }
}
