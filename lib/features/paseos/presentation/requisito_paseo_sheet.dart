import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/widgets/pawseo_button.dart';
import 'paseos_strings.dart';

/// Sheet compartido para los casos en que el paseo no puede arrancar por un
/// requisito no cumplido (ubicación o podómetro) -- mismo molde, distinto
/// ícono/mensaje/destino de Ajustes según el caso. [onAbrirAjustes] es
/// nullable: hay casos sin nada que corregir en Ajustes (ej. el
/// dispositivo no tiene el sensor de pasos), y ahí no se muestra el botón.
Future<void> mostrarRequisitoPaseo(
  BuildContext context, {
  required IconData icono,
  required String mensaje,
  Future<bool> Function()? onAbrirAjustes,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _RequisitoPaseoSheet(
      icono: icono,
      mensaje: mensaje,
      onAbrirAjustes: onAbrirAjustes,
    ),
  );
}

class _RequisitoPaseoSheet extends StatelessWidget {
  const _RequisitoPaseoSheet({
    required this.icono,
    required this.mensaje,
    this.onAbrirAjustes,
  });

  final IconData icono;
  final String mensaje;
  final Future<bool> Function()? onAbrirAjustes;

  @override
  Widget build(BuildContext context) {
    final onAbrirAjustes = this.onAbrirAjustes;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(icono, size: 40, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(mensaje, textAlign: TextAlign.center),
            if (onAbrirAjustes != null) ...[
              const SizedBox(height: 16),
              PawseoButton(
                label: PaseosStrings.abrirAjustesButton,
                onPressed: () {
                  unawaited(onAbrirAjustes());
                  Navigator.of(context).pop();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
