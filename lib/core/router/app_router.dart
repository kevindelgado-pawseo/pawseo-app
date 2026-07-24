import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/reset_password_screen.dart';
import '../../features/debug_settings/presentation/debug_settings_screen.dart';
import '../../features/mascotas/domain/mascota.dart';
import '../../features/mascotas/presentation/crear_mascota_screen.dart';
import '../../features/mascotas/presentation/editar_mascota_screen.dart';
import '../../features/mascotas/presentation/mi_mascota_screen.dart';
import '../../features/onboarding/data/onboarding_repository.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/paseos/presentation/paseo_screen.dart';
import '../../features/perfil/presentation/perfil_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import 'app_shell.dart';
import 'go_router_refresh_stream.dart';

part 'app_router.g.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const paseo = '/paseo';

  /// Tab "Mi Mascota" -- se mantiene el nombre `home` porque
  /// `reset_password_screen.dart`, `splash_screen.dart` y el `redirect` de
  /// acá abajo ya lo usan como "destino post-login", y ese sigue siendo su
  /// rol: ahora apunta al tab que "llama la atención" en vez de a una
  /// pantalla única.
  static const home = '/home';
  static const perfil = '/perfil';
  static const crearMascota = '/mascotas/crear';
  static const editarMascota = '/mascotas/editar';
  static const debugSettings = '/debug-settings';
}

const _authOnlyRoutes = {
  AppRoutes.login,
  AppRoutes.register,
  AppRoutes.forgotPassword,
};

@riverpod
GoRouter appRouter(Ref ref) {
  final onboardingRepository = ref.watch(onboardingRepositoryProvider);
  final auth = Supabase.instance.client.auth;

  final refreshListenable = GoRouterRefreshStream(auth.onAuthStateChange);
  ref.onDispose(refreshListenable.dispose);

  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final location = state.matchedLocation;

      // Splash controla su propia salida (espera a que se resuelva el
      // estado de sesión persistida) — nunca se le redirige desde acá.
      if (location == AppRoutes.splash) return null;

      // El link de recuperar contraseña siempre es alcanzable, sin
      // importar el estado de onboarding/sesión — llega por deep link.
      if (location == AppRoutes.resetPassword) return null;

      if (!onboardingRepository.hasSeenOnboarding) {
        return location == AppRoutes.onboarding ? null : AppRoutes.onboarding;
      }

      final isLoggedIn = auth.currentSession != null;
      if (!isLoggedIn) {
        return _authOnlyRoutes.contains(location) ? null : AppRoutes.login;
      }

      final isAuthOnlyScreen =
          location == AppRoutes.onboarding ||
          _authOnlyRoutes.contains(location);
      return isAuthOnlyScreen ? AppRoutes.home : null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.paseo,
                builder: (context, state) => const PaseoScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const MiMascotaScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.perfil,
                builder: (context, state) => const PerfilScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.crearMascota,
        builder: (context, state) => const CrearMascotaScreen(),
      ),
      GoRoute(
        path: AppRoutes.editarMascota,
        builder: (context, state) =>
            EditarMascotaScreen(mascota: state.extra! as Mascota),
      ),
      if (kDebugMode)
        GoRoute(
          path: AppRoutes.debugSettings,
          builder: (context, state) => const DebugSettingsScreen(),
        ),
    ],
  );

  // El deep link de recuperar contraseña es un custom URL scheme
  // (`pawseo://reset-password?code=...`), no un path convencional — no hay
  // garantía de que go_router lo enrute solo a partir de la URI entrante.
  // supabase_flutter sí detecta el evento de forma confiable, así que
  // navegamos explícitamente cuando ocurre.
  final recoverySubscription = auth.onAuthStateChange.listen((state) {
    if (state.event == AuthChangeEvent.passwordRecovery) {
      router.go(AppRoutes.resetPassword);
    }
  });
  ref.onDispose(recoverySubscription.cancel);

  return router;
}
