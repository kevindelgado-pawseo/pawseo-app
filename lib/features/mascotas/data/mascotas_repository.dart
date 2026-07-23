import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/result.dart';
import '../domain/color_mascota.dart';
import '../domain/mascota.dart';
import '../domain/raza.dart';

part 'mascotas_repository.g.dart';

class MascotasRepository {
  MascotasRepository(this._client);

  final SupabaseClient _client;

  Future<Result<List<Mascota>>> fetchMascotas() async {
    try {
      final rows = await _client.from('mascotas').select();
      return Success(rows.map(Mascota.fromJson).toList());
    } on PostgrestException catch (_) {
      return const Failure('No se pudieron cargar tus mascotas.');
    } catch (_) {
      return const Failure('No se pudieron cargar tus mascotas.');
    }
  }

  Future<Result<Mascota>> crearMascota(String nombre) async {
    try {
      final row = await _client.from('mascotas').insert({'nombre': nombre}).select().single();
      return Success(Mascota.fromJson(row));
    } on PostgrestException catch (_) {
      return const Failure('No se pudo crear la mascota. Intenta de nuevo.');
    } catch (_) {
      return const Failure('No se pudo crear la mascota. Intenta de nuevo.');
    }
  }

  Future<Result<List<Raza>>> fetchRazas() async {
    try {
      final rows = await _client.from('razas').select();
      return Success(rows.map(Raza.fromJson).toList());
    } on PostgrestException catch (_) {
      return const Failure('No se pudieron cargar las razas.');
    } catch (_) {
      return const Failure('No se pudieron cargar las razas.');
    }
  }

  Future<Result<List<ColorMascota>>> fetchColores() async {
    try {
      final rows = await _client.from('colores').select();
      return Success(rows.map(ColorMascota.fromJson).toList());
    } on PostgrestException catch (_) {
      return const Failure('No se pudieron cargar los colores.');
    } catch (_) {
      return const Failure('No se pudieron cargar los colores.');
    }
  }
}

@riverpod
MascotasRepository mascotasRepository(Ref ref) {
  return MascotasRepository(Supabase.instance.client);
}

@riverpod
Future<List<Mascota>> misMascotas(Ref ref) async {
  final result = await ref.watch(mascotasRepositoryProvider).fetchMascotas();
  return switch (result) {
    Success(:final value) => value,
    Failure(:final message) => throw MisMascotasException(message),
  };
}

class MisMascotasException implements Exception {
  MisMascotasException(this.message);
  final String message;

  @override
  String toString() => message;
}
