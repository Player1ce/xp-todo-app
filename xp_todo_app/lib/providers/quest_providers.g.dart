// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userQuests)
final userQuestsProvider = UserQuestsFamily._();

final class UserQuestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Quest>>,
          List<Quest>,
          Stream<List<Quest>>
        >
    with $FutureModifier<List<Quest>>, $StreamProvider<List<Quest>> {
  UserQuestsProvider._({
    required UserQuestsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userQuestsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userQuestsHash();

  @override
  String toString() {
    return r'userQuestsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Quest>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Quest>> create(Ref ref) {
    final argument = this.argument as String;
    return userQuests(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserQuestsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userQuestsHash() => r'c888d49293828db64a9285864c69cb499590dfa7';

final class UserQuestsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Quest>>, String> {
  UserQuestsFamily._()
    : super(
        retry: null,
        name: r'userQuestsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserQuestsProvider call(String userId) =>
      UserQuestsProvider._(argument: userId, from: this);

  @override
  String toString() => r'userQuestsProvider';
}

@ProviderFor(incompleteUserQuests)
final incompleteUserQuestsProvider = IncompleteUserQuestsFamily._();

final class IncompleteUserQuestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Quest>>,
          List<Quest>,
          Stream<List<Quest>>
        >
    with $FutureModifier<List<Quest>>, $StreamProvider<List<Quest>> {
  IncompleteUserQuestsProvider._({
    required IncompleteUserQuestsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'incompleteUserQuestsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$incompleteUserQuestsHash();

  @override
  String toString() {
    return r'incompleteUserQuestsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Quest>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Quest>> create(Ref ref) {
    final argument = this.argument as String;
    return incompleteUserQuests(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IncompleteUserQuestsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$incompleteUserQuestsHash() =>
    r'1c38dc31e17e533dbac0b39ce8b121e6ceeed29d';

final class IncompleteUserQuestsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Quest>>, String> {
  IncompleteUserQuestsFamily._()
    : super(
        retry: null,
        name: r'incompleteUserQuestsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IncompleteUserQuestsProvider call(String userId) =>
      IncompleteUserQuestsProvider._(argument: userId, from: this);

  @override
  String toString() => r'incompleteUserQuestsProvider';
}

@ProviderFor(gameQuests)
final gameQuestsProvider = GameQuestsFamily._();

final class GameQuestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Quest>>,
          List<Quest>,
          Stream<List<Quest>>
        >
    with $FutureModifier<List<Quest>>, $StreamProvider<List<Quest>> {
  GameQuestsProvider._({
    required GameQuestsFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'gameQuestsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$gameQuestsHash();

  @override
  String toString() {
    return r'gameQuestsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<List<Quest>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Quest>> create(Ref ref) {
    final argument = this.argument as (String, String);
    return gameQuests(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is GameQuestsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gameQuestsHash() => r'66651db431a7e680e05af8c3fefec6ace0c2aa84';

final class GameQuestsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Quest>>, (String, String)> {
  GameQuestsFamily._()
    : super(
        retry: null,
        name: r'gameQuestsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GameQuestsProvider call(String userId, String gameId) =>
      GameQuestsProvider._(argument: (userId, gameId), from: this);

  @override
  String toString() => r'gameQuestsProvider';
}

@ProviderFor(incompleteGameQuests)
final incompleteGameQuestsProvider = IncompleteGameQuestsFamily._();

final class IncompleteGameQuestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Quest>>,
          List<Quest>,
          Stream<List<Quest>>
        >
    with $FutureModifier<List<Quest>>, $StreamProvider<List<Quest>> {
  IncompleteGameQuestsProvider._({
    required IncompleteGameQuestsFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'incompleteGameQuestsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$incompleteGameQuestsHash();

  @override
  String toString() {
    return r'incompleteGameQuestsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<List<Quest>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Quest>> create(Ref ref) {
    final argument = this.argument as (String, String);
    return incompleteGameQuests(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is IncompleteGameQuestsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$incompleteGameQuestsHash() =>
    r'93abd6dfd089cd732bffcca4641c74f02dab2fd0';

final class IncompleteGameQuestsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Quest>>, (String, String)> {
  IncompleteGameQuestsFamily._()
    : super(
        retry: null,
        name: r'incompleteGameQuestsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IncompleteGameQuestsProvider call(String userId, String gameId) =>
      IncompleteGameQuestsProvider._(argument: (userId, gameId), from: this);

  @override
  String toString() => r'incompleteGameQuestsProvider';
}

@ProviderFor(activeUserAllQuests)
final activeUserAllQuestsProvider = ActiveUserAllQuestsProvider._();

final class ActiveUserAllQuestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Quest>?>,
          AsyncValue<List<Quest>?>,
          AsyncValue<List<Quest>?>
        >
    with $Provider<AsyncValue<List<Quest>?>> {
  ActiveUserAllQuestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeUserAllQuestsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeUserAllQuestsHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<Quest>?>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<Quest>?> create(Ref ref) {
    return activeUserAllQuests(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Quest>?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<Quest>?>>(value),
    );
  }
}

String _$activeUserAllQuestsHash() =>
    r'caa233c068f7cf9adda2dff0f0874421966f84a2';

@ProviderFor(activeUserGameQuests)
final activeUserGameQuestsProvider = ActiveUserGameQuestsFamily._();

final class ActiveUserGameQuestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Quest>?>,
          AsyncValue<List<Quest>?>,
          AsyncValue<List<Quest>?>
        >
    with $Provider<AsyncValue<List<Quest>?>> {
  ActiveUserGameQuestsProvider._({
    required ActiveUserGameQuestsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'activeUserGameQuestsProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activeUserGameQuestsHash();

  @override
  String toString() {
    return r'activeUserGameQuestsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<List<Quest>?>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<Quest>?> create(Ref ref) {
    final argument = this.argument as String;
    return activeUserGameQuests(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Quest>?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<Quest>?>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveUserGameQuestsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activeUserGameQuestsHash() =>
    r'0f15bb3d09cec320b4ff84fb5fb172014dde7940';

final class ActiveUserGameQuestsFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<List<Quest>?>, String> {
  ActiveUserGameQuestsFamily._()
    : super(
        retry: null,
        name: r'activeUserGameQuestsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  ActiveUserGameQuestsProvider call(String gameId) =>
      ActiveUserGameQuestsProvider._(argument: gameId, from: this);

  @override
  String toString() => r'activeUserGameQuestsProvider';
}

@ProviderFor(quest)
final questProvider = QuestFamily._();

final class QuestProvider
    extends $FunctionalProvider<AsyncValue<Quest?>, Quest?, Stream<Quest?>>
    with $FutureModifier<Quest?>, $StreamProvider<Quest?> {
  QuestProvider._({
    required QuestFamily super.from,
    required (String, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'questProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$questHash();

  @override
  String toString() {
    return r'questProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<Quest?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Quest?> create(Ref ref) {
    final argument = this.argument as (String, String, String);
    return quest(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is QuestProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$questHash() => r'a55c8bcd84e11eb99364e40ddec0899b4040022b';

final class QuestFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Quest?>, (String, String, String)> {
  QuestFamily._()
    : super(
        retry: null,
        name: r'questProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  QuestProvider call(String userId, String gameId, String questId) =>
      QuestProvider._(argument: (userId, gameId, questId), from: this);

  @override
  String toString() => r'questProvider';
}

@ProviderFor(QuestActionNotifier)
final questActionProvider = QuestActionNotifierProvider._();

final class QuestActionNotifierProvider
    extends $NotifierProvider<QuestActionNotifier, AsyncValue<Quest?>> {
  QuestActionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'questActionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$questActionNotifierHash();

  @$internal
  @override
  QuestActionNotifier create() => QuestActionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Quest?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Quest?>>(value),
    );
  }
}

String _$questActionNotifierHash() =>
    r'c7b1d8660bc969f11d6fbd5ddef4b71ac4cf4d71';

abstract class _$QuestActionNotifier extends $Notifier<AsyncValue<Quest?>> {
  AsyncValue<Quest?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Quest?>, AsyncValue<Quest?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Quest?>, AsyncValue<Quest?>>,
              AsyncValue<Quest?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
