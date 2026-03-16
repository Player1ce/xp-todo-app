import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:xp_todo_app/providers/firebase_providers.dart';

import 'package:firebase_auth/firebase_auth.dart';

part 'auth_providers.g.dart';

@riverpod
Stream<User?> authState(Ref ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
}
