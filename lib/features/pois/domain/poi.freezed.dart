// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poi.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Poi {

 String get id; double get latitud; double get longitud; String get tipoId; String? get fotoUrl; String get nombre; String? get descripcion; String get comuna; int get recompensaXp;
/// Create a copy of Poi
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PoiCopyWith<Poi> get copyWith => _$PoiCopyWithImpl<Poi>(this as Poi, _$identity);

  /// Serializes this Poi to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Poi&&(identical(other.id, id) || other.id == id)&&(identical(other.latitud, latitud) || other.latitud == latitud)&&(identical(other.longitud, longitud) || other.longitud == longitud)&&(identical(other.tipoId, tipoId) || other.tipoId == tipoId)&&(identical(other.fotoUrl, fotoUrl) || other.fotoUrl == fotoUrl)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.descripcion, descripcion) || other.descripcion == descripcion)&&(identical(other.comuna, comuna) || other.comuna == comuna)&&(identical(other.recompensaXp, recompensaXp) || other.recompensaXp == recompensaXp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,latitud,longitud,tipoId,fotoUrl,nombre,descripcion,comuna,recompensaXp);

@override
String toString() {
  return 'Poi(id: $id, latitud: $latitud, longitud: $longitud, tipoId: $tipoId, fotoUrl: $fotoUrl, nombre: $nombre, descripcion: $descripcion, comuna: $comuna, recompensaXp: $recompensaXp)';
}


}

