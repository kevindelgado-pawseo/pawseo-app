import 'dart:math';

import 'poi.dart';

/// Caja delimitadora en grados planos -- no depende de Flutter (a
/// diferencia de `LatLngBounds` de `google_maps_flutter`), la conversión al
/// tipo del mapa vive en `presentation/`.
typedef LimiteGeografico = ({
  double suroesteLat,
  double suroesteLng,
  double noresteLat,
  double noresteLng,
});

/// Encuadre que incluye la posición del usuario y los POI a menos de
/// [radioMetros] -- pensado para centrar el mapa al iniciar un paseo de
/// forma que se vea la ruta hacia los POI cercanos, no solo la calle
/// inmediata. `null` si no hay ningún POI dentro del radio (el llamador
/// cae a un zoom fijo sobre la posición del usuario).
LimiteGeografico? limiteParaPoisCercanos({
  required double latitudUsuario,
  required double longitudUsuario,
  required List<Poi> pois,
  required double radioMetros,
}) {
  final cercanos = pois.where(
    (poi) =>
        _distanciaMetros(
          latitudUsuario,
          longitudUsuario,
          poi.latitud,
          poi.longitud,
        ) <=
        radioMetros,
  );
  if (cercanos.isEmpty) return null;

  final lats = [latitudUsuario, ...cercanos.map((p) => p.latitud)];
  final lngs = [longitudUsuario, ...cercanos.map((p) => p.longitud)];

  return (
    suroesteLat: lats.reduce(min),
    suroesteLng: lngs.reduce(min),
    noresteLat: lats.reduce(max),
    noresteLng: lngs.reduce(max),
  );
}

/// Distancia entre dos puntos (fórmula de Haversine, metros). Implementada
/// acá en vez de usar `Geolocator.distanceBetween` para que `domain/` no
/// dependa de un paquete de Flutter -- es matemática pura, no necesita el
/// plugin.
double _distanciaMetros(double lat1, double lng1, double lat2, double lng2) {
  const radioTierraMetros = 6371000.0;
  final dLat = _gradosARadianes(lat2 - lat1);
  final dLng = _gradosARadianes(lng2 - lng1);
  final a =
      sin(dLat / 2) * sin(dLat / 2) +
      cos(_gradosARadianes(lat1)) *
          cos(_gradosARadianes(lat2)) *
          sin(dLng / 2) *
          sin(dLng / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return radioTierraMetros * c;
}

double _gradosARadianes(double grados) => grados * pi / 180;
