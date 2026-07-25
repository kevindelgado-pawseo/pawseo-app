import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../domain/poi.dart';

const _diametro = 120.0;
const _borde = 6.0;
const _tamanoEnMapa = 48.0;

/// Ícono circular para el marcador de un POI: la foto del lugar si tiene
/// (`fotoUrl`), o la inicial de su nombre sobre un fondo de color si no --
/// mismo patrón de fallback que `_MascotaAvatar` en `mascota_selector.dart`.
Future<BitmapDescriptor> buildPoiMarkerIcon(
  Poi poi, {
  required Color colorFondo,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  const center = Offset(_diametro / 2, _diametro / 2);
  const radio = _diametro / 2;

  canvas.drawCircle(center, radio, Paint()..color = Colors.white);

  final radioInterno = radio - _borde;
  canvas.save();
  canvas.clipPath(
    Path()..addOval(Rect.fromCircle(center: center, radius: radioInterno)),
  );

  final fotoUrl = poi.fotoUrl;
  final imagen = fotoUrl == null ? null : await _cargarImagenDeRed(fotoUrl);
  if (imagen != null) {
    paintImage(
      canvas: canvas,
      rect: Rect.fromCircle(center: center, radius: radioInterno),
      image: imagen,
      fit: BoxFit.cover,
    );
  } else {
    canvas.drawCircle(center, radioInterno, Paint()..color = colorFondo);
    final inicial = poi.nombre.isNotEmpty ? poi.nombre[0].toUpperCase() : '?';
    final textPainter = TextPainter(
      text: TextSpan(
        text: inicial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }
  canvas.restore();

  final picture = recorder.endRecording();
  final imagenFinal = await picture.toImage(
    _diametro.toInt(),
    _diametro.toInt(),
  );
  final byteData = await imagenFinal.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.bytes(
    byteData!.buffer.asUint8List(),
    width: _tamanoEnMapa,
    height: _tamanoEnMapa,
  );
}

Future<ui.Image?> _cargarImagenDeRed(String url) async {
  final completer = Completer<ui.Image?>();
  final stream = NetworkImage(url).resolve(const ImageConfiguration());
  late ImageStreamListener listener;
  listener = ImageStreamListener(
    (info, _) {
      completer.complete(info.image);
      stream.removeListener(listener);
    },
    onError: (error, stackTrace) {
      completer.complete(null);
      stream.removeListener(listener);
    },
  );
  stream.addListener(listener);
  return completer.future;
}
