// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_ui_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
