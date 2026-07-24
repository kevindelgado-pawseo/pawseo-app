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

String _$misMascotasHash() => r'5f1f01e044d4a022057cf59ba49ed2705646b4e2';

@ProviderFor(razas)
final razasProvider = RazasProvider._();

final class RazasProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Raza>>,
          List<Raza>,
          FutureOr<List<Raza>>
        >
    with $FutureModifier<List<Raza>>, $FutureProvider<List<Raza>> {
  RazasProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'razasProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$razasHash();

  @$internal
  @override
  $FutureProviderElement<List<Raza>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Raza>> create(Ref ref) {
    return razas(ref);
  }
}

String _$razasHash() => r'20f7aa37eb35d359b68a4b16dda25fc02d530e1c';

@ProviderFor(colores)
final coloresProvider = ColoresProvider._();

final class ColoresProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ColorMascota>>,
          List<ColorMascota>,
          FutureOr<List<ColorMascota>>
        >
    with
        $FutureModifier<List<ColorMascota>>,
        $FutureProvider<List<ColorMascota>> {
  ColoresProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coloresProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coloresHash();

  @$internal
  @override
  $FutureProviderElement<List<ColorMascota>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ColorMascota>> create(Ref ref) {
    return colores(ref);
  }
}

String _$coloresHash() => r'525004bdaa54147a0e144b27838d5a42098b7dbb';
