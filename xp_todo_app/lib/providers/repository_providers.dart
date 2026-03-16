import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:xp_todo_app/data/repositories/game_repository.dart';
import 'package:xp_todo_app/data/repositories/quest_repository.dart';
import 'package:xp_todo_app/data/repositories/user_profile_repository.dart';
import 'package:xp_todo_app/providers/firebase_providers.dart';

part 'repository_providers.g.dart';

@riverpod
UserProfileRepository userProfileRepository(Ref ref) {
  return UserProfileRepository(firestore: ref.watch(firestoreProvider));
}

@riverpod
GameRepository gameRepository(Ref ref) {
  return GameRepository(firestore: ref.watch(firestoreProvider));
}

@riverpod
QuestRepository questRepository(Ref ref) {
  return QuestRepository(firestore: ref.watch(firestoreProvider));
}
