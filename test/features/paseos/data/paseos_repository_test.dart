import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pawseo/core/utils/result.dart';
import 'package:pawseo/features/paseos/data/paseos_repository.dart';
import 'package:pawseo/features/paseos/domain/paseo.dart';
import 'package:supabase/supabase.dart';

Map<String, dynamic> _paseoJson({String id = 'p1', String? finalizadoEn}) => {
  'id': id,
  'iniciado_en': '2026-07-23T10:00:00Z',
  'finalizado_en': finalizadoEn,
  'pasos': null,
};

PaseosRepository _repositoryWith(
  Future<http.Response> Function(http.Request request) handler,
) {
  final client = SupabaseClient(
    'https://example.supabase.co',
    'anon-key',
    httpClient: MockClient(handler),
  );
  return PaseosRepository(client);
}

void main() {
  group('PaseosRepository.iniciarPaseo', () {
    test('crea el paseo y lo vincula a cada mascota indicada', () async {
      final linkedMascotaIds = <String>[];

      final repository = _repositoryWith((request) async {
        if (request.url.path == '/rest/v1/paseos') {
          expect(request.method, 'POST');
          return http.Response(
            jsonEncode(_paseoJson()),
            201,
            headers: {'content-type': 'application/vnd.pgrst.object+json'},
            request: request,
          );
        }

        if (request.url.path == '/rest/v1/paseos_mascotas') {
          expect(request.method, 'POST');
          final rows = jsonDecode(request.body) as List<dynamic>;
          linkedMascotaIds.addAll(rows.map((r) => (r as Map)['mascota_id'] as String));
          return http.Response(
            '[]',
            201,
            headers: {'content-type': 'application/json'},
            request: request,
          );
        }

        throw StateError('Unexpected request: ${request.url}');
      });

      final result = await repository.iniciarPaseo(['m1', 'm2']);

      expect(result, isA<Success<Paseo>>());
      expect((result as Success<Paseo>).value.id, 'p1');
      expect(linkedMascotaIds, ['m1', 'm2']);
    });

    test('devuelve Failure si la creación del paseo falla', () async {
      final repository = _repositoryWith((request) async {
        return http.Response(
          jsonEncode({'message': 'boom'}),
          500,
          headers: {'content-type': 'application/json'},
          request: request,
        );
      });

      final result = await repository.iniciarPaseo(['m1']);

      expect(result, isA<Failure<Paseo>>());
    });
  });

  group('PaseosRepository.finalizarPaseo', () {
    test('actualiza finalizado_en y devuelve el paseo cerrado', () async {
      final repository = _repositoryWith((request) async {
        expect(request.method, 'PATCH');
        expect(request.url.path, '/rest/v1/paseos');
        expect(request.url.queryParameters['id'], 'eq.p1');

        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body.containsKey('finalizado_en'), isTrue);

        return http.Response(
          jsonEncode(_paseoJson(finalizadoEn: '2026-07-23T10:30:00Z')),
          200,
          headers: {'content-type': 'application/vnd.pgrst.object+json'},
          request: request,
        );
      });

      final result = await repository.finalizarPaseo('p1');

      expect(result, isA<Success<Paseo>>());
      expect((result as Success<Paseo>).value.enCurso, isFalse);
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

      final result = await repository.finalizarPaseo('p1');

      expect(result, isA<Failure<Paseo>>());
    });
  });
}
