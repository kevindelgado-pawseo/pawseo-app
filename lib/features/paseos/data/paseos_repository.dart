import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/result.dart';
import '../domain/paseo.dart';

part 'paseos_repository.g.dart';

class PaseosRepository {
  PaseosRepository(this._client);

  final SupabaseClient _client;

  /// Crea el paseo y lo vincula a todas las mascotas indicadas. No hay
  /// selección de "con cuál perro salgo" en esta primera versión -- se
  /// vincula a todas las mascotas del usuario (ver nota en
  /// `PaseoController`).
  Future<Result<Paseo>> iniciarPaseo(List<String> mascotaIds) async {
    try {
      final paseoRow = await _client
          .from('paseos')
          .insert({})
          .select()
          .single();
      final paseo = Paseo.fromJson(paseoRow);

      await _client
          .from('paseos_mascotas')
          .insert(
            mascotaIds
                .map((id) => {'paseo_id': paseo.id, 'mascota_id': id})
                .toList(),
          );

      return Success(paseo);
    } on PostgrestException catch (_) {
      return const Failure('No se pudo iniciar el paseo. Intenta de nuevo.');
    } catch (_) {
      return const Failure('No se pudo iniciar el paseo. Intenta de nuevo.');
    }
  }

  Future<Result<Paseo>> finalizarPaseo(String paseoId) async {
    try {
      final row = await _client
          .from('paseos')
          .update({'finalizado_en': DateTime.now().toUtc().toIso8601String()})
          .eq('id', paseoId)
          .select()
          .single();
      return Success(Paseo.fromJson(row));
    } on PostgrestException catch (_) {
      return const Failure('No se pudo detener el paseo. Intenta de nuevo.');
    } catch (_) {
      return const Failure('No se pudo detener el paseo. Intenta de nuevo.');
    }
  }
}

@riverpod
PaseosRepository paseosRepository(Ref ref) {
  return PaseosRepository(Supabase.instance.client);
}
