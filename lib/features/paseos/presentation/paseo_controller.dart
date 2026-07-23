import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/result.dart';
import '../data/paseos_repository.dart';
import '../domain/paseo.dart';

part 'paseo_controller.g.dart';

typedef PaseoControllerState = ({Paseo? paseoActivo, bool isProcessing, String? errorMessage});

/// Estado en memoria, no persistido -- si se cierra la app a mitad de un
/// paseo, al volver a abrirla no queda "en curso" (se resuelve más
/// adelante si hace falta, no bloqueante para esta primera versión).
@riverpod
class PaseoController extends _$PaseoController {
  @override
  PaseoControllerState build() {
    return (paseoActivo: null, isProcessing: false, errorMessage: null);
  }

  Future<void> iniciar(List<String> mascotaIds) async {
    state = (paseoActivo: state.paseoActivo, isProcessing: true, errorMessage: null);

    final result = await ref.read(paseosRepositoryProvider).iniciarPaseo(mascotaIds);
    state = switch (result) {
      Success(:final value) => (paseoActivo: value, isProcessing: false, errorMessage: null),
      Failure(:final message) => (
        paseoActivo: state.paseoActivo,
        isProcessing: false,
        errorMessage: message,
      ),
    };
  }

  Future<void> detener() async {
    final activo = state.paseoActivo;
    if (activo == null) return;

    state = (paseoActivo: state.paseoActivo, isProcessing: true, errorMessage: null);

    final result = await ref.read(paseosRepositoryProvider).finalizarPaseo(activo.id);
    state = switch (result) {
      Success() => (paseoActivo: null, isProcessing: false, errorMessage: null),
      Failure(:final message) => (
        paseoActivo: state.paseoActivo,
        isProcessing: false,
        errorMessage: message,
      ),
    };
  }
}
