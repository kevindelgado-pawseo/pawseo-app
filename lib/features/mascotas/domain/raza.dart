import 'package:freezed_annotation/freezed_annotation.dart';

part 'raza.freezed.dart';
part 'raza.g.dart';

@freezed
abstract class Raza with _$Raza {
  const factory Raza({required String id, required String nombre}) = _Raza;

  factory Raza.fromJson(Map<String, dynamic> json) => _$RazaFromJson(json);
}
