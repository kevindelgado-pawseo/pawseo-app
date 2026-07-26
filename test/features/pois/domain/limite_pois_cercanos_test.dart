import 'package:flutter_test/flutter_test.dart';
import 'package:pawseo/features/pois/domain/limite_pois_cercanos.dart';
import 'package:pawseo/features/pois/domain/poi.dart';

Poi _poi(String id, {required double latitud, required double longitud}) =>
    Poi(
      id: id,
      latitud: latitud,
      longitud: longitud,
      tipoId: 't1',
      nombre: 'POI $id',
      comuna: 'Ñuñoa',
      recompensaXp: 10,
    );

void main() {
  group('limiteParaPoisCercanos', () {
    const usuarioLat = -33.4529;
    const usuarioLng = -70.5713;

    test('null si no hay ningún POI', () {
      final limite = limiteParaPoisCercanos(
        latitudUsuario: usuarioLat,
        longitudUsuario: usuarioLng,
        pois: const [],
        radioMetros: 1000,
      );

      expect(limite, isNull);
    });

    test('null si el único POI está fuera del radio', () {
      final lejano = _poi(
        'lejano',
        latitud: usuarioLat + 1,
        longitud: usuarioLng,
      );

      final limite = limiteParaPoisCercanos(
        latitudUsuario: usuarioLat,
        longitudUsuario: usuarioLng,
        pois: [lejano],
        radioMetros: 1000,
      );

      expect(limite, isNull);
    });

    test('incluye un POI dentro del radio en el límite', () {
      final cercano = _poi(
        'cercano',
        latitud: usuarioLat + 0.002,
        longitud: usuarioLng,
      );

      final limite = limiteParaPoisCercanos(
        latitudUsuario: usuarioLat,
        longitudUsuario: usuarioLng,
        pois: [cercano],
        radioMetros: 1000,
      );

      expect(limite, isNotNull);
      expect(limite!.suroesteLat, usuarioLat);
      expect(limite.noresteLat, cercano.latitud);
    });

    test('ignora POIs fuera del radio aunque haya otros cerca', () {
      final cercano = _poi(
        'cercano',
        latitud: usuarioLat + 0.002,
        longitud: usuarioLng,
      );
      final lejano = _poi(
        'lejano',
        latitud: usuarioLat + 1,
        longitud: usuarioLng,
      );

      final limite = limiteParaPoisCercanos(
        latitudUsuario: usuarioLat,
        longitudUsuario: usuarioLng,
        pois: [cercano, lejano],
        radioMetros: 1000,
      );

      expect(limite, isNotNull);
      expect(limite!.noresteLat, lessThan(lejano.latitud));
    });
  });
}
