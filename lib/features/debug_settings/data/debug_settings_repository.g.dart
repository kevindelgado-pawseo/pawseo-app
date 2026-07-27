// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debug_settings_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(debugSettingsRepository)
final debugSettingsRepositoryProvider = DebugSettingsRepositoryProvider._();

final class DebugSettingsRepositoryProvider
    extends
        $FunctionalProvider<
          DebugSettingsRepository,
          DebugSettingsRepository,
          DebugSettingsRepository
        >
    with $Provider<DebugSettingsRepository> {
  DebugSettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'debugSettingsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$debugSettingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<DebugSettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DebugSettingsRepository create(Ref ref) {
    return debugSettingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DebugSettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DebugSettingsRepository>(value),
    );
  }
}

String _$debugSettingsRepositoryHash() =>
    r'f78f6faeb5a9e2780b7d22ccd6c147ccdbad784e';
