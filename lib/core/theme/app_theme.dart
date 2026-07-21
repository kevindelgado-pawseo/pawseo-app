import 'package:flutter/material.dart';

/// Theme placeholder — no refleja identidad de marca definitiva de Pawseo,
/// solo un punto de partida coherente hasta que exista diseño real.
abstract final class AppTheme {
  static const _seedColor = Color(0xFFEE6C4D);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    ),
  );
}
