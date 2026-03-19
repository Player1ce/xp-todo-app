import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xp_todo_app/data/models/user_profile.dart';
import 'package:xp_todo_app/providers/auth_providers.dart';
import 'package:xp_todo_app/providers/repository_providers.dart';

part 'user_profile_providers.g.dart';

@riverpod
Stream<UserProfile?> userProfile(Ref ref, String userId) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return repository.watchUserProfile(userId);
}

@Riverpod(keepAlive: true)
AsyncValue<UserProfile?> activeUserProfile(Ref ref) {
  final userId = ref.watch(activeUserIdProvider);

  if (userId == null) {
    return const AsyncValue.data(null);
  }
  return ref.watch(userProfileProvider(userId));
}

@riverpod
Future<bool> userExists(Ref ref, String userId) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return repository.userExists(userId);
}

@riverpod
class UserProfileActionNotifier extends _$UserProfileActionNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> createUserProfile(UserProfile profile) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(userProfileRepositoryProvider).createUserProfile(profile),
    );
  }

  Future<void> updateUserProfile(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref
          .read(userProfileRepositoryProvider)
          .updateUserProfile(userId, updates),
    );
  }

  Future<void> acceptPrivacyPolicy(String userId, String policyVersion) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref
          .read(userProfileRepositoryProvider)
          .acceptPrivacyPolicy(userId, policyVersion),
    );
  }

  Future<void> enable2FA(String userId, {String? phoneNumber}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref
          .read(userProfileRepositoryProvider)
          .enable2FA(userId, phoneNumber: phoneNumber),
    );
  }

  Future<void> disable2FA(String userId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(userProfileRepositoryProvider).disable2FA(userId),
    );
  }

  Future<void> deleteUserProfile(String userId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(userProfileRepositoryProvider).deleteUserProfile(userId),
    );
  }
}
