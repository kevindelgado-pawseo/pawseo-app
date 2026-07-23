// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mascota.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Mascota {

 String get id; String get nombre; String? get fotoUrl; String? get razaId; DateTime? get fechaNacimiento; bool get fechaNacimientoAproximada; String? get colorId; String? get caracteristicas; String? get sexo; double? get peso;
/// Create a copy of Mascota
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MascotaCopyWith<Mascota> get copyWith => _$MascotaCopyWithImpl<Mascota>(this as Mascota, _$identity);

  /// Serializes this Mascota to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Mascota&&(identical(other.id, id) || other.id == id)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.fotoUrl, fotoUrl) || other.fotoUrl == fotoUrl)&&(identical(other.razaId, razaId) || other.razaId == razaId)&&(identical(other.fechaNacimiento, fechaNacimiento) || other.fechaNacimiento == fechaNacimiento)&&(identical(other.fechaNacimientoAproximada, fechaNacimientoAproximada) || other.fechaNacimientoAproximada == fechaNacimientoAproximada)&&(identical(other.colorId, colorId) || other.colorId == colorId)&&(identical(other.caracteristicas, caracteristicas) || other.caracteristicas == caracteristicas)&&(identical(other.sexo, sexo) || other.sexo == sexo)&&(identical(other.peso, peso) || other.peso == peso));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nombre,fotoUrl,razaId,fechaNacimiento,fechaNacimientoAproximada,colorId,caracteristicas,sexo,peso);

@override
String toString() {
  return 'Mascota(id: $id, nombre: $nombre, fotoUrl: $fotoUrl, razaId: $razaId, fechaNacimiento: $fechaNacimiento, fechaNacimientoAproximada: $fechaNacimientoAproximada, colorId: $colorId, caracteristicas: $caracteristicas, sexo: $sexo, peso: $peso)';
}


}

/// @nodoc
abstract mixin class $MascotaCopyWith<$Res>  {
  factory $MascotaCopyWith(Mascota value, $Res Function(Mascota) _then) = _$MascotaCopyWithImpl;
@useResult
$Res call({
 String id, String nombre, String? fotoUrl, String? razaId, DateTime? fechaNacimiento, bool fechaNacimientoAproximada, String? colorId, String? caracteristicas, String? sexo, double? peso
});




}
/// @nodoc
class _$MascotaCopyWithImpl<$Res>
    implements $MascotaCopyWith<$Res> {
  _$MascotaCopyWithImpl(this._self, this._then);

  final Mascota _self;
  final $Res Function(Mascota) _then;

/// Create a copy of Mascota
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nombre = null,Object? fotoUrl = freezed,Object? razaId = freezed,Object? fechaNacimiento = freezed,Object? fechaNacimientoAproximada = null,Object? colorId = freezed,Object? caracteristicas = freezed,Object? sexo = freezed,Object? peso = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,fotoUrl: freezed == fotoUrl ? _self.fotoUrl : fotoUrl // ignore: cast_nullable_to_non_nullable
as String?,razaId: freezed == razaId ? _self.razaId : razaId // ignore: cast_nullable_to_non_nullable
as String?,fechaNacimiento: freezed == fechaNacimiento ? _self.fechaNacimiento : fechaNacimiento // ignore: cast_nullable_to_non_nullable
as DateTime?,fechaNacimientoAproximada: null == fechaNacimientoAproximada ? _self.fechaNacimientoAproximada : fechaNacimientoAproximada // ignore: cast_nullable_to_non_nullable
as bool,colorId: freezed == colorId ? _self.colorId : colorId // ignore: cast_nullable_to_non_nullable
as String?,caracteristicas: freezed == caracteristicas ? _self.caracteristicas : caracteristicas // ignore: cast_nullable_to_non_nullable
as String?,sexo: freezed == sexo ? _self.sexo : sexo // ignore: cast_nullable_to_non_nullable
as String?,peso: freezed == peso ? _self.peso : peso // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [Mascota].
extension MascotaPatterns on Mascota {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Mascota value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Mascota() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Mascota value)  $default,){
final _that = this;
switch (_that) {
case _Mascota():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Mascota value)?  $default,){
final _that = this;
switch (_that) {
case _Mascota() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nombre,  String? fotoUrl,  String? razaId,  DateTime? fechaNacimiento,  bool fechaNacimientoAproximada,  String? colorId,  String? caracteristicas,  String? sexo,  double? peso)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Mascota() when $default != null:
return $default(_that.id,_that.nombre,_that.fotoUrl,_that.razaId,_that.fechaNacimiento,_that.fechaNacimientoAproximada,_that.colorId,_that.caracteristicas,_that.sexo,_that.peso);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nombre,  String? fotoUrl,  String? razaId,  DateTime? fechaNacimiento,  bool fechaNacimientoAproximada,  String? colorId,  String? caracteristicas,  String? sexo,  double? peso)  $default,) {final _that = this;
switch (_that) {
case _Mascota():
return $default(_that.id,_that.nombre,_that.fotoUrl,_that.razaId,_that.fechaNacimiento,_that.fechaNacimientoAproximada,_that.colorId,_that.caracteristicas,_that.sexo,_that.peso);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nombre,  String? fotoUrl,  String? razaId,  DateTime? fechaNacimiento,  bool fechaNacimientoAproximada,  String? colorId,  String? caracteristicas,  String? sexo,  double? peso)?  $default,) {final _that = this;
switch (_that) {
case _Mascota() when $default != null:
return $default(_that.id,_that.nombre,_that.fotoUrl,_that.razaId,_that.fechaNacimiento,_that.fechaNacimientoAproximada,_that.colorId,_that.caracteristicas,_that.sexo,_that.peso);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Mascota implements Mascota {
  const _Mascota({required this.id, required this.nombre, this.fotoUrl, this.razaId, this.fechaNacimiento, this.fechaNacimientoAproximada = false, this.colorId, this.caracteristicas, this.sexo, this.peso});
  factory _Mascota.fromJson(Map<String, dynamic> json) => _$MascotaFromJson(json);

@override final  String id;
@override final  String nombre;
@override final  String? fotoUrl;
@override final  String? razaId;
@override final  DateTime? fechaNacimiento;
@override@JsonKey() final  bool fechaNacimientoAproximada;
@override final  String? colorId;
@override final  String? caracteristicas;
@override final  String? sexo;
@override final  double? peso;

/// Create a copy of Mascota
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MascotaCopyWith<_Mascota> get copyWith => __$MascotaCopyWithImpl<_Mascota>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MascotaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Mascota&&(identical(other.id, id) || other.id == id)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.fotoUrl, fotoUrl) || other.fotoUrl == fotoUrl)&&(identical(other.razaId, razaId) || other.razaId == razaId)&&(identical(other.fechaNacimiento, fechaNacimiento) || other.fechaNacimiento == fechaNacimiento)&&(identical(other.fechaNacimientoAproximada, fechaNacimientoAproximada) || other.fechaNacimientoAproximada == fechaNacimientoAproximada)&&(identical(other.colorId, colorId) || other.colorId == colorId)&&(identical(other.caracteristicas, caracteristicas) || other.caracteristicas == caracteristicas)&&(identical(other.sexo, sexo) || other.sexo == sexo)&&(identical(other.peso, peso) || other.peso == peso));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nombre,fotoUrl,razaId,fechaNacimiento,fechaNacimientoAproximada,colorId,caracteristicas,sexo,peso);

