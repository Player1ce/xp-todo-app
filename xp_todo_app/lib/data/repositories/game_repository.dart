import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xp_todo_app/data/models/game.dart';
import 'package:xp_todo_app/data/models/user_profile.dart';
import 'package:xp_todo_app/data/repositories/i_firestore_repository.dart';

class GameRepository extends IFirestoreRepository {
  static const String _serviceName = "GameService";

  @override
  String get serviceName => _serviceName;

  CollectionReference<Map<String, dynamic>> collection(String userId) {
    final segments = List<String>.of(collectionElements, growable: false);
    segments[1] = userId;
    return collectionRef(segments);
  }

  GameRepository({required FirebaseFirestore firestore, bool isDemo = false})
    : super(firestore, isDemo, [
        isDemo
            ? 'demo_${UserProfile.collectionName}'
            : UserProfile.collectionName,
        'replaceWithUserId',
        isDemo ? 'demo_${Game.collectionName}' : Game.collectionName,
      ]);

  // --- Document Management Methods ----------------------------

  /// Create new game
  Future<Game> createGame(String userId, Game game) async {
    try {
      debugPrint(
        "GameRepository: createGame called with userId: $userId, game data: ${game.toString()}",
      );
      return game.copyWith(
        id: await createDocument(
          collection(userId),
          game.copyWith(userId: userId),
        ),
        dateCreated: DateTime.now(),
        dateUpdated: DateTime.now(),
      );
    } on Exception catch (e) {
      debugPrint(
        "$serviceName: unexpected repository error creating game for user $userId: $e",
      );
      rethrow;
    }
  }

  Future<Game?> getGame(String userId, String gameId) {
    return getDocument(collection(userId), gameId, Game.fromFirestore);
  }

  /// Update game
  Future<void> updateGame(
    String userId,
    String gameId,
    Map<String, dynamic> updates,
  ) {
    return updateDocument(collection(userId), gameId, updates);
  }

  // TODO: update this to also delete all subcollection documents (quests)
  Future<void> deleteGame(String userId, String gameId) {
    return deleteDocument(collection(userId), gameId);
  }

  /// Check if user exists
  Future<bool> gameExists(String userId, String gameId) async {
    return documentExists(collection(userId), gameId);
  }

  // ------Specific Actions to support app features------------------------------
  Future<void> setGameActive(String userId, String gameId, bool isActive) {
    return updateGame(userId, gameId, Game.createUpdateMap(isActive: isActive));
  }

  Future<void> setGameProgressCache({
    required String userId,
    required String gameId,
    required int totalQuests,
    required int completedQuests,
    required int availableXP,
    required int totalXP,
  }) {
    final completionPercentage = totalQuests == 0
        ? 0.0
        : completedQuests / totalQuests;

    return updateGame(
      userId,
      gameId,
      Game.createUpdateMap(
        totalQuests: totalQuests,
        completedQuests: completedQuests,
        availableXP: availableXP,
        totalXP: totalXP,
        completionPercentage: completionPercentage,
      ),
    );
  }

  // ------Streams-----------------------------------------------
  Stream<Game?> watchGame(String userId, String gameId) {
    return watchDocument(collection(userId), gameId, Game.fromFirestore);
  }

  Stream<List<Game>> watchGames(String userId) {
    return collection(userId).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Game.fromFirestore(doc.id, doc.data()))
          .toList(growable: false);
    });
  }

  Stream<List<Game>> watchActiveGames(String userId) {
    return collection(
      userId,
    ).where('isActive', isEqualTo: true).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Game.fromFirestore(doc.id, doc.data()))
          .toList(growable: false);
    });
  }
}
