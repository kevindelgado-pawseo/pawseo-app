import 'package:flutter/material.dart';

import 'pawseo_button.dart';

/// Variante flotante de [PawseoButton] -- ancho automático (no
/// `double.infinity`) y elevación, pensada para flotar sobre contenido no
/// interactivo como un mapa, en vez de vivir al fondo de un `Column`.
class PawseoFloatingButton extends StatelessWidget {
  const PawseoFloatingButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.variant = PawseoButtonVariant.filled,
    super.key,
  });

  final String label;
  final Widget icon;
  final VoidCallback? onPressed;
  final PawseoButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return switch (variant) {
      PawseoButtonVariant.filled => FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: icon,
        label: Text(label),
      ),
      PawseoButtonVariant.outlined => FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.primary,
        icon: icon,
        label: Text(label),
      ),
    };
  }
}
