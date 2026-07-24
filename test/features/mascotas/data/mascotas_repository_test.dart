import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pawseo/core/utils/result.dart';
import 'package:pawseo/features/mascotas/data/mascotas_repository.dart';
import 'package:pawseo/features/mascotas/domain/mascota.dart';
import 'package:supabase/supabase.dart';

Map<String, dynamic> _mascotaJson({String nombre = 'Firulais'}) => {
  'id': 'a1',
  'nombre': nombre,
  'foto_url': null,
  'raza_id': null,
  'fecha_nacimiento': null,
  'fecha_nacimiento_aproximada': false,
  'color_id': null,
  'caracteristicas': null,
  'sexo': null,
  'peso': null,
  'created_at': '2026-07-23T00:00:00Z',
};

MascotasRepository _repositoryWith(
  Future<http.Response> Function(http.Request request) handler,
) {
  final client = SupabaseClient(
    'https://example.supabase.co',
    'anon-key',
    httpClient: MockClient(handler),
  );
  return MascotasRepository(client);
}

void main() {
  group('MascotasRepository.fetchMascotas', () {
    test('devuelve Success con la lista parseada', () async {
      final repository = _repositoryWith((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/rest/v1/mascotas');
        return http.Response(
          jsonEncode([_mascotaJson()]),
          200,
          headers: {'content-type': 'application/json'},
          request: request,
        );
      });

      final result = await repository.fetchMascotas();

      expect(result, isA<Success<List<Mascota>>>());
      final mascotas = (result as Success<List<Mascota>>).value;
      expect(mascotas, hasLength(1));
      expect(mascotas.single.nombre, 'Firulais');
    });

    test('devuelve Failure cuando la API responde con error', () async {
      final repository = _repositoryWith((request) async {
        return http.Response(
          jsonEncode({'message': 'boom', 'code': 'PGRST000'}),
          500,
          headers: {'content-type': 'application/json'},
          request: request,
        );
      });

      final result = await repository.fetchMascotas();

      expect(result, isA<Failure<List<Mascota>>>());
    });
  });

  group('MascotasRepository.crearMascota', () {
    test('envía el nombre y devuelve la mascota creada', () async {
      final repository = _repositoryWith((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/rest/v1/mascotas');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body, {'nombre': 'Firulais'});

        return http.Response(
          jsonEncode(_mascotaJson()),
          201,
          headers: {'content-type': 'application/vnd.pgrst.object+json'},
          request: request,
        );
      });

      final result = await repository.crearMascota('Firulais');

      expect(result, isA<Success<Mascota>>());
      expect((result as Success<Mascota>).value.nombre, 'Firulais');
    });

    test('devuelve Failure si la inserción falla', () async {
      final repository = _repositoryWith((request) async {
        return http.Response(
          jsonEncode({'message': 'nombre inválido', 'code': '23514'}),
          400,
          headers: {'content-type': 'application/json'},
          request: request,
        );
      });

      final result = await repository.crearMascota('');

      expect(result, isA<Failure<Mascota>>());
    });
  });

  group('MascotasRepository.actualizarFicha', () {
    test('envía todos los campos de la ficha y devuelve la mascota actualizada', () async {
      final repository = _repositoryWith((request) async {
        expect(request.method, 'PATCH');
        expect(request.url.path, '/rest/v1/mascotas');
        expect(request.url.queryParameters['id'], 'eq.a1');

        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body, {
          'nombre': 'Firulais',
          'raza_id': 'r1',
          'fecha_nacimiento': '2020-05-03',
          'fecha_nacimiento_aproximada': true,
          'color_id': 'c1',
          'caracteristicas': 'mancha en la oreja',
          'sexo': 'Macho',
          'peso': 8.5,
        });

        return http.Response(
          jsonEncode(_mascotaJson()),
          200,
          headers: {'content-type': 'application/vnd.pgrst.object+json'},
          request: request,
        );
      });

      final result = await repository.actualizarFicha(
        'a1',
        nombre: 'Firulais',
        razaId: 'r1',
        fechaNacimiento: DateTime(2020, 5, 3),
        fechaNacimientoAproximada: true,
        colorId: 'c1',
        caracteristicas: 'mancha en la oreja',
        sexo: 'Macho',
        peso: 8.5,
      );

      expect(result, isA<Success<Mascota>>());
    });

    test('devuelve Failure si la actualización falla', () async {
      final repository = _repositoryWith((request) async {
        return http.Response(
          jsonEncode({'message': 'boom'}),
          500,
          headers: {'content-type': 'application/json'},
          request: request,
        );
      });

      final result = await repository.actualizarFicha(
        'a1',
        nombre: 'Firulais',
        fechaNacimientoAproximada: false,
      );

      expect(result, isA<Failure<Mascota>>());
    });
  });
}
