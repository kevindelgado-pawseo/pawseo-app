// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paseo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Paseo _$PaseoFromJson(Map<String, dynamic> json) => _Paseo(
  id: json['id'] as String,
  iniciadoEn: DateTime.parse(json['iniciado_en'] as String),
  finalizadoEn: json['finalizado_en'] == null
      ? null
      : DateTime.parse(json['finalizado_en'] as String),
  pasos: (json['pasos'] as num?)?.toInt(),
);

Map<String, dynamic> _$PaseoToJson(_Paseo instance) => <String, dynamic>{
  'id': instance.id,
  'iniciado_en': instance.iniciadoEn.toIso8601String(),
  'finalizado_en': instance.finalizadoEn?.toIso8601String(),
  'pasos': instance.pasos,
};
