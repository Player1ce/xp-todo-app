// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xp_todo_app/data/models/data_with_id.dart';
import 'package:xp_todo_app/data/models/i_firestore_model.dart';
import 'package:xp_todo_app/util/enums/difficulty.dart';
import 'package:xp_todo_app/util/time_utils.dart';

class Game extends IFirestoreModel {
  static String collectionName = 'Game';

  final String id;

  final String title;
  final String imageUrl;
  final String description;

  final bool isActive;
  final int totalQuests;
  final int completedQuests;
  final Difficulty difficulty;
  final int availableXP;
  final int totalXP;
  final double completionPercentage;

  // Metadata
  final DateTime? createdAt;
  final DateTime? updatedAt;
  Game({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.isActive,
    required this.totalQuests,
    required this.completedQuests,
    required this.difficulty,
    required this.availableXP,
    required this.totalXP,
    required this.completionPercentage,
    this.createdAt,
    this.updatedAt,
  });

  Game copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? description,
    bool? isActive,
    int? totalQuests,
    int? completedQuests,
    Difficulty? difficulty,
    int? availableXP,
    int? totalXP,
    double? completionPercentage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Game(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      totalQuests: totalQuests ?? this.totalQuests,
      completedQuests: completedQuests ?? this.completedQuests,
      difficulty: difficulty ?? this.difficulty,
      availableXP: availableXP ?? this.availableXP,
      totalXP: totalXP ?? this.totalXP,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'description': description,
      'isActive': isActive,
      'totalQuests': totalQuests,
      'completedQuests': completedQuests,
      'difficulty': difficulty.toStorage(),
      'availableXP': availableXP,
      'totalXP': totalXP,
      'completionPercentage': completionPercentage,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'] as String,
      title: map['title'] as String,
      imageUrl: map['imageUrl'] as String,
      description: map['description'] as String,
      isActive: map['isActive'] as bool,
      totalQuests: map['totalQuests'] as int,
      completedQuests: map['completedQuests'] as int,
      difficulty: Difficulty.fromStorage(map['difficulty'] as String?),
      availableXP: map['availableXP'] as int,
      totalXP: map['totalXP'] as int,
      completionPercentage: map['completionPercentage'] as double,
      createdAt: map['createdAt'] != null
          ? convertToDateTime(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? convertToDateTime(map['updatedAt'])
          : null,
    );
  }

  factory Game.fromFirestore(String id, Map<String, dynamic> map) {
    map['id'] = id; // Ensure 'id' is included for model creation
    return Game.fromMap(map);
  }

  String toJson() => json.encode(toMap());

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
    int? totalQuests,
    int? completedQuests,
    Difficulty? difficulty,
    int? availableXP,
    int? totalXP,
    double? completionPercentage,
  }) {
    Map<String, dynamic> map = {'updatedAt': FieldValue.serverTimestamp()};

    if (title != null) map['title'] = title;
    if (imageUrl != null) map['imageUrl'] = imageUrl;
    if (description != null) map['description'] = description;
    if (isActive != null) map['isActive'] = isActive;
    if (totalQuests != null) map['totalQuests'] = totalQuests;
    if (completedQuests != null) map['completedQuests'] = completedQuests;
    if (difficulty != null) map['difficulty'] = difficulty.toStorage();
    if (availableXP != null) map['availableXP'] = availableXP;
    if (totalXP != null) map['totalXP'] = totalXP;
    if (completionPercentage != null) {
      map['completionPercentage'] = completionPercentage;
    }

    return map;
  }

  @override
  String toString() {
    return 'Game(id: $id, title: $title, imageUrl: $imageUrl, description: $description, isActive: $isActive, totalQuests: $totalQuests, completedQuests: $completedQuests, difficulty: $difficulty, availableXP: $availableXP, totalXP: $totalXP, completionPercentage: $completionPercentage, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Game other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.imageUrl == imageUrl &&
        other.description == description &&
        other.isActive == isActive &&
        other.totalQuests == totalQuests &&
        other.completedQuests == completedQuests &&
        other.difficulty == difficulty &&
        other.availableXP == availableXP &&
        other.totalXP == totalXP &&
        other.completionPercentage == completionPercentage &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        imageUrl.hashCode ^
        description.hashCode ^
        isActive.hashCode ^
        totalQuests.hashCode ^
        completedQuests.hashCode ^
        difficulty.hashCode ^
        availableXP.hashCode ^
        totalXP.hashCode ^
        completionPercentage.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