@override
String toString() {
  return 'Mascota(id: $id, nombre: $nombre, fotoUrl: $fotoUrl, razaId: $razaId, fechaNacimiento: $fechaNacimiento, fechaNacimientoAproximada: $fechaNacimientoAproximada, colorId: $colorId, caracteristicas: $caracteristicas, sexo: $sexo, peso: $peso)';
}


}

/// @nodoc
abstract mixin class _$MascotaCopyWith<$Res> implements $MascotaCopyWith<$Res> {
  factory _$MascotaCopyWith(_Mascota value, $Res Function(_Mascota) _then) = __$MascotaCopyWithImpl;
@override @useResult
$Res call({
 String id, String nombre, String? fotoUrl, String? razaId, DateTime? fechaNacimiento, bool fechaNacimientoAproximada, String? colorId, String? caracteristicas, String? sexo, double? peso
});




}
/// @nodoc
class __$MascotaCopyWithImpl<$Res>
    implements _$MascotaCopyWith<$Res> {
  __$MascotaCopyWithImpl(this._self, this._then);

  final _Mascota _self;
  final $Res Function(_Mascota) _then;

/// Create a copy of Mascota
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nombre = null,Object? fotoUrl = freezed,Object? razaId = freezed,Object? fechaNacimiento = freezed,Object? fechaNacimientoAproximada = null,Object? colorId = freezed,Object? caracteristicas = freezed,Object? sexo = freezed,Object? peso = freezed,}) {
  return _then(_Mascota(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,fotoUrl: freezed == fotoUrl ? _self.fotoUrl : fotoUrl // ignore: cast_nullable_to_non_nullable
as String?,razaId: freezed == razaId ? _self.razaId : razaId // ignore: cast_nullable_to_non_nullable
as String?,fechaNacimiento: freezed == fechaNacimiento ? _self.fechaNacimiento : fechaNacimiento // ignore: cast_nullable_to_non_nullable
as DateTime?,fechaNacimientoAproximada: null == fechaNacimientoAproximada ? _self.fechaNacimientoAproximada : fechaNacimientoAproximada // ignore: cast_nullable_to_non_nullable
as bool,colorId: freezed == colorId ? _self.colorId : colorId // ignore: cast_nullable_to_non_nullable
as String?,caracteristicas: freezed == caracteristicas ? _self.caracteristicas : caracteristicas // ignore: cast_nullable_to_non_nullable
as String?,sexo: freezed == sexo ? _self.sexo : sexo // ignore: cast_nullable_to_non_nullable
as String?,peso: freezed == peso ? _self.peso : peso // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
