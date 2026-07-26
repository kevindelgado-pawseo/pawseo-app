import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/result.dart';
import '../data/paseos_repository.dart';
import '../domain/paseo.dart';
import '../domain/pasos_caminados.dart';
import 'pasos_permiso.dart';

part 'paseo_controller.g.dart';

typedef PaseoControllerState = ({
  Paseo? paseoActivo,
  bool isProcessing,
  String? errorMessage,
  int? pasosActuales,
});

/// Estado en memoria, no persistido -- si se cierra la app a mitad de un
/// paseo, al volver a abrirla no queda "en curso" (se resuelve más
/// adelante si hace falta, no bloqueante para esta primera versión).
///
/// La suscripción al podómetro vive acá (y no en el widget, a diferencia del
/// ticker del timer en `paseo_screen.dart`) porque la lectura base tiene que
/// sobrevivir hasta que se llame `detener()`, y este provider sobrevive a un
/// rebuild del widget -- el timer en cambio es puramente cosmético, se puede
/// recalcular en cualquier momento desde `iniciadoEn`.
@riverpod
class PaseoController extends _$PaseoController {
  int? _baseline;
  StreamSubscription<StepCount>? _pasosSubscription;

  @override
  PaseoControllerState build() {
    ref.onDispose(() => _pasosSubscription?.cancel());
    return (
      paseoActivo: null,
      isProcessing: false,
      errorMessage: null,
      pasosActuales: null,
    );
  }

  Future<void> iniciar(List<String> mascotaIds) async {
    state = (
      paseoActivo: state.paseoActivo,
      isProcessing: true,
      errorMessage: null,
      pasosActuales: state.pasosActuales,
    );

    final result = await ref
        .read(paseosRepositoryProvider)
        .iniciarPaseo(mascotaIds);
    state = switch (result) {
      Success(:final value) => (
        paseoActivo: value,
        isProcessing: false,
        errorMessage: null,
        pasosActuales: null,
      ),
      Failure(:final message) => (
        paseoActivo: state.paseoActivo,
        isProcessing: false,
        errorMessage: message,
        pasosActuales: state.pasosActuales,
      ),
    };

    if (result is Success<Paseo>) {
      unawaited(_iniciarConteoPasos());
    }
  }

  Future<void> detener() async {
    final activo = state.paseoActivo;
    if (activo == null) return;

    state = (
      paseoActivo: state.paseoActivo,
      isProcessing: true,
      errorMessage: null,
      pasosActuales: state.pasosActuales,
    );

    await _pasosSubscription?.cancel();
    _pasosSubscription = null;
    _baseline = null;
    final pasos = state.pasosActuales;

    final result = await ref
        .read(paseosRepositoryProvider)
        .finalizarPaseo(activo.id, pasos: pasos);
    state = switch (result) {
      Success() => (
        paseoActivo: null,
        isProcessing: false,
        errorMessage: null,
        pasosActuales: null,
      ),
      Failure(:final message) => (
        paseoActivo: state.paseoActivo,
        isProcessing: false,
        errorMessage: message,
        pasosActuales: pasos,
      ),
    };
  }

  /// Permiso y sensor ya quedaron confirmados por
  /// `_PaseoMapaSectionState._asegurarPodometroDisponible` (`paseo_screen.dart`)
  /// antes de que exista un paseo activo -- el `request()` de acá solo
  /// reconfirma algo ya concedido. Este `try/catch` es la red de contención
  /// para el caso residual y no bloqueable de que el permiso se revoque o el
  /// stream falle a mitad de un paseo ya en curso: ahí el conteo
  /// simplemente no arranca/se corta, y `pasos` queda `null` para ese
  /// paseo específico (ver `docs/specs/podometro.md`).
  Future<void> _iniciarConteoPasos() async {
    try {
      final status = await permisoPodometro().request();
      if (!status.isGranted) return;

      await _pasosSubscription?.cancel();
      _pasosSubscription = Pedometer.stepCountStream.listen(
        _onPasoLeido,
        onError: (_) {},
      );
    } catch (_) {}
  }

  void _onPasoLeido(StepCount evento) {
    _baseline ??= evento.steps;
    final pasos = calcularPasosCaminados(
      baseline: _baseline!,
      actual: evento.steps,
    );
    if (pasos == null) return;

    state = (
      paseoActivo: state.paseoActivo,
      isProcessing: state.isProcessing,
      errorMessage: state.errorMessage,
      pasosActuales: pasos,
    );
  }
}
