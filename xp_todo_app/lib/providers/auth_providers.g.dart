// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authState)
final authStateProvider = AuthStateProvider._();

final class AuthStateProvider
    extends $FunctionalProvider<AsyncValue<User?>, User?, Stream<User?>>
    with $FutureModifier<User?>, $StreamProvider<User?> {
  AuthStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStateHash();

  @$internal
  @override
  $StreamProviderElement<User?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<User?> create(Ref ref) {
    return authState(ref);
  }
}

String _$authStateHash() => r'b70cdeef76207aae7866922c017307454a710c8a';

@ProviderFor(activeUserId)
final activeUserIdProvider = ActiveUserIdProvider._();

final class ActiveUserIdProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
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
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return activeUserId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$activeUserIdHash() => r'46d79baafc73e935c36b30d3ba506e741bd12b9f';

@ProviderFor(requiredAuthState)
final requiredAuthStateProvider = RequiredAuthStateProvider._();

final class RequiredAuthStateProvider
    extends $FunctionalProvider<User, User, User>
    with $Provider<User> {
  RequiredAuthStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'requiredAuthStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$requiredAuthStateHash();

  @$internal
  @override
  $ProviderElement<User> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  User create(Ref ref) {
    return requiredAuthState(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(User value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<User>(value),
    );
  }
}

String _$requiredAuthStateHash() => r'840724fc01b8106c6f0c57f885070eae22beffeb';

@ProviderFor(requiredActiveUserId)
final requiredActiveUserIdProvider = RequiredActiveUserIdProvider._();

final class RequiredActiveUserIdProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  RequiredActiveUserIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'requiredActiveUserIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$requiredActiveUserIdHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return requiredActiveUserId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$requiredActiveUserIdHash() =>
    r'bd67ad91540c8d4f1b5c56b5a881c931a2d04d2f';

@ProviderFor(idTokenResult)
final idTokenResultProvider = IdTokenResultFamily._();

final class IdTokenResultProvider
    extends
        $FunctionalProvider<
          AsyncValue<IdTokenResult?>,
          IdTokenResult?,
          FutureOr<IdTokenResult?>
        >
    with $FutureModifier<IdTokenResult?>, $FutureProvider<IdTokenResult?> {
  IdTokenResultProvider._({
    required IdTokenResultFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'idTokenResultProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$idTokenResultHash();

  @override
  String toString() {
    return r'idTokenResultProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<IdTokenResult?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<IdTokenResult?> create(Ref ref) {
    final argument = this.argument as bool;
    return idTokenResult(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IdTokenResultProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$idTokenResultHash() => r'529deb8aa7568876aca1a12ef0cbc3ec8a460a11';

final class IdTokenResultFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<IdTokenResult?>, bool> {
  IdTokenResultFamily._()
    : super(
        retry: null,
        name: r'idTokenResultProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IdTokenResultProvider call([bool forceRefresh = false]) =>
      IdTokenResultProvider._(argument: forceRefresh, from: this);

  @override
  String toString() => r'idTokenResultProvider';
}

@ProviderFor(userRoles)
final userRolesProvider = UserRolesFamily._();

final class UserRolesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserRole>>,
          AsyncValue<List<UserRole>>,
          AsyncValue<List<UserRole>>
        >
    with $Provider<AsyncValue<List<UserRole>>> {
  UserRolesProvider._({
    required UserRolesFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'userRolesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userRolesHash();

  @override
  String toString() {
    return r'userRolesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<List<UserRole>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<UserRole>> create(Ref ref) {
    final argument = this.argument as bool;
    return userRoles(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<UserRole>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<UserRole>>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UserRolesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userRolesHash() => r'a3a441ca74d861a242b06a6191f6c6200daf6f62';

final class UserRolesFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<List<UserRole>>, bool> {
  UserRolesFamily._()
    : super(
        retry: null,
        name: r'userRolesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserRolesProvider call([bool forceRefresh = false]) =>
      UserRolesProvider._(argument: forceRefresh, from: this);

  @override
  String toString() => r'userRolesProvider';
}
