// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pois_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(poisRepository)
final poisRepositoryProvider = PoisRepositoryProvider._();

final class PoisRepositoryProvider
    extends $FunctionalProvider<PoisRepository, PoisRepository, PoisRepository>
    with $Provider<PoisRepository> {
  PoisRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'poisRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$poisRepositoryHash();

  @$internal
  @override
  $ProviderElement<PoisRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PoisRepository create(Ref ref) {
    return poisRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PoisRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PoisRepository>(value),
    );
  }
}

String _$poisRepositoryHash() => r'5058c5182634bd43872c7b66de9d72e541fc624c';

@ProviderFor(pois)
final poisProvider = PoisProvider._();

final class PoisProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Poi>>,
          List<Poi>,
          FutureOr<List<Poi>>
        >
    with $FutureModifier<List<Poi>>, $FutureProvider<List<Poi>> {
  PoisProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'poisProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$poisHash();

  @$internal
  @override
  $FutureProviderElement<List<Poi>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Poi>> create(Ref ref) {
    return pois(ref);
  }
}

String _$poisHash() => r'3dcebd6b05d26155f0288836b793718ffd641d75';
