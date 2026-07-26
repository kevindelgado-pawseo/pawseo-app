import 'package:flutter_test/flutter_test.dart';
import 'package:pawseo/features/paseos/domain/pasos_caminados.dart';

void main() {
  group('calcularPasosCaminados', () {
    test('resta la lectura base de la lectura actual', () {
      expect(
        calcularPasosCaminados(baseline: 1000, actual: 1350),
        350,
      );
    });

    test('cero pasos es un resultado válido, no null', () {
      expect(calcularPasosCaminados(baseline: 1000, actual: 1000), 0);
    });

    test(
      'reinicio de dispositivo a mitad de paseo (actual < baseline) da null',
      () {
        expect(calcularPasosCaminados(baseline: 1000, actual: 40), isNull);
      },
    );
  });
}
