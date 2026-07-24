import 'package:flutter/material.dart';

import '../domain/mascota.dart';
import 'mascotas_strings.dart';

/// Tira horizontal para elegir de cuál mascota se están viendo los
/// detalles -- el modelo de datos soporta más de una (multi-mascota
/// simétrico), pero antes de esto el Home solo mostraba un combinado de
/// todas. El paseo en sí sigue vinculándose a todas las mascotas (ver
/// `docs/modelo_datos.md` — "Selección de con qué perro(s) salir a
/// pasear"), este selector es solo para ver/editar la ficha.
class MascotaSelector extends StatelessWidget {
  const MascotaSelector({
    required this.mascotas,
    required this.seleccionadaId,
    required this.onSeleccionar,
    required this.onAgregar,
    super.key,
  });

  final List<Mascota> mascotas;
  final String seleccionadaId;
  final ValueChanged<String> onSeleccionar;
  final VoidCallback onAgregar;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: mascotas.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          if (index == mascotas.length) {
            return _AgregarMascotaChip(onTap: onAgregar);
          }
          final mascota = mascotas[index];
          return _MascotaAvatar(
            mascota: mascota,
            seleccionada: mascota.id == seleccionadaId,
            onTap: () => onSeleccionar(mascota.id),
          );
        },
      ),
    );
  }
}

class _MascotaAvatar extends StatelessWidget {
  const _MascotaAvatar({
    required this.mascota,
    required this.seleccionada,
    required this.onTap,
  });

  final Mascota mascota;
  final bool seleccionada;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final inicial = mascota.nombre.isEmpty
        ? '?'
        : mascota.nombre[0].toUpperCase();

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: seleccionada
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest,
                border: seleccionada
                    ? Border.all(color: colorScheme.primary, width: 2)
                    : Border.all(color: colorScheme.outlineVariant),
              ),
              alignment: Alignment.center,
              child: Text(
                inicial,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: seleccionada
                      ? colorScheme.onPrimary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              mascota.nombre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: seleccionada ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AgregarMascotaChip extends StatelessWidget {
  const _AgregarMascotaChip({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: MascotasStrings.agregarMascotaTooltip,
        child: SizedBox(
          width: 64,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.outline,
                    style: BorderStyle.solid,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.add, color: colorScheme.primary),
              ),
              const SizedBox(height: 6),
              Text(
                MascotasStrings.agregarMascotaChipLabel,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
