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
  AsyncValue<Game?> build() => const AsyncValue.data(null);

  Future<void> createGame(String userId, Game game) async {
    state = const AsyncValue.loading();
    final nextState = await AsyncValue.guard<Game?>(() async {
      return await ref.read(gameRepositoryProvider).createGame(userId, game);
    });
    if (ref.mounted) {
      state = nextState;
    }
  }

  Future<void> setGameActive({
    required String userId,
    required String gameId,
    required bool isActive,
  }) async {
    state = const AsyncValue.loading();
    final nextState = await AsyncValue.guard<Game?>(() async {
      await ref
          .read(gameRepositoryProvider)
          .setGameActive(userId, gameId, isActive);
      return null;
    });
    if (ref.mounted) {
      state = nextState;
    }
  }

  Future<void> deleteGame(String userId, String gameId) async {
    state = const AsyncValue.loading();
    final nextState = await AsyncValue.guard<Game?>(() async {
      await ref.read(gameRepositoryProvider).deleteGame(userId, gameId);
      return null;
    });
    if (ref.mounted) {
      state = nextState;
    }
  }

  Future<void> updateGame(
    String userId,
    String gameId,
    Map<String, dynamic> updates,
  ) async {
    state = const AsyncValue.loading();
    final nextState = await AsyncValue.guard<Game?>(() async {
      await ref
          .read(gameRepositoryProvider)
          .updateGame(userId, gameId, updates);
      return null;
    });
    if (ref.mounted) {
      state = nextState;
    }
  }
}
