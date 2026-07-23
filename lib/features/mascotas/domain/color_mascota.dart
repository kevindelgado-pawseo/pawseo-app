import 'package:freezed_annotation/freezed_annotation.dart';

part 'color_mascota.freezed.dart';
part 'color_mascota.g.dart';

/// Nombrado `ColorMascota` y no `Color` para no chocar con
/// `dart:ui`/`material.Color`, que se importa en casi toda la UI.
@freezed
abstract class ColorMascota with _$ColorMascota {
  const factory ColorMascota({required String id, required String nombre}) = _ColorMascota;

  factory ColorMascota.fromJson(Map<String, dynamic> json) => _$ColorMascotaFromJson(json);
}
