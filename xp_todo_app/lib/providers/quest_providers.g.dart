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

@ProviderFor(completedUserQuests)
final completedUserQuestsProvider = CompletedUserQuestsFamily._();

final class CompletedUserQuestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Quest>>,
          List<Quest>,
          Stream<List<Quest>>
        >
    with $FutureModifier<List<Quest>>, $StreamProvider<List<Quest>> {
  CompletedUserQuestsProvider._({
    required CompletedUserQuestsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'completedUserQuestsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$completedUserQuestsHash();

  @override
  String toString() {
    return r'completedUserQuestsProvider'
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
    return completedUserQuests(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CompletedUserQuestsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$completedUserQuestsHash() =>
    r'3b48b32a94f3f48856cbd082a298f5cdd1cb6442';

final class CompletedUserQuestsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Quest>>, String> {
  CompletedUserQuestsFamily._()
    : super(
        retry: null,
        name: r'completedUserQuestsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CompletedUserQuestsProvider call(String userId) =>
      CompletedUserQuestsProvider._(argument: userId, from: this);

  @override
  String toString() => r'completedUserQuestsProvider';
}

@ProviderFor(completedGameQuests)
final completedGameQuestsProvider = CompletedGameQuestsFamily._();

final class CompletedGameQuestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Quest>>,
          List<Quest>,
          Stream<List<Quest>>
        >
    with $FutureModifier<List<Quest>>, $StreamProvider<List<Quest>> {
  CompletedGameQuestsProvider._({
    required CompletedGameQuestsFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'completedGameQuestsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$completedGameQuestsHash();

  @override
  String toString() {
    return r'completedGameQuestsProvider'
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
    return completedGameQuests(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is CompletedGameQuestsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$completedGameQuestsHash() =>
    r'03daf4eeb70353cd4356cb2373b33b0c186890bd';

final class CompletedGameQuestsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Quest>>, (String, String)> {
  CompletedGameQuestsFamily._()
    : super(
        retry: null,
        name: r'completedGameQuestsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CompletedGameQuestsProvider call(String userId, String gameId) =>
      CompletedGameQuestsProvider._(argument: (userId, gameId), from: this);

  @override
  String toString() => r'completedGameQuestsProvider';
}

@ProviderFor(activeUserIncompleteGameQuests)
final activeUserIncompleteGameQuestsProvider =
    ActiveUserIncompleteGameQuestsFamily._();

final class ActiveUserIncompleteGameQuestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Quest>?>,
          AsyncValue<List<Quest>?>,
          AsyncValue<List<Quest>?>
        >
    with $Provider<AsyncValue<List<Quest>?>> {
  ActiveUserIncompleteGameQuestsProvider._({
    required ActiveUserIncompleteGameQuestsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'activeUserIncompleteGameQuestsProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activeUserIncompleteGameQuestsHash();

  @override
  String toString() {
    return r'activeUserIncompleteGameQuestsProvider'
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
    return activeUserIncompleteGameQuests(ref, argument);
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
    return other is ActiveUserIncompleteGameQuestsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activeUserIncompleteGameQuestsHash() =>
    r'97689b36aec41dca3bd06289cd59aca02bb29289';

final class ActiveUserIncompleteGameQuestsFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<List<Quest>?>, String> {
  ActiveUserIncompleteGameQuestsFamily._()
    : super(
        retry: null,
        name: r'activeUserIncompleteGameQuestsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  ActiveUserIncompleteGameQuestsProvider call(String gameId) =>
      ActiveUserIncompleteGameQuestsProvider._(argument: gameId, from: this);

  @override
  String toString() => r'activeUserIncompleteGameQuestsProvider';
}

@ProviderFor(activeUserCompletedGameQuests)
final activeUserCompletedGameQuestsProvider =
    ActiveUserCompletedGameQuestsFamily._();

final class ActiveUserCompletedGameQuestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Quest>?>,
          AsyncValue<List<Quest>?>,
          AsyncValue<List<Quest>?>
        >
    with $Provider<AsyncValue<List<Quest>?>> {
  ActiveUserCompletedGameQuestsProvider._({
    required ActiveUserCompletedGameQuestsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'activeUserCompletedGameQuestsProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activeUserCompletedGameQuestsHash();

  @override
  String toString() {
    return r'activeUserCompletedGameQuestsProvider'
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
    return activeUserCompletedGameQuests(ref, argument);
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
    return other is ActiveUserCompletedGameQuestsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activeUserCompletedGameQuestsHash() =>
    r'36921e8ec33de36cdce05a5a0b9ce659a77bfdcb';

final class ActiveUserCompletedGameQuestsFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<List<Quest>?>, String> {
  ActiveUserCompletedGameQuestsFamily._()
    : super(
        retry: null,
        name: r'activeUserCompletedGameQuestsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  ActiveUserCompletedGameQuestsProvider call(String gameId) =>
      ActiveUserCompletedGameQuestsProvider._(argument: gameId, from: this);

  @override
  String toString() => r'activeUserCompletedGameQuestsProvider';
}

@ProviderFor(activeUserIncompleteQuests)
final activeUserIncompleteQuestsProvider =
    ActiveUserIncompleteQuestsProvider._();

final class ActiveUserIncompleteQuestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Quest>?>,
          AsyncValue<List<Quest>?>,
          AsyncValue<List<Quest>?>
        >
    with $Provider<AsyncValue<List<Quest>?>> {
  ActiveUserIncompleteQuestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeUserIncompleteQuestsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeUserIncompleteQuestsHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<Quest>?>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<Quest>?> create(Ref ref) {
    return activeUserIncompleteQuests(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Quest>?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<Quest>?>>(value),
    );
  }
}

String _$activeUserIncompleteQuestsHash() =>
    r'072f4781511594c050a61831a3bf530194e5474d';

@ProviderFor(activeUserCompletedQuests)
final activeUserCompletedQuestsProvider = ActiveUserCompletedQuestsProvider._();

final class ActiveUserCompletedQuestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Quest>?>,
          AsyncValue<List<Quest>?>,
          AsyncValue<List<Quest>?>
        >
    with $Provider<AsyncValue<List<Quest>?>> {
  ActiveUserCompletedQuestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeUserCompletedQuestsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeUserCompletedQuestsHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<Quest>?>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<Quest>?> create(Ref ref) {
    return activeUserCompletedQuests(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Quest>?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<Quest>?>>(value),
    );
  }
}

String _$activeUserCompletedQuestsHash() =>
    r'3168449afa088d02031bbfa2888034b4f47bebbb';

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
        isAutoDispose: true,
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
    r'e19222ccb13549916b07894e44c92c96a9fbd3b3';

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
         isAutoDispose: true,
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
    r'27e8718691fe61d023dd2753bce5959ed1c99366';

final class ActiveUserGameQuestsFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<List<Quest>?>, String> {
  ActiveUserGameQuestsFamily._()
    : super(
        retry: null,
        name: r'activeUserGameQuestsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
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
    r'3c66dc9470ccad99067b5ef87b65f4d7e95c45f9';

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
