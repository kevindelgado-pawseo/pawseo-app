import 'package:freezed_annotation/freezed_annotation.dart';

part 'mascota.freezed.dart';
part 'mascota.g.dart';

@freezed
abstract class Mascota with _$Mascota {
  const factory Mascota({
    required String id,
    required String nombre,
    String? fotoUrl,
    String? razaId,
    DateTime? fechaNacimiento,
    @Default(false) bool fechaNacimientoAproximada,
    String? colorId,
    String? caracteristicas,
    String? sexo,
    double? peso,
  }) = _Mascota;

  factory Mascota.fromJson(Map<String, dynamic> json) =>
      _$MascotaFromJson(json);
}
