import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/result.dart';
import '../domain/poi.dart';

part 'pois_repository.g.dart';

class PoisRepository {
  PoisRepository(this._client);

  final SupabaseClient _client;

  Future<Result<List<Poi>>> fetchPois() async {
    try {
      final rows = await _client.from('pois').select();
      return Success(rows.map(Poi.fromJson).toList());
    } on PostgrestException catch (_) {
      return const Failure('No se pudieron cargar los puntos de interés.');
    } catch (_) {
      return const Failure('No se pudieron cargar los puntos de interés.');
    }
  }
}

@riverpod
PoisRepository poisRepository(Ref ref) {
  return PoisRepository(Supabase.instance.client);
}

@riverpod
Future<List<Poi>> pois(Ref ref) async {
  final result = await ref.watch(poisRepositoryProvider).fetchPois();
  return result.getOrThrow();
}
