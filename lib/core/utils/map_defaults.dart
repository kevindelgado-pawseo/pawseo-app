import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Centro/zoom del mapa cuando no hay (o no se pudo obtener) la ubicación
/// del usuario -- el mapa y los POIs nunca dependen de tener permiso de
/// ubicación para mostrarse, así que siempre hace falta un punto de partida.
/// Coincide con el ancla del seed de POIs (Santiago Centro), así el
/// fallback ya muestra pines reales.
abstract final class MapDefaults {
  static const fallbackCenter = LatLng(-33.4372, -70.6396);
  static const fallbackZoom = 13.0;
}
