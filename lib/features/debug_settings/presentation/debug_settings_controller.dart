import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/debug_settings_repository.dart';

part 'debug_settings_controller.g.dart';

/// Estado reactivo para el switch de `DebugSettingsScreen` -- el repository
/// en sí no es observable (`SharedPreferences` no emite cambios), así que
/// este controller es el que le avisa a la UI cuando se togglea.
@riverpod
class OmitirRequisitoPodometro extends _$OmitirRequisitoPodometro {
  @override
  bool build() => ref.watch(debugSettingsRepositoryProvider).omitirRequisitoPodometro;

  Future<void> set(bool value) async {
    await ref.read(debugSettingsRepositoryProvider).setOmitirRequisitoPodometro(value);
    state = value;
  }
}
