import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/date_format.dart';
import '../data/mascotas_repository.dart';
import '../domain/mascota.dart';
import 'mascotas_strings.dart';

/// Resumen de la ficha de la mascota seleccionada -- muestra lo que ya
/// tiene modelado (`docs/modelo_datos.md`) y deja "Sin especificar" en lo
/// que falta, en vez de esconder el campo. La foto real (`foto_url`) queda
/// para más adelante -- por ahora el círculo muestra solo la inicial.
class MascotaFichaCard extends ConsumerWidget {
  const MascotaFichaCard({
    required this.mascota,
    required this.onEditar,
    super.key,
  });

  final Mascota mascota;
  final VoidCallback onEditar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final razas = ref.watch(razasProvider).value;
    final colores = ref.watch(coloresProvider).value;

    final razaNombre = _nombreDe(
      razas,
      mascota.razaId,
      (r) => r.id,
      (r) => r.nombre,
    );
    final colorNombre = _nombreDe(
      colores,
      mascota.colorId,
      (c) => c.id,
      (c) => c.nombre,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Text(
                    mascota.nombre.isEmpty
                        ? '?'
                        : mascota.nombre[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    mascota.nombre,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                IconButton(
                  onPressed: onEditar,
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: MascotasStrings.editarFichaButton,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            _FichaRow(
              icon: Icons.pets_outlined,
              label: MascotasStrings.razaLabel,
              value: razaNombre,
            ),
            _FichaRow(
              icon: Icons.palette_outlined,
              label: MascotasStrings.colorLabel,
              value: colorNombre,
            ),
            _FichaRow(
              icon: Icons.cake_outlined,
              label: MascotasStrings.fechaNacimientoLabel,
              value: mascota.fechaNacimiento == null
                  ? null
                  : mascota.fechaNacimientoAproximada
                  ? MascotasStrings.fechaAproximada(
                      AppDateFormat.short(mascota.fechaNacimiento!),
                    )
                  : AppDateFormat.short(mascota.fechaNacimiento!),
            ),
            _FichaRow(
              icon: Icons.male_outlined,
              label: MascotasStrings.sexoLabel,
              value: switch (mascota.sexo) {
                'Macho' => MascotasStrings.machoLabel,
                'Hembra' => MascotasStrings.hembraLabel,
                _ => null,
              },
            ),
            _FichaRow(
              icon: Icons.monitor_weight_outlined,
              label: MascotasStrings.pesoLabel,
              value: mascota.peso == null ? null : '${mascota.peso} kg',
            ),
            _FichaRow(
              icon: Icons.notes_outlined,
              label: MascotasStrings.caracteristicasLabel,
              value: mascota.caracteristicas,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}

String? _nombreDe<T>(
  List<T>? items,
  String? id,
  String Function(T) idDe,
  String Function(T) nombreDe,
) {
  if (id == null || items == null) return null;
  for (final item in items) {
    if (idDe(item) == id) return nombreDe(item);
  }
  return null;
}

class _FichaRow extends StatelessWidget {
  const _FichaRow({
    required this.icon,
    required this.label,
    this.value,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String? value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? MascotasStrings.sinEspecificar,
              textAlign: TextAlign.end,
              style: textTheme.bodyMedium?.copyWith(
                fontStyle: value == null ? FontStyle.italic : FontStyle.normal,
                color: value == null
                    ? colorScheme.outline
                    : colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
