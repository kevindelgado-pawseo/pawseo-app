import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../auth/data/auth_repository.dart';
import '../../onboarding/data/onboarding_repository.dart';

/// Herramientas de desarrollo — la ruta solo se registra con kDebugMode
/// (ver app_router.dart), nunca alcanzable en un build de release.
/// Acá van creciendo los checks de dispositivo / feature flags que se
/// necesiten mientras se desarrolla, en vez de ensuciar pantallas reales.
class DebugSettingsScreen extends ConsumerWidget {
  const DebugSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.replay_rounded),
            title: const Text('Reiniciar onboarding'),
            subtitle: const Text('Vuelve a mostrarlo desde el inicio'),
            onTap: () async {
              await ref.read(onboardingRepositoryProvider).resetOnboarding();
              if (context.mounted) context.go(AppRoutes.onboarding);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: const Text('Cerrar sesión'),
            subtitle: const Text('Vuelve a la pantalla de login'),
            onTap: () async {
              await ref.read(authRepositoryProvider).signOut();
              if (context.mounted) context.go(AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }
}
