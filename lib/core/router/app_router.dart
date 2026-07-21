import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/data/profile_repository.dart';
import '../../features/auth/presentation/complete_profile_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/reset_password_screen.dart';
import '../../features/debug_settings/presentation/debug_settings_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/onboarding/data/onboarding_repository.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import 'go_router_refresh_stream.dart';

part 'app_router.g.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const completeProfile = '/complete-profile';
  static const home = '/home';
  static const debugSettings = '/debug-settings';
}

const _authOnlyRoutes = {AppRoutes.login, AppRoutes.forgotPassword};

@riverpod
GoRouter appRouter(Ref ref) {
  final onboardingRepository = ref.watch(onboardingRepositoryProvider);
  final profileRepository = ref.watch(profileRepositoryProvider);
  final auth = Supabase.instance.client.auth;

  final refreshListenable = GoRouterRefreshStream(auth.onAuthStateChange);
  ref.onDispose(refreshListenable.dispose);

  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshListenable,
    redirect: (context, state) async {
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

      final session = auth.currentSession;
      if (session == null) {
        return _authOnlyRoutes.contains(location) ? null : AppRoutes.login;
      }

      if (location == AppRoutes.completeProfile) return null;

      if (!await profileRepository.hasCompletedProfile(session.user.id)) {
        return AppRoutes.completeProfile;
      }

      final isAuthOnlyScreen =
          location == AppRoutes.onboarding || _authOnlyRoutes.contains(location);
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
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.completeProfile,
        builder: (context, state) => const CompleteProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
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
