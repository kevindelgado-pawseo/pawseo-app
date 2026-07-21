import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/result.dart';

part 'profile_repository.g.dart';

class ProfileRepository {
  ProfileRepository(this._client);

  final SupabaseClient _client;

  Future<bool> hasCompletedProfile(String userId) async {
    final row = await _client
        .from('perfiles')
        .select('nombre')
        .eq('id', userId)
        .maybeSingle();
    return row?['nombre'] != null;
  }

  Future<Result<void>> updateNombre(String nombre) async {
    try {
      final userId = _client.auth.currentUser!.id;
      await _client.from('perfiles').update({'nombre': nombre}).eq('id', userId);
      return const Success(null);
    } on PostgrestException catch (e) {
      return Failure(e.message);
    } catch (_) {
      return const Failure('No se pudo guardar tu nombre. Intenta de nuevo.');
    }
  }

  /// Solo para uso en desarrollo (botón debug) — no se expone en producción.
  Future<void> clearNombreForTesting() async {
    final userId = _client.auth.currentUser!.id;
    await _client.from('perfiles').update({'nombre': null}).eq('id', userId);
  }
}

@riverpod
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepository(Supabase.instance.client);
}
