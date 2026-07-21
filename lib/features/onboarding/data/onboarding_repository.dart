import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/providers/shared_preferences_provider.dart';

part 'onboarding_repository.g.dart';

class OnboardingRepository {
  OnboardingRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _hasSeenOnboardingKey = 'has_seen_onboarding';

  bool get hasSeenOnboarding => _prefs.getBool(_hasSeenOnboardingKey) ?? false;

  Future<void> markOnboardingSeen() => _prefs.setBool(_hasSeenOnboardingKey, true);

  /// Solo para uso en desarrollo (botón debug) — no se expone en producción.
  Future<void> resetOnboarding() => _prefs.remove(_hasSeenOnboardingKey);
}

@riverpod
OnboardingRepository onboardingRepository(Ref ref) {
  return OnboardingRepository(ref.watch(sharedPreferencesProvider));
}
