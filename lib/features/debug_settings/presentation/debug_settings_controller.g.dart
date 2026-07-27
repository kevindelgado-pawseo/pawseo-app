// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debug_settings_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Estado reactivo para el switch de `DebugSettingsScreen` -- el repository
/// en sí no es observable (`SharedPreferences` no emite cambios), así que
/// este controller es el que le avisa a la UI cuando se togglea.

@ProviderFor(OmitirRequisitoPodometro)
final omitirRequisitoPodometroProvider = OmitirRequisitoPodometroProvider._();

/// Estado reactivo para el switch de `DebugSettingsScreen` -- el repository
/// en sí no es observable (`SharedPreferences` no emite cambios), así que
/// este controller es el que le avisa a la UI cuando se togglea.
final class OmitirRequisitoPodometroProvider
    extends $NotifierProvider<OmitirRequisitoPodometro, bool> {
  /// Estado reactivo para el switch de `DebugSettingsScreen` -- el repository
  /// en sí no es observable (`SharedPreferences` no emite cambios), así que
  /// este controller es el que le avisa a la UI cuando se togglea.
  OmitirRequisitoPodometroProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'omitirRequisitoPodometroProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$omitirRequisitoPodometroHash();

  @$internal
  @override
  OmitirRequisitoPodometro create() => OmitirRequisitoPodometro();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$omitirRequisitoPodometroHash() =>
    r'e4c1092c0233b08356248a35d0c7901a31e0e919';

/// Estado reactivo para el switch de `DebugSettingsScreen` -- el repository
/// en sí no es observable (`SharedPreferences` no emite cambios), así que
/// este controller es el que le avisa a la UI cuando se togglea.

abstract class _$OmitirRequisitoPodometro extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
