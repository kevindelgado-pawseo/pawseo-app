// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mascota.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Mascota _$MascotaFromJson(Map<String, dynamic> json) => _Mascota(
  id: json['id'] as String,
  nombre: json['nombre'] as String,
  fotoUrl: json['foto_url'] as String?,
  razaId: json['raza_id'] as String?,
  fechaNacimiento: json['fecha_nacimiento'] == null
      ? null
      : DateTime.parse(json['fecha_nacimiento'] as String),
  fechaNacimientoAproximada:
      json['fecha_nacimiento_aproximada'] as bool? ?? false,
  colorId: json['color_id'] as String?,
  caracteristicas: json['caracteristicas'] as String?,
  sexo: json['sexo'] as String?,
  peso: (json['peso'] as num?)?.toDouble(),
);

Map<String, dynamic> _$MascotaToJson(_Mascota instance) => <String, dynamic>{
  'id': instance.id,
  'nombre': instance.nombre,
  'foto_url': instance.fotoUrl,
  'raza_id': instance.razaId,
  'fecha_nacimiento': instance.fechaNacimiento?.toIso8601String(),
  'fecha_nacimiento_aproximada': instance.fechaNacimientoAproximada,
  'color_id': instance.colorId,
  'caracteristicas': instance.caracteristicas,
  'sexo': instance.sexo,
  'peso': instance.peso,
};
