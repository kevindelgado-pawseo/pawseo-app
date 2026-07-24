import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/widgets/pawseo_button.dart';
import '../../auth/data/auth_repository.dart';
import 'perfil_strings.dart';

class PerfilScreen extends ConsumerWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final email = ref.watch(authRepositoryProvider).currentSession?.user.email;

    return Scaffold(
      appBar: AppBar(title: const Text(PerfilStrings.tabTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: colorScheme.primaryContainer,
                child: Icon(
                  Icons.person,
                  size: 32,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              if (email != null) ...[
                const SizedBox(height: 12),
                Text(
                  email,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
              const SizedBox(height: 32),
              PawseoButton(
                label: PerfilStrings.cerrarSesionButton,
                variant: PawseoButtonVariant.outlined,
                icon: const Icon(Icons.logout_rounded),
                onPressed: () async {
                  await ref.read(authRepositoryProvider).signOut();
                  if (context.mounted) context.go(AppRoutes.login);
                },
              ),
              if (kDebugMode) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => context.go(AppRoutes.debugSettings),
                  child: const Text(PerfilStrings.debugSettingsLabel),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
