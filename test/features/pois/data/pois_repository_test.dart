import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pawseo/core/utils/result.dart';
import 'package:pawseo/features/pois/data/pois_repository.dart';
import 'package:pawseo/features/pois/domain/poi.dart';
import 'package:supabase/supabase.dart';

Map<String, dynamic> _poiJson({String id = 'poi1'}) => {
  'id': id,
  'latitud': -33.4372,
  'longitud': -70.6396,
  'tipo_id': 'tipo1',
  'foto_url': null,
  'nombre': 'Parque Forestal',
  'descripcion': 'Parque a orillas del río Mapocho.',
  'comuna': 'Santiago',
  'recompensa_xp': 15,
};

PoisRepository _repositoryWith(
  Future<http.Response> Function(http.Request request) handler,
) {
  final client = SupabaseClient(
    'https://example.supabase.co',
    'anon-key',
    httpClient: MockClient(handler),
  );
  return PoisRepository(client);
}

void main() {
  group('PoisRepository.fetchPois', () {
    test('devuelve la lista de POIs parseada', () async {
      final repository = _repositoryWith((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/rest/v1/pois');
        return http.Response(
          jsonEncode([_poiJson()]),
          200,
          headers: {'content-type': 'application/json'},
          request: request,
        );
      });

      final result = await repository.fetchPois();

      expect(result, isA<Success<List<Poi>>>());
      final pois = (result as Success<List<Poi>>).value;
      expect(pois, hasLength(1));
      expect(pois.single.nombre, 'Parque Forestal');
      expect(pois.single.tipoId, 'tipo1');
      expect(pois.single.recompensaXp, 15);
      expect(pois.single.fotoUrl, isNull);
    });

    test('devuelve Failure si la respuesta falla', () async {
      final repository = _repositoryWith((request) async {
        return http.Response(
          jsonEncode({'message': 'boom'}),
          500,
          headers: {'content-type': 'application/json'},
          request: request,
        );
      });

      final result = await repository.fetchPois();

      expect(result, isA<Failure<List<Poi>>>());
    });
  });
}
