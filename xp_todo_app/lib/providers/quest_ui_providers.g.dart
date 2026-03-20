// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_ui_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedQuestGameId)
final selectedQuestGameIdProvider = SelectedQuestGameIdProvider._();

final class SelectedQuestGameIdProvider
    extends $NotifierProvider<SelectedQuestGameId, String?> {
  SelectedQuestGameIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedQuestGameIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedQuestGameIdHash();

  @$internal
  @override
  SelectedQuestGameId create() => SelectedQuestGameId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedQuestGameIdHash() =>
    r'84ef0c497bb6907b1219deac0e9c6e7932b645c8';

abstract class _$SelectedQuestGameId extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(QuestFilter)
final questFilterProvider = QuestFilterProvider._();

final class QuestFilterProvider
    extends $NotifierProvider<QuestFilter, QuestSegment> {
  QuestFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'questFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$questFilterHash();

  @$internal
  @override
  QuestFilter create() => QuestFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuestSegment value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuestSegment>(value),
    );
  }
}

String _$questFilterHash() => r'fb604dc314ea93a34bda41b2405e69f9d1a0a0d1';

abstract class _$QuestFilter extends $Notifier<QuestSegment> {
  QuestSegment build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<QuestSegment, QuestSegment>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<QuestSegment, QuestSegment>,
              QuestSegment,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
