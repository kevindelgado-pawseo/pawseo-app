// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Poi _$PoiFromJson(Map<String, dynamic> json) => _Poi(
  id: json['id'] as String,
  latitud: (json['latitud'] as num).toDouble(),
  longitud: (json['longitud'] as num).toDouble(),
  tipoId: json['tipo_id'] as String,
  fotoUrl: json['foto_url'] as String?,
  nombre: json['nombre'] as String,
  descripcion: json['descripcion'] as String?,
  comuna: json['comuna'] as String,
  recompensaXp: (json['recompensa_xp'] as num).toInt(),
);

Map<String, dynamic> _$PoiToJson(_Poi instance) => <String, dynamic>{
  'id': instance.id,
  'latitud': instance.latitud,
  'longitud': instance.longitud,
  'tipo_id': instance.tipoId,
  'foto_url': instance.fotoUrl,
  'nombre': instance.nombre,
  'descripcion': instance.descripcion,
  'comuna': instance.comuna,
  'recompensa_xp': instance.recompensaXp,
};
