// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'raza.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Raza {

 String get id; String get nombre;
/// Create a copy of Raza
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RazaCopyWith<Raza> get copyWith => _$RazaCopyWithImpl<Raza>(this as Raza, _$identity);

  /// Serializes this Raza to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Raza&&(identical(other.id, id) || other.id == id)&&(identical(other.nombre, nombre) || other.nombre == nombre));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nombre);

@override
String toString() {
  return 'Raza(id: $id, nombre: $nombre)';
}


}

/// @nodoc
abstract mixin class $RazaCopyWith<$Res>  {
  factory $RazaCopyWith(Raza value, $Res Function(Raza) _then) = _$RazaCopyWithImpl;
@useResult
$Res call({
 String id, String nombre
});




}
/// @nodoc
class _$RazaCopyWithImpl<$Res>
    implements $RazaCopyWith<$Res> {
  _$RazaCopyWithImpl(this._self, this._then);

  final Raza _self;
  final $Res Function(Raza) _then;

/// Create a copy of Raza
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nombre = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Raza].
extension RazaPatterns on Raza {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Raza value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Raza() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Raza value)  $default,){
final _that = this;
switch (_that) {
case _Raza():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Raza value)?  $default,){
final _that = this;
switch (_that) {
case _Raza() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nombre)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Raza() when $default != null:
return $default(_that.id,_that.nombre);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nombre)  $default,) {final _that = this;
switch (_that) {
case _Raza():
return $default(_that.id,_that.nombre);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nombre)?  $default,) {final _that = this;
switch (_that) {
case _Raza() when $default != null:
return $default(_that.id,_that.nombre);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Raza implements Raza {
  const _Raza({required this.id, required this.nombre});
  factory _Raza.fromJson(Map<String, dynamic> json) => _$RazaFromJson(json);

@override final  String id;
@override final  String nombre;

/// Create a copy of Raza
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RazaCopyWith<_Raza> get copyWith => __$RazaCopyWithImpl<_Raza>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RazaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Raza&&(identical(other.id, id) || other.id == id)&&(identical(other.nombre, nombre) || other.nombre == nombre));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nombre);

@override
String toString() {
  return 'Raza(id: $id, nombre: $nombre)';
}


}

/// @nodoc
abstract mixin class _$RazaCopyWith<$Res> implements $RazaCopyWith<$Res> {
  factory _$RazaCopyWith(_Raza value, $Res Function(_Raza) _then) = __$RazaCopyWithImpl;
@override @useResult
$Res call({
 String id, String nombre
});




}
/// @nodoc
class __$RazaCopyWithImpl<$Res>
    implements _$RazaCopyWith<$Res> {
  __$RazaCopyWithImpl(this._self, this._then);

  final _Raza _self;
  final $Res Function(_Raza) _then;

/// Create a copy of Raza
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nombre = null,}) {
  return _then(_Raza(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
