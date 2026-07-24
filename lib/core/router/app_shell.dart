import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract final class AppShellStrings {
  static const paseoTab = 'Paseo';
  static const miMascotaTab = 'Mi mascota';
  static const perfilTab = 'Perfil';
}

/// Shell de navegación por tabs. El tab central (Mi Mascota) se destaca con
/// una insignia circular de color primario para que "llame la atención" --
/// se prefirió esto a un layout custom con overflow tipo notch, que es más
/// frágil de verificar sin poder ver la app corriendo en vivo desde acá.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.directions_walk_outlined),
            selectedIcon: Icon(Icons.directions_walk_rounded),
            label: AppShellStrings.paseoTab,
          ),
          NavigationDestination(
            icon: _MiMascotaBadge(colorScheme: colorScheme),
            label: AppShellStrings.miMascotaTab,
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: AppShellStrings.perfilTab,
          ),
        ],
      ),
    );
  }
}

class _MiMascotaBadge extends StatelessWidget {
  const _MiMascotaBadge({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.primary,
      ),
      alignment: Alignment.center,
      child: Icon(Icons.pets_rounded, color: colorScheme.onPrimary, size: 22),
    );
  }
}
