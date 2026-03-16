import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xp_todo_app/data/models/game.dart';
import 'package:xp_todo_app/providers/repository_providers.dart';

part 'game_providers.g.dart';

@riverpod
Stream<List<Game>> games(Ref ref, String userId) {
  final repository = ref.watch(gameRepositoryProvider);
  return repository.watchGames(userId);
}

@riverpod
AsyncValue<List<Game>> activeGames(Ref ref, String userId) {
  final gamesAsync = ref.watch(gamesProvider(userId));
  return gamesAsync.whenData(
    (games) => games.where((game) => game.isActive).toList(),
  );
}

// TODO: if we decide to always load the gamesProvider (which might happen by dafult)
//  it might make more sense to use this as a compositon on gamesProvider
@riverpod
Stream<Game?> game(Ref ref, String userId, String gameId) {
  final repository = ref.watch(gameRepositoryProvider);
  return repository.watchGame(userId, gameId);
}

@riverpod
class GameActionNotifier extends _$GameActionNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> createGame(String userId, Game game) async {
    print(
      "GameActionNotifier: createGame called with userId: $userId, game: ${game.toString()}",
    );
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(gameRepositoryProvider).createGame(userId, game),
    );
  }

  Future<void> setGameActive({
    required String userId,
    required String gameId,
    required bool isActive,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref
          .read(gameRepositoryProvider)
          .setGameActive(userId, gameId, isActive),
    );
  }

  Future<void> deleteGame(String userId, String gameId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(gameRepositoryProvider).deleteGame(userId, gameId),
    );
  }

  Future<void> updateGame(
    String userId,
    String gameId,
    Map<String, dynamic> updates,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () =>
          ref.read(gameRepositoryProvider).updateGame(userId, gameId, updates),
    );
  }
}
