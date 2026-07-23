// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paseos_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(paseosRepository)
final paseosRepositoryProvider = PaseosRepositoryProvider._();

final class PaseosRepositoryProvider
    extends
        $FunctionalProvider<
          PaseosRepository,
          PaseosRepository,
          PaseosRepository
        >
    with $Provider<PaseosRepository> {
  PaseosRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paseosRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paseosRepositoryHash();

  @$internal
  @override
  $ProviderElement<PaseosRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PaseosRepository create(Ref ref) {
    return paseosRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaseosRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaseosRepository>(value),
    );
  }
}

String _$paseosRepositoryHash() => r'1263b2a1392964f4ebdb9cdc9d41ad36a387eb4d';
