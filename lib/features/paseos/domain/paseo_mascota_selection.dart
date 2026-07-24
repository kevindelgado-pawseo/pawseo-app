import '../../mascotas/domain/mascota.dart';

/// Con una sola mascota no tiene sentido preguntar "con cuál sales" -- se
/// pasea con ella directo. Con 2+ sí, porque pasear con todas a la vez es
/// el caso común (ver docs/modelo_datos.md) y hay que dejar elegir el
/// subconjunto.
bool debeMostrarSelectorMascotas(List<Mascota> mascotas) => mascotas.length > 1;
