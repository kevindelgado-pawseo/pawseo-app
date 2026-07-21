import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../auth/data/auth_repository.dart';

/// Punto de entrada único de la app — espera a que termine de resolverse
/// el estado de auth persistido (evita el flash de login antes de saber si
/// hay sesión) y es el lugar donde agregar futuras cargas de arranque
/// (config remota, feature flags, etc.). El router decide el destino real
/// una vez que salimos de acá — este screen no conoce esa lógica.
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authStateChangesProvider, (previous, next) {
      if (!next.isLoading) context.go(AppRoutes.home);
    });

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Center(
        child: Icon(Icons.pets_rounded, size: 96, color: colorScheme.onPrimary),
      ),
    );
  }
}
