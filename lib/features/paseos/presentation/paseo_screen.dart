import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/duration_format.dart';
import '../../../core/widgets/pawseo_button.dart';
import '../../mascotas/data/mascotas_repository.dart';
import '../../mascotas/domain/mascota.dart';
import '../../mascotas/presentation/mascotas_empty_state.dart';
import '../../mascotas/presentation/mascotas_strings.dart';
import 'paseo_controller.dart';
import 'paseos_strings.dart';

class PaseoScreen extends ConsumerWidget {
  const PaseoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mascotasAsync = ref.watch(misMascotasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(PaseosStrings.tabTitle)),
      body: SafeArea(
        child: mascotasAsync.when(
          data: (mascotas) => mascotas.isEmpty
              ? const MascotasEmptyState()
              : _PaseoSection(mascotas: mascotas),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) =>
              Center(child: Text(MascotasStrings.errorCargandoMascotas)),
        ),
      ),
    );
  }
}

/// Vincula el paseo a TODAS las mascotas del usuario -- no hay selección de
/// "con cuál perro salgo" todavía (queda para cuando se diseñe esa parte de
/// la UI, ver `docs/modelo_datos.md`).
class _PaseoSection extends ConsumerStatefulWidget {
  const _PaseoSection({required this.mascotas});

  final List<Mascota> mascotas;

  @override
  ConsumerState<_PaseoSection> createState() => _PaseoSectionState();
}

class _PaseoSectionState extends ConsumerState<_PaseoSection> {
  Timer? _ticker;
  Duration _elapsed = Duration.zero;

  void _startTicker(DateTime iniciadoEn) {
    _ticker?.cancel();
    _updateElapsed(iniciadoEn);
    _ticker = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateElapsed(iniciadoEn),
    );
  }

  void _updateElapsed(DateTime iniciadoEn) {
    if (!mounted) return;
    setState(
      () => _elapsed = DateTime.now().toUtc().difference(iniciadoEn.toUtc()),
    );
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
    if (mounted) setState(() => _elapsed = Duration.zero);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(paseoControllerProvider, (previous, next) {
      final wasActivo = previous?.paseoActivo;
      final nowActivo = next.paseoActivo;
      if (nowActivo != null && nowActivo.id != wasActivo?.id) {
        _startTicker(nowActivo.iniciadoEn);
      } else if (nowActivo == null && wasActivo != null) {
        _stopTicker();
      }
    });

    final controllerState = ref.watch(paseoControllerProvider);
    final paseoActivo = controllerState.paseoActivo;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            PaseosStrings.paseandoCon(
              widget.mascotas.map((m) => m.nombre).join(', '),
            ),
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          if (paseoActivo != null) ...[
            Text(
              DurationFormat.elapsed(_elapsed),
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
          ],
          if (controllerState.errorMessage != null) ...[
            Text(
              controllerState.errorMessage!,
              style: TextStyle(color: colorScheme.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
          ],
          PawseoButton(
            label: paseoActivo == null
                ? PaseosStrings.iniciarPaseoButton
                : PaseosStrings.detenerPaseoButton,
            variant: paseoActivo == null
                ? PawseoButtonVariant.filled
                : PawseoButtonVariant.outlined,
            onPressed: controllerState.isProcessing
                ? null
                : () {
                    final controller = ref.read(
                      paseoControllerProvider.notifier,
                    );
                    if (paseoActivo == null) {
                      unawaited(
                        controller.iniciar(
                          widget.mascotas.map((m) => m.id).toList(),
                        ),
                      );
                    } else {
                      unawaited(controller.detener());
                    }
                  },
          ),
        ],
      ),
    );
  }
}
