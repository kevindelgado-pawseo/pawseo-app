import 'package:flutter_test/flutter_test.dart';
import 'package:pawseo/core/utils/duration_format.dart';

void main() {
  group('DurationFormat.elapsed', () {
    test('formatea segundos y minutos con padding de dos dígitos', () {
      expect(DurationFormat.elapsed(Duration.zero), '00:00');
      expect(DurationFormat.elapsed(const Duration(seconds: 5)), '00:05');
      expect(DurationFormat.elapsed(const Duration(minutes: 1, seconds: 9)), '01:09');
    });

    test('no muestra horas bajo una hora', () {
      expect(DurationFormat.elapsed(const Duration(minutes: 59, seconds: 59)), '59:59');
    });

    test('agrega horas desde una hora en adelante', () {
      expect(DurationFormat.elapsed(const Duration(hours: 1)), '1:00:00');
      expect(
        DurationFormat.elapsed(const Duration(hours: 2, minutes: 5, seconds: 3)),
        '2:05:03',
      );
    });
  });
}
