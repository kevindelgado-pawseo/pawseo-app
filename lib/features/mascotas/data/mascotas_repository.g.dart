// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mascotas_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mascotasRepository)
final mascotasRepositoryProvider = MascotasRepositoryProvider._();

final class MascotasRepositoryProvider
    extends
        $FunctionalProvider<
          MascotasRepository,
          MascotasRepository,
          MascotasRepository
        >
    with $Provider<MascotasRepository> {
  MascotasRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mascotasRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mascotasRepositoryHash();

  @$internal
  @override
  $ProviderElement<MascotasRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MascotasRepository create(Ref ref) {
    return mascotasRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MascotasRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MascotasRepository>(value),
    );
  }
}

String _$mascotasRepositoryHash() =>
    r'b46b91dbf8a1ebbf6b92636eb83866c6f74a86ff';

@ProviderFor(misMascotas)
final misMascotasProvider = MisMascotasProvider._();

final class MisMascotasProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Mascota>>,
          List<Mascota>,
          FutureOr<List<Mascota>>
        >
    with $FutureModifier<List<Mascota>>, $FutureProvider<List<Mascota>> {
  MisMascotasProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'misMascotasProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$misMascotasHash();

  @$internal
  @override
  $FutureProviderElement<List<Mascota>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Mascota>> create(Ref ref) {
    return misMascotas(ref);
  }
}

String _$misMascotasHash() => r'0611097b58969009f561876435d88911b5063009';
