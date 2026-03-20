import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xp_todo_app/data/models/game.dart';
import 'package:xp_todo_app/providers/auth_providers.dart';
import 'package:xp_todo_app/providers/repository_providers.dart';

part 'game_providers.g.dart';

@riverpod
Stream<List<Game>> games(Ref ref, String userId) {
  final repository = ref.watch(gameRepositoryProvider);
  return repository.watchGames(userId);
}

@riverpod
Stream<List<Game>> activeGames(Ref ref, String userId) {
  final repository = ref.watch(gameRepositoryProvider);
  return repository.watchActiveGames(userId);
}

@Riverpod(keepAlive: true)
AsyncValue<List<Game>?> activeUserGames(Ref ref) {
  final activeUserId = ref.watch(activeUserIdProvider);
  if (activeUserId == null) {
    return const AsyncValue.data(null);
  }
  return ref.watch(
    gamesProvider(activeUserId).select(
      (gamesAsync) => gamesAsync.whenData(
        (games) => games.where((game) => !game.archived).toList(),
      ),
    ),
  );
}

@riverpod
AsyncValue<List<Game>?> activeUserActiveGames(Ref ref) {
  return ref.watch(
    activeUserGamesProvider.select(
      (gamesAsync) => gamesAsync.whenData(
        (games) =>
            games?.where((game) => game.isActive && !game.archived).toList(),
      ),
    ),
  );
}

@riverpod
AsyncValue<Game?> activeUserGame(Ref ref, String gameId) {
  return ref.watch(
    activeUserGamesProvider.select(
      (gamesAsync) => gamesAsync.whenData(
        (games) => games?.where((game) => game.id == gameId).firstOrNull,
      ),
    ),
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

  Future<void> archiveGame({
    required String userId,
    required String gameId,
  }) async {
    state = const AsyncValue.loading();
    final nextState = await AsyncValue.guard<Game?>(() async {
      await ref.read(gameRepositoryProvider).archiveGame(userId, gameId);
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

  Future<void> setGameProgressCache({
    required String userId,
    required String gameId,
    required int totalQuests,
    required int completedQuests,
    required int availableXP,
    required int totalXP,
  }) async {
    state = const AsyncValue.loading();
    final nextState = await AsyncValue.guard<Game?>(() async {
      await ref
          .read(gameRepositoryProvider)
          .setGameProgressCache(
            userId: userId,
            gameId: gameId,
            totalQuests: totalQuests,
            completedQuests: completedQuests,
            availableXP: availableXP,
            totalXP: totalXP,
          );
      return null;
    });
    if (ref.mounted) {
      state = nextState;
    }
  }
}
