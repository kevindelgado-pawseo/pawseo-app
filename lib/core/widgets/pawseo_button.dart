import 'package:flutter/material.dart';

enum PawseoButtonVariant { filled, outlined }

/// Botón reutilizable del design system — evita duplicar estilos de botón
/// entre onboarding, login y el resto de features.
class PawseoButton extends StatelessWidget {
  const PawseoButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = PawseoButtonVariant.filled,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final PawseoButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final child = icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [icon!, const SizedBox(width: 12), Text(label)],
          );

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: switch (variant) {
        PawseoButtonVariant.filled => FilledButton(
          onPressed: onPressed,
          child: child,
        ),
        PawseoButtonVariant.outlined => OutlinedButton(
          onPressed: onPressed,
          child: child,
        ),
      },
    );
  }
}
