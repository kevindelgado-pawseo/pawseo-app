// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paseo_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Estado en memoria, no persistido -- si se cierra la app a mitad de un
/// paseo, al volver a abrirla no queda "en curso" (se resuelve más
/// adelante si hace falta, no bloqueante para esta primera versión).

@ProviderFor(PaseoController)
final paseoControllerProvider = PaseoControllerProvider._();

/// Estado en memoria, no persistido -- si se cierra la app a mitad de un
/// paseo, al volver a abrirla no queda "en curso" (se resuelve más
/// adelante si hace falta, no bloqueante para esta primera versión).
final class PaseoControllerProvider
    extends $NotifierProvider<PaseoController, PaseoControllerState> {
  /// Estado en memoria, no persistido -- si se cierra la app a mitad de un
  /// paseo, al volver a abrirla no queda "en curso" (se resuelve más
  /// adelante si hace falta, no bloqueante para esta primera versión).
  PaseoControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paseoControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paseoControllerHash();

  @$internal
  @override
  PaseoController create() => PaseoController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaseoControllerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaseoControllerState>(value),
    );
  }
}

String _$paseoControllerHash() => r'cdb0e9a52dc9039d254e242b1799b7c5459c827e';

/// Estado en memoria, no persistido -- si se cierra la app a mitad de un
/// paseo, al volver a abrirla no queda "en curso" (se resuelve más
/// adelante si hace falta, no bloqueante para esta primera versión).

abstract class _$PaseoController extends $Notifier<PaseoControllerState> {
  PaseoControllerState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PaseoControllerState, PaseoControllerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PaseoControllerState, PaseoControllerState>,
              PaseoControllerState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
