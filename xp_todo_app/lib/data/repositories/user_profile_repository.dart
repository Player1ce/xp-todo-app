import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xp_todo_app/data/models/user_profile.dart';
import 'package:xp_todo_app/data/repositories/i_firestore_repository.dart';

class UserProfileRepository extends IFirestoreRepository {
  static const String _serviceName = "UserProfileService";

  @override
  String get serviceName => _serviceName;

  CollectionReference<Map<String, dynamic>> get collection =>
      collectionRef(collectionElements);

  UserProfileRepository({
    required FirebaseFirestore firestore,
    bool isDemo = false,
  }) : super(
         firestore,
         isDemo,
         isDemo
             ? ['demo_${UserProfile.collectionName}']
             : [UserProfile.collectionName],
       );
  // --- CRUD Methods ----------------------------

  /// Create new user profile
  Future<void> createUserProfile(UserProfile profile) {
    return createDocumentWithId(collection, profile.id, profile);
  }

  // read user profile by Id
  Future<UserProfile?> getUserProfile(String userId) {
    return getDocument(collection, userId, UserProfile.fromFirestore);
  }

  /// Update profile
  Future<void> updateUserProfile(String userId, Map<String, dynamic> updates) {
    return updateDocument(collection, userId, updates);
  }

  Future<void> deleteUserProfile(String userId) {
    return deleteDocument(collection, userId);
  }

  // ------Specific actions------------

  /// Accept privacy policy
  Future<void> acceptPrivacyPolicy(String userId, String policyVersion) {
    return updateUserProfile(
      userId,
      UserProfile.createUpdateMap(
        acceptedPrivacyPolicy: true,
        policyVersion: policyVersion,
        consentDate: DateTime.now(),
      ),
    );
  }

  /// Enable 2FA
  Future<void> enable2FA(String userId, {String? phoneNumber}) {
    final updates = UserProfile.createUpdateMap(
      twoFactorEnabled: true,
      twoFactorEnabledAt: DateTime.now(),
    );

    // Optionally save phone number if provided
    if (phoneNumber != null) {
      updates.addAll(UserProfile.createUpdateMap(phoneNumber: phoneNumber));
    }

    return updateUserProfile(userId, updates);
  }

  /// Disable 2FA
  Future<void> disable2FA(String userId) {
    return updateUserProfile(
      userId,
      UserProfile.createUpdateMap(
        twoFactorEnabled: false,
        twoFactorEnabledAt: null,
      ),
    );
  }

  /// Check if user exists
  Future<bool> userExists(String userId, {bool isDemo = false}) async {
    return documentExists(collection, userId);
  }

  /// Get all user profiles (admin only)
  /// Note: Returns empty list for now - can be implemented later with proper pagination
  // Future<List<UserProfile>> getAllProfiles({bool isDemo = false}) async {
  //   // TODO: Implement when needed for admin dashboard
  //   // Will need proper pagination for large user bases
  //   debugPrint('UserProfileService: getAllProfiles not yet implemented');
  //   return [];
  // }

  // ------Streams-----------------------------------------------
  Stream<UserProfile?> watchUserProfile(String userId) {
    return watchDocument(collection, userId, UserProfile.fromFirestore);
  }
}
