// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(games)
final gamesProvider = GamesFamily._();

final class GamesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Game>>,
          List<Game>,
          Stream<List<Game>>
        >
    with $FutureModifier<List<Game>>, $StreamProvider<List<Game>> {
  GamesProvider._({
    required GamesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'gamesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$gamesHash();

  @override
  String toString() {
    return r'gamesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Game>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Game>> create(Ref ref) {
    final argument = this.argument as String;
    return games(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GamesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gamesHash() => r'2109b4067e2306d071b39d81a064141347978620';

final class GamesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Game>>, String> {
  GamesFamily._()
    : super(
        retry: null,
        name: r'gamesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GamesProvider call(String userId) =>
      GamesProvider._(argument: userId, from: this);

  @override
  String toString() => r'gamesProvider';
}

@ProviderFor(activeGames)
final activeGamesProvider = ActiveGamesFamily._();

final class ActiveGamesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Game>>,
          AsyncValue<List<Game>>,
          AsyncValue<List<Game>>
        >
    with $Provider<AsyncValue<List<Game>>> {
  ActiveGamesProvider._({
    required ActiveGamesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'activeGamesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activeGamesHash();

  @override
  String toString() {
    return r'activeGamesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<List<Game>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<Game>> create(Ref ref) {
    final argument = this.argument as String;
    return activeGames(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Game>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<Game>>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveGamesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activeGamesHash() => r'0e675dab289b67113cce814648c6fbfe795bcb41';

final class ActiveGamesFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<List<Game>>, String> {
  ActiveGamesFamily._()
    : super(
        retry: null,
        name: r'activeGamesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ActiveGamesProvider call(String userId) =>
      ActiveGamesProvider._(argument: userId, from: this);

  @override
  String toString() => r'activeGamesProvider';
}

@ProviderFor(game)
final gameProvider = GameFamily._();

final class GameProvider
    extends $FunctionalProvider<AsyncValue<Game?>, Game?, Stream<Game?>>
    with $FutureModifier<Game?>, $StreamProvider<Game?> {
  GameProvider._({
    required GameFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'gameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$gameHash();

  @override
  String toString() {
    return r'gameProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<Game?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Game?> create(Ref ref) {
    final argument = this.argument as (String, String);
    return game(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is GameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gameHash() => r'da870bc7903087fae3306540b52a921df0eccbae';

final class GameFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Game?>, (String, String)> {
  GameFamily._()
    : super(
        retry: null,
        name: r'gameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GameProvider call(String userId, String gameId) =>
      GameProvider._(argument: (userId, gameId), from: this);

  @override
  String toString() => r'gameProvider';
}

@ProviderFor(GameActionNotifier)
final gameActionProvider = GameActionNotifierProvider._();

final class GameActionNotifierProvider
    extends $NotifierProvider<GameActionNotifier, AsyncValue<void>> {
  GameActionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameActionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameActionNotifierHash();

  @$internal
  @override
  GameActionNotifier create() => GameActionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$gameActionNotifierHash() =>
    r'fbfeb2a5f2e5432e7ef32ac5298c3cf6a49ad67e';

abstract class _$GameActionNotifier extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
