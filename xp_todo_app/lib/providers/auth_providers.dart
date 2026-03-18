import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:xp_todo_app/providers/firebase_providers.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:xp_todo_app/util/enums/user_role.dart';

part 'auth_providers.g.dart';

@riverpod
Stream<User?> authState(Ref ref) {
  return ref.watch(firebaseAuthProvider).userChanges();
}

@riverpod
User requiredAuthState(Ref ref) {
  return ref.watch(authStateProvider).requireValue!;
}

// Step 2 — get the ID token result whenever auth state changes
// TODO: we can prpopogate claims updates by adding a rolesUpdatesAt field to the user model and then watching the model here for changes.
//  this is most likely not necessary for the app since these are niche cases and the claims will still apply in permission rules anyway.
//  it can be a dream goal for later.
@riverpod
Future<IdTokenResult?> idTokenResult(
  Ref ref, [
  bool forceRefresh = false,
]) async {
  final authAsync = ref.watch(authStateProvider);

  if (authAsync.isLoading) return null;
  if (authAsync.hasError) return null;

  final user = authAsync.value;
  if (user == null) return null;
  return user.getIdTokenResult(forceRefresh);
}

// Step 3 — map the token result to roles
@riverpod
AsyncValue<List<UserRole>> userRoles(Ref ref, [bool forceRefresh = false]) {
  final tokenAsync = ref.watch(idTokenResultProvider(forceRefresh));
  return tokenAsync.whenData(
    (token) => UserRole.getRolesFromClaims(token?.claims ?? {}),
  );
}
