import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xp_todo_app/data/models/quest.dart';
import 'package:xp_todo_app/providers/repository_providers.dart';

part 'quest_providers.g.dart';

@riverpod
Stream<List<Quest>> quests(Ref ref, String userId, String gameId) {
  final repository = ref.watch(questRepositoryProvider);
  return repository.watchQuests(userId, gameId);
}

@riverpod
AsyncValue<List<Quest>> activeQuests(Ref ref, String userId, String gameId) {
  final questsAsync = ref.watch(questsProvider(userId, gameId));
  final now = DateTime.now();
  return questsAsync.whenData((quests) {
    return quests
        .where(
          (quest) => quest.expireDate == null || quest.expireDate!.isAfter(now),
        )
        .toList(growable: false);
  });
}

@riverpod
Stream<Quest?> quest(Ref ref, String userId, String gameId, String questId) {
  final repository = ref.watch(questRepositoryProvider);
  return repository.watchQuest(userId, gameId, questId);
}

@riverpod
class QuestActionNotifier extends _$QuestActionNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> createQuest(String userId, String gameId, Quest quest) async {
    state = const AsyncValue.loading();
    final nextState = await AsyncValue.guard<void>(
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
    final nextState = await AsyncValue.guard<void>(
      () => ref
          .read(questRepositoryProvider)
          .updateQuest(userId, gameId, questId, updates),
    );
    if (ref.mounted) {
      state = nextState;
    }
  }

  Future<void> deleteQuest(String userId, String gameId, String questId) async {
    state = const AsyncValue.loading();
    final nextState = await AsyncValue.guard<void>(
      () => ref
          .read(questRepositoryProvider)
          .deleteQuest(userId, gameId, questId),
    );
    if (ref.mounted) {
      state = nextState;
    }
  }
}
