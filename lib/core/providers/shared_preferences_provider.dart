import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences_provider.g.dart';

/// Se sobreescribe en main() con la instancia real ya cargada — permite que
/// cualquier repository dependa de SharedPreferences sin lidiar con Futures.
@riverpod
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError('sharedPreferencesProvider debe overridearse en main()');
}
