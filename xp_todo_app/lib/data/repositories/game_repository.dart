import 'package:cloud_firestore/cloud_firestore.dart';
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
  Future<void> createGame(String userId, Game game) {
    // firestore.collection('userProfile').doc(userId).collection(collectionName);
    return createDocument(collection(userId), game);
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

  Future<void> deleteGame(String userId, String gameId) {
    return deleteDocument(collection(userId), gameId);
  }

  /// Check if user exists
  Future<bool> gameExists(String userId, String gameId) async {
    return documentExists(collection(userId), gameId);
  }

  // ------Streams-----------------------------------------------
  Stream<Game?> watchGame(String userId, String gameId) {
    return watchDocument(collection(userId), gameId, Game.fromFirestore);
  }
}
