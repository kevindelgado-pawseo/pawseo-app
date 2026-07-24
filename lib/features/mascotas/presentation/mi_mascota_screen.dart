import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../data/mascotas_repository.dart';
import '../domain/mascota.dart';
import 'mascota_ficha_card.dart';
import 'mascota_selector.dart';
import 'mascotas_empty_state.dart';
import 'mascotas_strings.dart';

class MiMascotaScreen extends ConsumerStatefulWidget {
  const MiMascotaScreen({super.key});

  @override
  ConsumerState<MiMascotaScreen> createState() => _MiMascotaScreenState();
}

class _MiMascotaScreenState extends ConsumerState<MiMascotaScreen> {
  String? _seleccionadaId;

  @override
  Widget build(BuildContext context) {
    final mascotasAsync = ref.watch(misMascotasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(MascotasStrings.miMascotaTitle)),
      body: SafeArea(
        child: mascotasAsync.when(
          data: (mascotas) => mascotas.isEmpty
              ? const MascotasEmptyState()
              : _MiMascotaContent(
                  mascotas: mascotas,
                  seleccionadaId: _seleccionadaId,
                  onSeleccionar: (id) => setState(() => _seleccionadaId = id),
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) =>
              Center(child: Text(MascotasStrings.errorCargandoMascotas)),
        ),
      ),
    );
  }
}

class _MiMascotaContent extends StatelessWidget {
  const _MiMascotaContent({
    required this.mascotas,
    required this.seleccionadaId,
    required this.onSeleccionar,
  });

  final List<Mascota> mascotas;
  final String? seleccionadaId;
  final ValueChanged<String> onSeleccionar;

  @override
  Widget build(BuildContext context) {
    final seleccionada = mascotas.firstWhere(
      (m) => m.id == seleccionadaId,
      orElse: () => mascotas.first,
    );

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        MascotaSelector(
          mascotas: mascotas,
          seleccionadaId: seleccionada.id,
          onSeleccionar: onSeleccionar,
          onAgregar: () => context.push(AppRoutes.crearMascota),
        ),
        const SizedBox(height: 24),
        _NivelXpPlaceholder(mascota: seleccionada),
        const SizedBox(height: 24),
        MascotaFichaCard(
          mascota: seleccionada,
          onEditar: () =>
              context.push(AppRoutes.editarMascota, extra: seleccionada),
        ),
      ],
    );
  }
}

/// Visual-only por ahora -- la tabla `stats` y la curva de niveles todavía
/// no existen (ver "Pendiente" en `docs/modelo_datos.md`). Cuando se
/// diseñe la curva real, este widget pasa a leer XP/nivel de verdad en vez
/// de mostrar valores fijos.
class _NivelXpPlaceholder extends StatelessWidget {
  const _NivelXpPlaceholder({required this.mascota});

  final Mascota mascota;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  mascota.nombre,
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                Text(
                  MascotasStrings.nivelPlaceholderLabel,
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: 0.24,
                minHeight: 8,
                backgroundColor: colorScheme.surface,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              MascotasStrings.xpPlaceholderCaption,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
