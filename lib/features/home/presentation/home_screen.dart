import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import 'home_strings.dart';

/// Stub — destino temporal después del login mock, para poder ver el flujo
/// de principio a fin. La Home real es un spec aparte.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🚧', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(HomeStrings.underConstruction, style: Theme.of(context).textTheme.titleLarge),
            if (kDebugMode) ...[
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => context.go(AppRoutes.debugSettings),
                child: const Text('🔧 Debug settings'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
