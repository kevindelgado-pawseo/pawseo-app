/// El sensor de pasos (Android `TYPE_STEP_COUNTER` e iOS `CMPedometer`, ver
/// docs/specs/podometro.md) es acumulativo desde el último reinicio del
/// dispositivo, no desde que se empieza a escuchar el stream -- por eso el
/// conteo del paseo es una resta contra una lectura base, nunca una suma de
/// eventos. Si el dispositivo se reinicia a mitad de un paseo, [actual] queda
/// por debajo de [baseline] (delta negativo); se trata igual que "sin
/// sensor", devolviendo `null` en vez de un número inválido.
int? calcularPasosCaminados({required int baseline, required int actual}) {
  final delta = actual - baseline;
  return delta < 0 ? null : delta;
}
