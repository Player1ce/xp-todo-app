// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_view_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PageIndex)
final pageIndexProvider = PageIndexFamily._();

final class PageIndexProvider extends $NotifierProvider<PageIndex, int> {
  PageIndexProvider._({
    required PageIndexFamily super.from,
    required (String, int) super.argument,
  }) : super(
         retry: null,
         name: r'pageIndexProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pageIndexHash();

  @override
  String toString() {
    return r'pageIndexProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  PageIndex create() => PageIndex();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PageIndexProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pageIndexHash() => r'e5ced46cae75226eb741b6a4b5310f3fc7914d36';

final class PageIndexFamily extends $Family
    with $ClassFamilyOverride<PageIndex, int, int, int, (String, int)> {
  PageIndexFamily._()
    : super(
        retry: null,
        name: r'pageIndexProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PageIndexProvider call(String id, int initialPage) =>
      PageIndexProvider._(argument: (id, initialPage), from: this);

  @override
  String toString() => r'pageIndexProvider';
}

abstract class _$PageIndex extends $Notifier<int> {
  late final _$args = ref.$arg as (String, int);
  String get id => _$args.$1;
  int get initialPage => _$args.$2;

  int build(String id, int initialPage);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
