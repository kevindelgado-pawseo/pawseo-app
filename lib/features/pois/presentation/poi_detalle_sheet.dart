import 'package:flutter/material.dart';

import '../../../core/utils/date_format.dart';
import '../domain/poi.dart';
import 'pois_strings.dart';

/// Muestra el detalle de un POI en un bottom sheet: foto, descripción, XP
/// que otorga y la última vez que se visitó. `ultimaVisita` es `null` hoy
/// para todos los POI -- no existe ningún check-in registrado todavía (el
/// check-in real, verificado por GPS, es una feature aparte, ver
/// docs/modelo_datos.md), así que "nunca visitado" es el estado real, no
/// un placeholder falso.
///
/// La sección de foto siempre reserva el mismo espacio -- si `fotoUrl` es
/// nulo o la carga falla, se ve `_PoiFotoPlaceholder` en su lugar, para
/// poder previsualizar cómo va a quedar la card antes de tener fotos reales.
Future<void> mostrarDetallePoi(
  BuildContext context,
  Poi poi, {
  DateTime? ultimaVisita,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) =>
        _PoiDetalleSheet(poi: poi, ultimaVisita: ultimaVisita),
  );
}

class _PoiDetalleSheet extends StatelessWidget {
  const _PoiDetalleSheet({required this.poi, this.ultimaVisita});

  final Poi poi;
  final DateTime? ultimaVisita;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fotoUrl = poi.fotoUrl;
    final descripcion = poi.descripcion;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: fotoUrl == null
                  ? const _PoiFotoPlaceholder()
                  : Image.network(
                      fotoUrl,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const _PoiFotoPlaceholder(),
                    ),
            ),
            const SizedBox(height: 16),
            Text(poi.nombre, style: Theme.of(context).textTheme.titleLarge),
            if (descripcion != null) ...[
              const SizedBox(height: 8),
              Text(descripcion),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.bolt_rounded, color: colorScheme.primary),
                const SizedBox(width: 4),
                Text(PoisStrings.xpLabel(poi.recompensaXp)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              ultimaVisita == null
                  ? PoisStrings.nuncaVisitadoLabel
                  : PoisStrings.ultimaVisitaLabel(
                      AppDateFormat.short(ultimaVisita!),
                    ),
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _PoiFotoPlaceholder extends StatelessWidget {
  const _PoiFotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 160,
      width: double.infinity,
      color: colorScheme.surfaceContainerHighest,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 40,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          Text(
            PoisStrings.sinFotoLabel,
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
