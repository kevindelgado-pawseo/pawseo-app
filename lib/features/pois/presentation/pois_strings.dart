abstract final class PoisStrings {
  static const errorCargandoPois =
      'No se pudieron cargar los puntos de interés.';

  static String xpLabel(int xp) => '+$xp XP al visitar';
  static const nuncaVisitadoLabel = 'Aún no has visitado este lugar';
  static String ultimaVisitaLabel(String fecha) => 'Última visita: $fecha';
}
