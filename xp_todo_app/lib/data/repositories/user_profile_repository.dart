import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xp_todo_app/data/models/data_with_id.dart';
import 'package:xp_todo_app/data/models/user_profile.dart';
import 'package:xp_todo_app/data/repositories/firestore_repository.dart';
import 'package:flutter/foundation.dart';

class UserProfileService {
  static const String serviceName = "UserProfileService";
  static const String collectionName = 'UserProfile';

  static String localizeCollectionName(bool isDemo) {
    return isDemo ? 'demo_$collectionName' : collectionName;
  }

  final FirestoreRepository _repository;
  final FirebaseFirestore _database;

  UserProfileService({
    required FirestoreRepository repository,
    required FirebaseFirestore database,
  }) : _repository = repository,
       _database = database;

  /// Create new user profile with retry logic
  Future<UserProfile?> createUserProfile(
    UserProfile profile, {
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 2),
    bool merge = false,
  }) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        final collection = _database.collection(collectionName);
        await collection
            .doc(profile.id)
            .set(profile.toMap(), SetOptions(merge: merge));
        debugPrint(
          '$serviceName: Created profile for ${profile.id} (${profile.role.name})',
        );
        return profile;
      } catch (e) {
        attempts++;
        debugPrint('$serviceName: Create attempt $attempts failed: $e');

        if (attempts < maxRetries) {
          await Future.delayed(retryDelay);
        } else {
          debugPrint(
            '$serviceName: Failed to create profile after $maxRetries attempts',
          );
          throw Exception(
            '$serviceName: Failed to create user profile after $maxRetries attempts: $e',
          );
        }
      }
    }

    return null;
  }

  /// Get user profile
  Future<UserProfile?> getUserProfile(
    String userId, {
    bool isDemo = false,
  }) async {
    final localCollectionName = localizeCollectionName(isDemo);
    try {
      final docRef = _database.collection(localCollectionName).doc(userId);
      final doc = await docRef.get();
      if (!doc.exists) {
        debugPrint(
          "FirebaseRepository: Document $localCollectionName/$userId does not exist",
        );
        return null;
      }
      return UserProfile.fromDataWithId(
        DataWithId(id: doc.id, data: doc.data() as Map<String, dynamic>),
      );
    } catch (e) {
      debugPrint(
        "$serviceName: Error getting profile document: $localCollectionName/$userId: $e",
      );
      return null;
    }
  }

  /// Update profile
  Future<bool> updateUserProfile(
    String userId,
    Map<String, dynamic> updates, {
    bool isDemo = false,
  }) async {
    final localCollectionName = localizeCollectionName(isDemo);
    try {
      if (updates.containsKey('id')) {
        updates.remove('id');
      }
      final docRef = _database.collection(localCollectionName).doc(userId);
      await docRef.update(updates);
      return true;
    } catch (e) {
      debugPrint(
        "$serviceName: error updating document $localCollectionName/$userId: $e",
      );
      return false;
    }
  }

  /// Accept privacy policy
  Future<bool> acceptPrivacyPolicy(
    String userId,
    String policyVersion, {
    bool isDemo = false,
  }) async {
    return updateUserProfile(userId, {
      'acceptedPrivacyPolicy': true,
      'policyVersion': policyVersion,
      'consentDate': DateTime.now(),
    }, isDemo: isDemo);
  }

  /// Mark survey as complete
  Future<bool> markSurveyComplete(
    String userId,
    String surveyVersion, {
    bool isDemo = false,
  }) async {
    return updateUserProfile(userId, {
      'surveyCompleted': true,
      'surveyVersion': surveyVersion,
      'surveyCompletedAt': DateTime.now(),
    }, isDemo: isDemo);
  }

  /// Enable 2FA
  Future<bool> enable2FA(
    String userId, {
    String? phoneNumber,
    bool isDemo = false,
  }) async {
    final updates = {
      'twoFactorEnabled': true,
      'twoFactorEnabledAt': DateTime.now(),
    };

    // Optionally save phone number if provided
    if (phoneNumber != null) {
      updates['phoneNumber'] = phoneNumber;
    }

    return updateUserProfile(userId, updates, isDemo: isDemo);
  }

  /// Disable 2FA
  Future<bool> disable2FA(String userId, {bool isDemo = false}) async {
    return updateUserProfile(userId, {
      'twoFactorEnabled': false,
      'twoFactorEnabledAt': null,
    }, isDemo: isDemo);
  }

  /// Add child to parent's childIDs
  Future<bool> addChild(
    String userId,
    String childId, {
    bool isDemo = false,
  }) async {
    final localCollectionName = isDemo
        ? 'demo_$collectionName'
        : collectionName;
    try {
      await _repository.appendToArrayField(
        localCollectionName,
        userId,
        'childIDs',
        childId,
      );
      return true;
    } catch (e) {
      debugPrint('UserProfileService: Error adding child: $e');
      return false;
    }
  }

  /// Remove child from parent's childIDs
  // Future<bool> removeChild(
  //   String userId,
  //   String childId, {
  //   bool isDemo = false,
  // }) async {
  //   try {
  //     final collectionName = isDemo
  //         ? 'demo_${UserProfile.collectionName}'
  //         : UserProfile.collectionName;
  //     // Get current profile, remove child from list, then update
  //     final profile = await getUserProfile(userId, isDemo: isDemo);
  //     if (profile == null) return false;

  //     final updatedChildIDs = profile.childIDs
  //         .where((id) => id != childId)
  //         .toList();
  //     await _repository.update(collectionName, userId, {
  //       'childIDs': updatedChildIDs,
  //     });
  //     notifyListeners();
  //     return true;
  //   } catch (e) {
  //     debugPrint('UserProfileService: Error removing child: $e');
  //     return false;
  //   }
  // }

  /// Check if user exists
  Future<bool> userExists(String userId, {bool isDemo = false}) async {
    final profile = await getUserProfile(userId, isDemo: isDemo);
    return profile != null;
  }

  /// Get all user profiles (admin only)
  /// Note: Returns empty list for now - can be implemented later with proper pagination
  Future<List<UserProfile>> getAllProfiles({bool isDemo = false}) async {
    // TODO: Implement when needed for admin dashboard
    // Will need proper pagination for large user bases
    debugPrint('UserProfileService: getAllProfiles not yet implemented');
    return [];
  }
}
