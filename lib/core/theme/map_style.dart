/// Estilo "cozy" para el mapa del tab Paseo: paleta cálida, y todos los
/// POIs/negocios/transporte de Google apagados -- los únicos pines
/// interactivos que quedan son los nuestros (`poi_marker_icon.dart`). Los
/// parques se mantienen visibles (verde) porque son justo los lugares por
/// donde se camina con el perro, solo se les quita el ícono/etiqueta.
///
/// Punto de partida de diseño, no definitivo -- generado a mano, no con el
/// editor visual de https://mapstyle.withgoogle.com/ (más fácil de iterar
/// mirándolo en vivo que de describir a ciegas).
abstract final class MapStyle {
  static const cozy = '''
[
  { "elementType": "geometry", "stylers": [{ "color": "#f2e8d5" }] },
  { "elementType": "labels.icon", "stylers": [{ "visibility": "off" }] },
  { "elementType": "labels.text.fill", "stylers": [{ "color": "#8a6d5b" }] },
  { "elementType": "labels.text.stroke", "stylers": [{ "color": "#f2e8d5" }] },

  { "featureType": "administrative", "elementType": "geometry", "stylers": [{ "visibility": "off" }] },
  { "featureType": "administrative.land_parcel", "stylers": [{ "visibility": "off" }] },

  { "featureType": "poi", "stylers": [{ "visibility": "off" }] },
  { "featureType": "poi.park", "elementType": "geometry.fill", "stylers": [{ "visibility": "on" }, { "color": "#d7e8c5" }] },
  { "featureType": "poi.park", "elementType": "labels", "stylers": [{ "visibility": "off" }] },

  { "featureType": "road", "elementType": "geometry", "stylers": [{ "color": "#fbf6ec" }] },
  { "featureType": "road", "elementType": "geometry.stroke", "stylers": [{ "color": "#e6d9c2" }] },
  { "featureType": "road", "elementType": "labels.text.fill", "stylers": [{ "color": "#9c8267" }] },
  { "featureType": "road.arterial", "elementType": "geometry.fill", "stylers": [{ "color": "#f3dfc0" }] },
  { "featureType": "road.arterial", "elementType": "geometry.stroke", "stylers": [{ "color": "#d9b98e" }] },
  { "featureType": "road.highway", "elementType": "geometry.fill", "stylers": [{ "color": "#e8b499" }] },
  { "featureType": "road.highway", "elementType": "geometry.stroke", "stylers": [{ "color": "#c98a5c" }] },

  { "featureType": "transit", "stylers": [{ "visibility": "off" }] },

  { "featureType": "water", "elementType": "geometry", "stylers": [{ "color": "#bcdfe3" }] },
  { "featureType": "water", "elementType": "labels", "stylers": [{ "visibility": "off" }] }
]
''';
}
