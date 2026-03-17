// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userProfile)
final userProfileProvider = UserProfileFamily._();

final class UserProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserProfile?>,
          UserProfile?,
          Stream<UserProfile?>
        >
    with $FutureModifier<UserProfile?>, $StreamProvider<UserProfile?> {
  UserProfileProvider._({
    required UserProfileFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userProfileProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userProfileHash();

  @override
  String toString() {
    return r'userProfileProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<UserProfile?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<UserProfile?> create(Ref ref) {
    final argument = this.argument as String;
    return userProfile(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserProfileProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userProfileHash() => r'38d60213bae51b1d13fdb9462440f161612f27cc';

final class UserProfileFamily extends $Family
    with $FunctionalFamilyOverride<Stream<UserProfile?>, String> {
  UserProfileFamily._()
    : super(
        retry: null,
        name: r'userProfileProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserProfileProvider call(String userId) =>
      UserProfileProvider._(argument: userId, from: this);

  @override
  String toString() => r'userProfileProvider';
}

@ProviderFor(activeUser)
final activeUserProvider = ActiveUserProvider._();

final class ActiveUserProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserProfile?>,
          AsyncValue<UserProfile?>,
          AsyncValue<UserProfile?>
        >
    with $Provider<AsyncValue<UserProfile?>> {
  ActiveUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeUserHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<UserProfile?>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<UserProfile?> create(Ref ref) {
    return activeUser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<UserProfile?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<UserProfile?>>(value),
    );
  }
}

String _$activeUserHash() => r'691d95c3c896aaeeb0652ccb4f17f52ae6104b28';

@ProviderFor(activeUserId)
final activeUserIdProvider = ActiveUserIdProvider._();

final class ActiveUserIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<String?>,
          AsyncValue<String?>,
          AsyncValue<String?>
        >
    with $Provider<AsyncValue<String?>> {
  ActiveUserIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeUserIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeUserIdHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<String?>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<String?> create(Ref ref) {
    return activeUserId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<String?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<String?>>(value),
    );
  }
}

String _$activeUserIdHash() => r'435a2bf48b4dc24614f9480451484f89f15a2eb6';

@ProviderFor(userExists)
final userExistsProvider = UserExistsFamily._();

final class UserExistsProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  UserExistsProvider._({
    required UserExistsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userExistsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userExistsHash();

  @override
  String toString() {
    return r'userExistsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as String;
    return userExists(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserExistsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userExistsHash() => r'19ff95e53a0ab438ce965cd17d8f7896a3f939fd';

final class UserExistsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, String> {
  UserExistsFamily._()
    : super(
        retry: null,
        name: r'userExistsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserExistsProvider call(String userId) =>
      UserExistsProvider._(argument: userId, from: this);

  @override
  String toString() => r'userExistsProvider';
}

@ProviderFor(UserProfileActionNotifier)
final userProfileActionProvider = UserProfileActionNotifierProvider._();

final class UserProfileActionNotifierProvider
    extends $NotifierProvider<UserProfileActionNotifier, AsyncValue<void>> {
  UserProfileActionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProfileActionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userProfileActionNotifierHash();

  @$internal
  @override
  UserProfileActionNotifier create() => UserProfileActionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$userProfileActionNotifierHash() =>
    r'5033bf040e62d548bb4bbd1f68ed96d36ec66b9a';

abstract class _$UserProfileActionNotifier extends $Notifier<AsyncValue<void>> {
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
