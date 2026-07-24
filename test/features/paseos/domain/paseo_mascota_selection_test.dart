import 'package:flutter_test/flutter_test.dart';
import 'package:pawseo/features/mascotas/domain/mascota.dart';
import 'package:pawseo/features/paseos/domain/paseo_mascota_selection.dart';

Mascota _mascota(String id) => Mascota(id: id, nombre: 'Firulais $id');

void main() {
  group('debeMostrarSelectorMascotas', () {
    test('false con cero mascotas', () {
      expect(debeMostrarSelectorMascotas([]), isFalse);
    });

    test('false con una sola mascota', () {
      expect(debeMostrarSelectorMascotas([_mascota('1')]), isFalse);
    });

    test('true con dos o más mascotas', () {
      expect(
        debeMostrarSelectorMascotas([_mascota('1'), _mascota('2')]),
        isTrue,
      );
    });
  });
}
