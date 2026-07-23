import 'package:freezed_annotation/freezed_annotation.dart';

part 'paseo.freezed.dart';
part 'paseo.g.dart';

@freezed
abstract class Paseo with _$Paseo {
  const factory Paseo({
    required String id,
    required DateTime iniciadoEn,
    DateTime? finalizadoEn,
    int? pasos,
  }) = _Paseo;

  factory Paseo.fromJson(Map<String, dynamic> json) => _$PaseoFromJson(json);
}

extension PaseoEnCurso on Paseo {
  bool get enCurso => finalizadoEn == null;
}
