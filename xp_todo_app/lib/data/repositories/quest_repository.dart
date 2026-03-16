import 'package:cloud_firestore/cloud_firestore.dart';
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
  Future<void> createQuest(String userId, String gameId, Quest quest) {
    // firestore.collection('userProfile').doc(userId).collection(collectionName);
    return createDocument(collection(userId, gameId), quest);
  }

  Future<Quest?> getQuest(String userId, String gameId, String questId) {
    return getDocument(collection(userId, gameId), questId, Quest.fromFirestore);
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

  Future<void> deleteQuest(String userId, String gameId, String questId) {
    return deleteDocument(collection(userId, gameId), questId);
  }

  /// Check if user exists
  Future<bool> questExists(String userId, String gameId, String questId) async {
    return documentExists(collection(userId, gameId), questId);
  }

  // ------Streams-----------------------------------------------
  Stream<Quest?> watchQuest(String userId, String gameId, String questId) {
    return watchDocument(collection(userId, gameId), questId, Quest.fromFirestore);
  }
}
