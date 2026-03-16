// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(quests)
final questsProvider = QuestsFamily._();

final class QuestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Quest>>,
          List<Quest>,
          Stream<List<Quest>>
        >
    with $FutureModifier<List<Quest>>, $StreamProvider<List<Quest>> {
  QuestsProvider._({
    required QuestsFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'questsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$questsHash();

  @override
  String toString() {
    return r'questsProvider'
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
    return quests(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is QuestsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$questsHash() => r'4fdfa52c6f268c65f060de320f3beefa91d029b4';

final class QuestsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Quest>>, (String, String)> {
  QuestsFamily._()
    : super(
        retry: null,
        name: r'questsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  QuestsProvider call(String userId, String gameId) =>
      QuestsProvider._(argument: (userId, gameId), from: this);

  @override
  String toString() => r'questsProvider';
}

@ProviderFor(activeQuests)
final activeQuestsProvider = ActiveQuestsFamily._();

final class ActiveQuestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Quest>>,
          AsyncValue<List<Quest>>,
          AsyncValue<List<Quest>>
        >
    with $Provider<AsyncValue<List<Quest>>> {
  ActiveQuestsProvider._({
    required ActiveQuestsFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'activeQuestsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activeQuestsHash();

  @override
  String toString() {
    return r'activeQuestsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<List<Quest>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<Quest>> create(Ref ref) {
    final argument = this.argument as (String, String);
    return activeQuests(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Quest>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<Quest>>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveQuestsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activeQuestsHash() => r'c423299f63725f8feb4947579c630a4e77b21cf8';

final class ActiveQuestsFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<List<Quest>>, (String, String)> {
  ActiveQuestsFamily._()
    : super(
        retry: null,
        name: r'activeQuestsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ActiveQuestsProvider call(String userId, String gameId) =>
      ActiveQuestsProvider._(argument: (userId, gameId), from: this);

  @override
  String toString() => r'activeQuestsProvider';
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
    extends $NotifierProvider<QuestActionNotifier, AsyncValue<void>> {
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
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$questActionNotifierHash() =>
    r'1c612fb382a17f99aec5aa1b80ef6f0532fbd043';

abstract class _$QuestActionNotifier extends $Notifier<AsyncValue<void>> {
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
