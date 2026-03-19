import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xp_todo_app/data/models/game.dart';
import 'package:xp_todo_app/data/models/quest.dart';
import 'package:xp_todo_app/data/models/user_profile.dart';
import 'package:xp_todo_app/data/repositories/i_firestore_repository.dart';

class QuestRepository extends IFirestoreRepository {
  static const String _serviceName = "QuestService";

  @override
  String get serviceName => _serviceName;

  CollectionReference<Map<String, dynamic>> collection(
    String userId,
    String gameId,
  ) {
    final segments = List<String>.of(collectionElements, growable: false);
    segments[1] = userId;
    segments[3] = gameId;
    return collectionRef(segments);
  }

  QuestRepository({required FirebaseFirestore firestore, bool isDemo = false})
    : super(firestore, isDemo, [
        isDemo
            ? 'demo_${UserProfile.collectionName}'
            : UserProfile.collectionName,
        'replaceWithUserId',
        isDemo ? 'demo_${Game.collectionName}' : Game.collectionName,
        'replaceWithGameId',
        isDemo ? 'demo_${Quest.collectionName}' : Quest.collectionName,
      ]);

  // --- Document Management Methods ----------------------------

  /// Create new quest
  Future<Quest> createQuest(String userId, String gameId, Quest quest) async {
    try {
      debugPrint(
        "QuestRepository: createGame called with userId: $userId, game data: ${quest.toString()}",
      );
      return quest.copyWith(
        id: await createDocument(collection(userId, gameId), quest),
        dateCreated: DateTime.now(),
        dateUpdated: DateTime.now(),
      );
    } on Exception catch (e) {
      debugPrint(
        "$serviceName: unexpected repository error creating quest for user $userId and game $gameId: $e",
      );
      rethrow;
    }
  }

  Future<Quest?> getQuest(String userId, String gameId, String questId) {
    return getDocument(
      collection(userId, gameId),
      questId,
      Quest.fromFirestore,
    );
  }

  /// Update quest
  Future<void> updateQuest(
    String userId,
    String gameId,
    String questId,
    Map<String, dynamic> updates,
  ) {
    return updateDocument(collection(userId, gameId), questId, updates);
  }

  Future<void> setQuestCompleted(
    String userId,
    String gameId,
    String questId,
    bool completed,
  ) {
    return updateQuest(
      userId,
      gameId,
      questId,
      Quest.createUpdateMap(completed: completed),
    );
  }

  Future<void> deleteQuest(String userId, String gameId, String questId) {
    return deleteDocument(collection(userId, gameId), questId);
  }

  /// Check if user exists
  Future<bool> questExists(String userId, String gameId, String questId) async {
    return documentExists(collection(userId, gameId), questId);
  }

  // ------Streams-----------------------------------------------
  Stream<Quest?> watchQuest(String userId, String gameId, String questId) {
    return watchDocument(
      collection(userId, gameId),
      questId,
      Quest.fromFirestore,
    );
  }

  Stream<List<Quest>> watchGameQuests(String userId, String gameId) {
    return collection(userId, gameId).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Quest.fromFirestore(doc.id, doc.data()))
          .toList(growable: false);
    });
  }

  Stream<List<Quest>> watchUSerQuests(String userId) {
    return collection(userId, '').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Quest.fromFirestore(doc.id, doc.data()))
          .toList(growable: false);
    });
  }

  Stream<List<Quest>> watchIncompleteUserQuests(String userId) {
    return collection(userId, '')
        .where(Quest.completeFieldName, isEqualTo: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Quest.fromFirestore(doc.id, doc.data()))
              .toList(growable: false);
        });
  }

  Stream<List<Quest>> watchIncompleteGameQuests(String userId, String gameId) {
    return collection(userId, gameId)
        .where(Quest.completeFieldName, isEqualTo: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Quest.fromFirestore(doc.id, doc.data()))
              .toList(growable: false);
        });
  }
}
