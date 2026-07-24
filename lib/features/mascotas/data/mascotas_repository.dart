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
      final row = await _client
          .from('mascotas')
          .insert({'nombre': nombre})
          .select()
          .single();
      return Success(Mascota.fromJson(row));
    } on PostgrestException catch (_) {
      return const Failure('No se pudo crear la mascota. Intenta de nuevo.');
    } catch (_) {
      return const Failure('No se pudo crear la mascota. Intenta de nuevo.');
    }
  }

  /// Actualiza la ficha completa -- el formulario siempre manda el estado
  /// vigente de todos los campos (incluido `null` para "sin especificar"),
  /// no un parche parcial.
  Future<Result<Mascota>> actualizarFicha(
    String id, {
    required String nombre,
    String? razaId,
    DateTime? fechaNacimiento,
    required bool fechaNacimientoAproximada,
    String? colorId,
    String? caracteristicas,
    String? sexo,
    double? peso,
  }) async {
    try {
      final row = await _client
          .from('mascotas')
          .update({
            'nombre': nombre,
            'raza_id': razaId,
            'fecha_nacimiento': fechaNacimiento == null
                ? null
                : '${fechaNacimiento.year.toString().padLeft(4, '0')}-'
                      '${fechaNacimiento.month.toString().padLeft(2, '0')}-'
                      '${fechaNacimiento.day.toString().padLeft(2, '0')}',
            'fecha_nacimiento_aproximada': fechaNacimientoAproximada,
            'color_id': colorId,
            'caracteristicas': caracteristicas,
            'sexo': sexo,
            'peso': peso,
          })
          .eq('id', id)
          .select()
          .single();
      return Success(Mascota.fromJson(row));
    } on PostgrestException catch (_) {
      return const Failure('No se pudo guardar la ficha. Intenta de nuevo.');
    } catch (_) {
      return const Failure('No se pudo guardar la ficha. Intenta de nuevo.');
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
  return result.getOrThrow();
}

@riverpod
Future<List<Raza>> razas(Ref ref) async {
  final result = await ref.watch(mascotasRepositoryProvider).fetchRazas();
  return result.getOrThrow();
}

@riverpod
Future<List<ColorMascota>> colores(Ref ref) async {
  final result = await ref.watch(mascotasRepositoryProvider).fetchColores();
  return result.getOrThrow();
}
