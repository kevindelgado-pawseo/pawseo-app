import 'package:freezed_annotation/freezed_annotation.dart';

part 'poi.freezed.dart';
part 'poi.g.dart';

@freezed
abstract class Poi with _$Poi {
  const factory Poi({
    required String id,
    required double latitud,
    required double longitud,
    required String tipoId,
    String? fotoUrl,
    required String nombre,
    String? descripcion,
    required String comuna,
    required int recompensaXp,
  }) = _Poi;

  factory Poi.fromJson(Map<String, dynamic> json) => _$PoiFromJson(json);
}
