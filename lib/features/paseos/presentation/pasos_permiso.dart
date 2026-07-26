import 'dart:io' show Platform;

import 'package:permission_handler/permission_handler.dart';

/// `Permission.activityRecognition` es un concepto solo-Android; en iOS no
/// tiene estrategia propia y no dispara ningún diálogo real. El permiso que
/// sí gatilla el diálogo nativo de "Motion & Fitness" en iOS es
/// `Permission.sensors` (verificado en el código fuente de
/// `permission_handler_apple`, ver `docs/specs/podometro.md`).
Permission permisoPodometro() =>
    Platform.isIOS ? Permission.sensors : Permission.activityRecognition;
