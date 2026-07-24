import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/widgets/pawseo_button.dart';
import 'mascotas_strings.dart';

/// Compartido entre el tab de Paseo y el tab Mi Mascota -- ambos necesitan
/// el mismo estado vacío cuando el usuario todavía no tiene mascotas.
class MascotasEmptyState extends StatelessWidget {
  const MascotasEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '🐶',
            style: TextStyle(fontSize: 48),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            MascotasStrings.emptyStateTitle,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(MascotasStrings.emptyStateSubtitle, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          PawseoButton(
            label: MascotasStrings.agregarMascotaButton,
            onPressed: () => context.push(AppRoutes.crearMascota),
          ),
        ],
      ),
    );
  }
}