/// @nodoc
abstract mixin class $PoiCopyWith<$Res>  {
  factory $PoiCopyWith(Poi value, $Res Function(Poi) _then) = _$PoiCopyWithImpl;
@useResult
$Res call({
 String id, double latitud, double longitud, String tipoId, String? fotoUrl, String nombre, String? descripcion, String comuna, int recompensaXp
});




}
/// @nodoc
class _$PoiCopyWithImpl<$Res>
    implements $PoiCopyWith<$Res> {
  _$PoiCopyWithImpl(this._self, this._then);

  final Poi _self;
  final $Res Function(Poi) _then;

/// Create a copy of Poi
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? latitud = null,Object? longitud = null,Object? tipoId = null,Object? fotoUrl = freezed,Object? nombre = null,Object? descripcion = freezed,Object? comuna = null,Object? recompensaXp = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,latitud: null == latitud ? _self.latitud : latitud // ignore: cast_nullable_to_non_nullable
as double,longitud: null == longitud ? _self.longitud : longitud // ignore: cast_nullable_to_non_nullable
as double,tipoId: null == tipoId ? _self.tipoId : tipoId // ignore: cast_nullable_to_non_nullable
as String,fotoUrl: freezed == fotoUrl ? _self.fotoUrl : fotoUrl // ignore: cast_nullable_to_non_nullable
as String?,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,descripcion: freezed == descripcion ? _self.descripcion : descripcion // ignore: cast_nullable_to_non_nullable
as String?,comuna: null == comuna ? _self.comuna : comuna // ignore: cast_nullable_to_non_nullable
as String,recompensaXp: null == recompensaXp ? _self.recompensaXp : recompensaXp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Poi].
extension PoiPatterns on Poi {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Poi value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Poi() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Poi value)  $default,){
final _that = this;
switch (_that) {
case _Poi():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Poi value)?  $default,){
final _that = this;
switch (_that) {
case _Poi() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  double latitud,  double longitud,  String tipoId,  String? fotoUrl,  String nombre,  String? descripcion,  String comuna,  int recompensaXp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Poi() when $default != null:
return $default(_that.id,_that.latitud,_that.longitud,_that.tipoId,_that.fotoUrl,_that.nombre,_that.descripcion,_that.comuna,_that.recompensaXp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  double latitud,  double longitud,  String tipoId,  String? fotoUrl,  String nombre,  String? descripcion,  String comuna,  int recompensaXp)  $default,) {final _that = this;
switch (_that) {
case _Poi():
return $default(_that.id,_that.latitud,_that.longitud,_that.tipoId,_that.fotoUrl,_that.nombre,_that.descripcion,_that.comuna,_that.recompensaXp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  double latitud,  double longitud,  String tipoId,  String? fotoUrl,  String nombre,  String? descripcion,  String comuna,  int recompensaXp)?  $default,) {final _that = this;
switch (_that) {
case _Poi() when $default != null:
return $default(_that.id,_that.latitud,_that.longitud,_that.tipoId,_that.fotoUrl,_that.nombre,_that.descripcion,_that.comuna,_that.recompensaXp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Poi implements Poi {
  const _Poi({required this.id, required this.latitud, required this.longitud, required this.tipoId, this.fotoUrl, required this.nombre, this.descripcion, required this.comuna, required this.recompensaXp});
  factory _Poi.fromJson(Map<String, dynamic> json) => _$PoiFromJson(json);

@override final  String id;
@override final  double latitud;
@override final  double longitud;
@override final  String tipoId;
@override final  String? fotoUrl;
@override final  String nombre;
@override final  String? descripcion;
@override final  String comuna;
@override final  int recompensaXp;

/// Create a copy of Poi
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PoiCopyWith<_Poi> get copyWith => __$PoiCopyWithImpl<_Poi>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PoiToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Poi&&(identical(other.id, id) || other.id == id)&&(identical(other.latitud, latitud) || other.latitud == latitud)&&(identical(other.longitud, longitud) || other.longitud == longitud)&&(identical(other.tipoId, tipoId) || other.tipoId == tipoId)&&(identical(other.fotoUrl, fotoUrl) || other.fotoUrl == fotoUrl)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.descripcion, descripcion) || other.descripcion == descripcion)&&(identical(other.comuna, comuna) || other.comuna == comuna)&&(identical(other.recompensaXp, recompensaXp) || other.recompensaXp == recompensaXp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,latitud,longitud,tipoId,fotoUrl,nombre,descripcion,comuna,recompensaXp);

@override
String toString() {
  return 'Poi(id: $id, latitud: $latitud, longitud: $longitud, tipoId: $tipoId, fotoUrl: $fotoUrl, nombre: $nombre, descripcion: $descripcion, comuna: $comuna, recompensaXp: $recompensaXp)';
}


}

/// @nodoc
abstract mixin class _$PoiCopyWith<$Res> implements $PoiCopyWith<$Res> {
  factory _$PoiCopyWith(_Poi value, $Res Function(_Poi) _then) = __$PoiCopyWithImpl;
@override @useResult
$Res call({
 String id, double latitud, double longitud, String tipoId, String? fotoUrl, String nombre, String? descripcion, String comuna, int recompensaXp
});




}
/// @nodoc
class __$PoiCopyWithImpl<$Res>
    implements _$PoiCopyWith<$Res> {
  __$PoiCopyWithImpl(this._self, this._then);

  final _Poi _self;
  final $Res Function(_Poi) _then;

/// Create a copy of Poi
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? latitud = null,Object? longitud = null,Object? tipoId = null,Object? fotoUrl = freezed,Object? nombre = null,Object? descripcion = freezed,Object? comuna = null,Object? recompensaXp = null,}) {
  return _then(_Poi(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,latitud: null == latitud ? _self.latitud : latitud // ignore: cast_nullable_to_non_nullable
as double,longitud: null == longitud ? _self.longitud : longitud // ignore: cast_nullable_to_non_nullable
as double,tipoId: null == tipoId ? _self.tipoId : tipoId // ignore: cast_nullable_to_non_nullable
as String,fotoUrl: freezed == fotoUrl ? _self.fotoUrl : fotoUrl // ignore: cast_nullable_to_non_nullable
as String?,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,descripcion: freezed == descripcion ? _self.descripcion : descripcion // ignore: cast_nullable_to_non_nullable
as String?,comuna: null == comuna ? _self.comuna : comuna // ignore: cast_nullable_to_non_nullable
as String,recompensaXp: null == recompensaXp ? _self.recompensaXp : recompensaXp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
