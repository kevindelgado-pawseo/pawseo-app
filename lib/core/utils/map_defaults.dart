import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Centro/zoom del mapa cuando no hay (o no se pudo obtener) la ubicación
/// del usuario -- el mapa y los POIs nunca dependen de tener permiso de
/// ubicación para mostrarse, así que siempre hace falta un punto de partida.
/// Centrado en Mall Plaza Egaña (Ñuñoa), coincide con el seed real de POIs
/// de esa zona, así el fallback ya muestra pines reales y cercanos.
abstract final class MapDefaults {
  static const fallbackCenter = LatLng(-33.4529, -70.5713);
  static const fallbackZoom = 15.0;
}
