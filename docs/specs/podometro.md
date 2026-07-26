# Spec: Podómetro durante el paseo

**Estado:** Borrador
**Fecha:** 2026-07-25
**Relacionado con:** `docs/producto.md` §7 (MVP: "sesión de paseo por tiempo y pasos"), §9 (riesgo de dispositivos sin sensor -- revisado 2026-07-26, ver §6 de este spec: ya no es degradación, es exclusión de la función).

---

## 1. Resumen

Cuenta los pasos caminados durante un paseo activo usando el sensor de actividad física del dispositivo, y guarda el total en `paseos.pasos`.

## 2. Por qué (motivación)

`producto.md` §7 pide explícitamente sesión "por tiempo **y pasos**" — hoy el tab Paseo solo mide tiempo; `paseos.pasos` existe como columna desde la migración original pero queda siempre `null`.

## 3. Qué incluye este spec

- Lectura del sensor de pasos del dispositivo mientras un paseo está activo, vía el paquete `pedometer` (envuelve `TYPE_STEP_COUNTER` en Android, `CMPedometer` en iOS) + `permission_handler` para el permiso.
- Guardar el conteo final en `paseos.pasos` al finalizar el paseo.
- **Podómetro obligatorio para pasear** (decisión revisada 2026-07-26, pedido explícito de Kevin -- invierte la decisión original de este mismo spec y la de `producto.md` §9): al tocar "¡Vamos a pawsear!" se exige permiso concedido **y** que el sensor realmente responda. Si cualquiera de los dos falla, el paseo no arranca -- se muestra una explicación en vez de guardar el paseo sin ese dato. Ver §6 para el detalle de cada caso.
- Conteo de pasos en vivo, visible junto al timer mientras el paseo está en curso (no solo guardado al final).

## 4. Fuera de este spec

- Tracking de la ruta GPS caminada — explícitamente fuera del MVP.
- Gráficos históricos de pasos o metas configurables.
- Cualquier verificación de que los pasos correspondan a un paseo real (anti-fraude) — se confía en el sensor del sistema tal cual.

## 5. Flujo esperado

1. Usuario toca "¡Vamos a pawsear!".
2. La app pide el permiso de actividad física (`Permission.activityRecognition` en Android, `Permission.sensors` en iOS -- son permisos distintos, no el mismo en ambas plataformas) y verifica que el sensor realmente responda (ver §6). Si cualquiera falla, se muestra una explicación y el paseo no arranca.
3. Si todo pasa, empieza a leer el sensor -- el conteo se ve en vivo junto al timer.
4. Usuario detiene el paseo → el conteo acumulado se guarda en `paseos.pasos` junto con la duración.

## 6. Casos borde y reglas de negocio

- **Dispositivo sin sensor de podómetro → bloquea el inicio del paseo**, con una explicación de que el dispositivo no es compatible (decisión revisada 2026-07-26, ver §3). No hay ningún ajuste que abrir para corregirlo -- a diferencia del caso de permiso denegado, este mensaje no ofrece un botón de "Abrir ajustes".
  - Cómo se detecta: el plugin no expone un chequeo directo de disponibilidad -- se hace una suscripción de prueba al stream con timeout (~5s); un primer evento confirma que el sensor existe, un error o el timeout confirma que no (verificado leyendo el código fuente nativo del plugin, tanto Android -- `SensorStreamHandler.kt`, `SensorManager.getDefaultSensor(TYPE_STEP_COUNTER) == null` -- como iOS -- `CMPedometer.isStepCountingAvailable()`).
  - **El emulador de Android no tiene este sensor** (confirmado en la documentación oficial de Extended Controls) -- esta función nunca se puede probar ahí, solo en un dispositivo real.
- **Permiso de actividad física denegado → también bloquea el inicio del paseo**, con explicación + botón a Ajustes (a diferencia del caso anterior, este sí es corregible).
- **Caso residual, no bloqueable**: si el permiso se revoca o el sensor falla a mitad de un paseo *ya en curso* (por ejemplo, el dispositivo se reinicia mientras se camina, ver `calcularPasosCaminados`), `paseos.pasos` queda `null` para ese paseo específico -- exigirlo en ese momento significaría interrumpir un paseo que ya arrancó, un caso distinto y más invasivo que no se pidió. Esto es la única situación en la que un paseo se guarda sin pasos.
- App pasa a segundo plano durante el paseo activo — resuelto: tanto Android (`TYPE_STEP_COUNTER`) como iOS (`CMPedometer`) son acumulativos desde el último reinicio del dispositivo, no desde que se suscribe el stream -- el conteo se calcula como (lectura al detener − lectura al iniciar), así que el sensor de hardware sigue contando aunque la app pierda eventos en background.
- Paseo con más de una mascota → el conteo de pasos es del dueño/dispositivo, no del perro — mismo total se guarda para el paseo (no por mascota individual, ya que `pasos` vive en `paseos`, no en `paseos_mascotas`).

## 7. Datos involucrados

- `paseos.pasos` (integer, nullable) — ya existía, sin cambios de esquema necesarios (el `null` ahora solo ocurre en el caso residual de §6, no por dispositivos sin sensor).

## 8. Preguntas abiertas / ejemplos no definitivos

- ~~Qué paquete Flutter usar~~ **Resuelto**: `pedometer` (envuelve el sensor nativo de cada plataforma) + `permission_handler` (el permiso).
- ~~Si el permiso se pide al iniciar el primer paseo, o antes~~ **Resuelto**: de forma perezosa, al tocar "¡Vamos a pawsear!" -- mismo patrón que el permiso de ubicación.
- ~~Comportamiento en segundo plano~~ **Resuelto**, ver §6.

## 9. Criterio de éxito

Al finalizar un paseo, `paseos.pasos` queda guardado con un número coherente con la caminata real. En un dispositivo sin sensor, o con el permiso denegado, el paseo directamente no puede iniciarse -- no existe un paseo guardado sin ese dato salvo el caso residual ya documentado en §6.
