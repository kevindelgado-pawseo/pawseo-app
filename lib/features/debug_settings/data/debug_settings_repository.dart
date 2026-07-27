import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/providers/shared_preferences_provider.dart';

part 'debug_settings_repository.g.dart';

class DebugSettingsRepository {
  DebugSettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _omitirRequisitoPodometroKey =
      'debug_omitir_requisito_podometro';

  /// Solo tiene efecto en `kDebugMode` (ver `paseo_screen.dart`) -- en un
  /// build de release esta clave nunca llega a valer `true` porque la
  /// pantalla que la setea ni siquiera se registra como ruta.
  bool get omitirRequisitoPodometro =>
      _prefs.getBool(_omitirRequisitoPodometroKey) ?? false;

  Future<void> setOmitirRequisitoPodometro(bool value) => value
      ? _prefs.setBool(_omitirRequisitoPodometroKey, true)
      : _prefs.remove(_omitirRequisitoPodometroKey);
}

@riverpod
DebugSettingsRepository debugSettingsRepository(Ref ref) {
  return DebugSettingsRepository(ref.watch(sharedPreferencesProvider));
}
