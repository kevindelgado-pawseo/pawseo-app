abstract final class PaseosStrings {
  static String paseandoCon(String nombres) => 'Paseando con $nombres';
  static String pasos(int cantidad) => '$cantidad pasos';

  static const vamosAPawsearButton = '¡Vamos a pawsear!';
  static const detenerPaseoButton = 'Detener paseo';

  static const elegirMascotasTitle = '¿Con quién vas a pasear?';
  static const confirmarSeleccionButton = 'Confirmar';

  static const ubicacionServicioDesactivadoMensaje =
      'Activa la ubicación del dispositivo para poder pasear con Pawseo.';
  static const ubicacionPermisoRequeridoMensaje =
      'Pawseo necesita permiso de ubicación para trackear tu paseo.';
  static const ubicacionPrecisaRequeridaMensaje =
      'Pawseo necesita ubicación precisa (no aproximada) para trackear tu '
      'paseo y verificar los lugares que visitas. Actívala en Ajustes.';
  static const abrirAjustesButton = 'Abrir ajustes';

  static const podometroPermisoRequeridoMensaje =
      'Pawseo necesita permiso de actividad física para contar tus pasos '
      'durante el paseo.';
  static const podometroNoDisponibleMensaje =
      'Tu dispositivo no cuenta con sensor de pasos, y Pawseo lo necesita '
      'para registrar tus paseos.';
}
