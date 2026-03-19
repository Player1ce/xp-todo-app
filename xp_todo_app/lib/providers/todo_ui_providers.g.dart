// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_ui_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedTodoGameId)
final selectedTodoGameIdProvider = SelectedTodoGameIdProvider._();

final class SelectedTodoGameIdProvider
    extends $NotifierProvider<SelectedTodoGameId, String?> {
  SelectedTodoGameIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedTodoGameIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedTodoGameIdHash();

  @$internal
  @override
  SelectedTodoGameId create() => SelectedTodoGameId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedTodoGameIdHash() =>
    r'e2ace3a7c8503244852339e93486b6dc274997a0';

abstract class _$SelectedTodoGameId extends $Notifier<String?> {
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

@ProviderFor(TodoFilter)
final todoFilterProvider = TodoFilterProvider._();

final class TodoFilterProvider
    extends $NotifierProvider<TodoFilter, TodoSegment> {
  TodoFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoFilterHash();

  @$internal
  @override
  TodoFilter create() => TodoFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TodoSegment value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TodoSegment>(value),
    );
  }
}

String _$todoFilterHash() => r'acb7f968647cd09033f6d853828e71bd233bc678';

abstract class _$TodoFilter extends $Notifier<TodoSegment> {
  TodoSegment build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TodoSegment, TodoSegment>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TodoSegment, TodoSegment>,
              TodoSegment,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
