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
  return questsAsync.whenData(
    (quests) => quests.where((quest) => quest.isActive).toList(),
  );
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
    state = await AsyncValue.guard(
      () =>
          ref.read(questRepositoryProvider).createQuest(userId, gameId, quest),
    );
  }

  Future<void> updateQuest(
    String userId,
    String gameId,
    String questId,
    Map<String, dynamic> updates,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref
          .read(questRepositoryProvider)
          .updateQuest(userId, gameId, questId, updates),
    );
  }

  Future<void> deleteQuest(String userId, String gameId, String questId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref
          .read(questRepositoryProvider)
          .deleteQuest(userId, gameId, questId),
    );
  }
}
