import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xp_todo_app/data/models/quest.dart';
import 'package:xp_todo_app/providers/auth_providers.dart';
import 'package:xp_todo_app/providers/repository_providers.dart';

part 'quest_providers.g.dart';

@riverpod
Stream<List<Quest>> userQuests(Ref ref, String userId) {
  final repository = ref.watch(questRepositoryProvider);
  return repository.watchUSerQuests(userId);
}

@riverpod
Stream<List<Quest>> incompleteUserQuests(Ref ref, String userId) {
  final repository = ref.watch(questRepositoryProvider);
  return repository.watchIncompleteUserQuests(userId);
}

@riverpod
Stream<List<Quest>> gameQuests(Ref ref, String userId, String gameId) {
  final repository = ref.watch(questRepositoryProvider);
  return repository.watchGameQuests(userId, gameId);
}

@riverpod
Stream<List<Quest>> incompleteGameQuests(
  Ref ref,
  String userId,
  String gameId,
) {
  final repository = ref.watch(questRepositoryProvider);
  return repository.watchIncompleteGameQuests(userId, gameId);
}

@Riverpod(keepAlive: true)
AsyncValue<List<Quest>?> activeUserAllQuests(Ref ref) {
  final activeUserId = ref.watch(activeUserIdProvider);

  if (activeUserId == null) {
    return const AsyncValue.data(null);
  }
  return ref.watch(userQuestsProvider(activeUserId));
}

@Riverpod(keepAlive: true)
AsyncValue<List<Quest>?> activeUserGameQuests(Ref ref, String gameId) {
  final activeUserId = ref.watch(activeUserIdProvider);

  if (activeUserId == null) {
    return const AsyncValue.data(null);
  }
  return ref.watch(gameQuestsProvider(activeUserId, gameId));
}

@riverpod
Stream<Quest?> quest(Ref ref, String userId, String gameId, String questId) {
  final repository = ref.watch(questRepositoryProvider);
  return repository.watchQuest(userId, gameId, questId);
}

@riverpod
class QuestActionNotifier extends _$QuestActionNotifier {
  @override
  AsyncValue<Quest?> build() => const AsyncValue.data(null);

  Future<void> createQuest(String userId, String gameId, Quest quest) async {
    state = const AsyncValue.loading();
    final nextState = await AsyncValue.guard<Quest?>(
      () =>
          ref.read(questRepositoryProvider).createQuest(userId, gameId, quest),
    );
    if (ref.mounted) {
      state = nextState;
    }
  }

  Future<void> updateQuest(
    String userId,
    String gameId,
    String questId,
    Map<String, dynamic> updates,
  ) async {
    state = const AsyncValue.loading();
    final nextState = await AsyncValue.guard<Quest?>(() async {
      await ref
          .read(questRepositoryProvider)
          .updateQuest(userId, gameId, questId, updates);
      return null;
    });
    if (ref.mounted) {
      state = nextState;
    }
  }

  Future<void> setQuestCompleted({
    required String userId,
    required String gameId,
    required String questId,
    required bool completed,
  }) async {
    state = const AsyncValue.loading();
    final nextState = await AsyncValue.guard<Quest?>(() async {
      await ref
          .read(questRepositoryProvider)
          .setQuestCompleted(userId, gameId, questId, completed);
      return null;
    });
    if (ref.mounted) {
      state = nextState;
    }
  }

  Future<void> transferQuestToGame({
    required String userId,
    required String fromGameId,
    required String toGameId,
    required String questId,
  }) async {
    state = const AsyncValue.loading();
    final nextState = await AsyncValue.guard<Quest?>(() async {
      await ref
          .read(questRepositoryProvider)
          .transferQuestToGame(
            userId: userId,
            fromGameId: fromGameId,
            toGameId: toGameId,
            questId: questId,
          );
      return null;
    });
    if (ref.mounted) {
      state = nextState;
    }
  }

  Future<void> deleteQuest(String userId, String gameId, String questId) async {
    state = const AsyncValue.loading();
    final nextState = await AsyncValue.guard<Quest?>(() async {
      await ref
          .read(questRepositoryProvider)
          .deleteQuest(userId, gameId, questId);
      return null;
    });
    if (ref.mounted) {
      state = nextState;
    }
  }
}
