import 'package:flutter_test/flutter_test.dart';
import 'package:pawseo/core/utils/date_format.dart';

void main() {
  group('AppDateFormat.short', () {
    test('formatea con padding de dos dígitos en día y mes', () {
      expect(AppDateFormat.short(DateTime(2026, 1, 5)), '05/01/2026');
      expect(AppDateFormat.short(DateTime(2020, 12, 31)), '31/12/2020');
    });
  });
}
