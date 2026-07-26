# Spec: Podómetro durante el paseo

**Estado:** Borrador
**Fecha:** 2026-07-25
**Relacionado con:** `docs/producto.md` §7 (MVP: "sesión de paseo por tiempo y pasos"), §9 (riesgo ya identificado: dispositivos gama baja sin sensor, degradación planeada).

---

## 1. Resumen

Cuenta los pasos caminados durante un paseo activo usando el sensor de actividad física del dispositivo, y guarda el total en `paseos.pasos`.

## 2. Por qué (motivación)

`producto.md` §7 pide explícitamente sesión "por tiempo **y pasos**" — hoy el tab Paseo solo mide tiempo; `paseos.pasos` existe como columna desde la migración original pero queda siempre `null`.

## 3. Qué incluye este spec

- Lectura del sensor de pasos del dispositivo mientras un paseo está activo.
- Guardar el conteo final en `paseos.pasos` al finalizar el paseo.
- Degradación explícita ya contemplada en `producto.md` §9: si el dispositivo no tiene sensor, el paseo sigue funcionando solo con tiempo, sin bloquear nada.

## 4. Fuera de este spec

- Tracking de la ruta GPS caminada — explícitamente fuera del MVP.
- Gráficos históricos de pasos o metas configurables.
- Cualquier verificación de que los pasos correspondan a un paseo real (anti-fraude) — se confía en el sensor del sistema tal cual.

## 5. Flujo esperado

1. Usuario inicia un paseo ("¡Vamos a pawsear!").
2. La app empieza a leer el sensor de pasos del dispositivo.
3. Usuario detiene el paseo → el conteo acumulado se guarda en `paseos.pasos` junto con la duración.

## 6. Casos borde y reglas de negocio

- Dispositivo sin sensor de podómetro → `pasos` queda `null`, el paseo se guarda igual solo con duración (ya es el comportamiento actual, este spec no lo cambia para ese caso).
- Permiso de "Actividad física" (Android 10+) denegado → mismo comportamiento que sin sensor, no debe bloquear el paseo.
- App pasa a segundo plano durante el paseo activo — el conteo debería seguir acumulando (a confirmar según el paquete elegido, ver preguntas abiertas).
- Paseo con más de una mascota → el conteo de pasos es del dueño/dispositivo, no del perro — mismo total se guarda para el paseo (no por mascota individual, ya que `pasos` vive en `paseos`, no en `paseos_mascotas`).

## 7. Datos involucrados

- `paseos.pasos` (integer, nullable) — ya existe, sin cambios de esquema necesarios.

## 8. Preguntas abiertas / ejemplos no definitivos

- Qué paquete Flutter usar para leer el sensor (ej. `pedometer` u otro) — a evaluar.
- Si el permiso de "Actividad física" se pide al iniciar el primer paseo, o antes (ej. en el onboarding).
- Comportamiento exacto con la app en segundo plano/pantalla bloqueada durante un paseo largo.

## 9. Criterio de éxito

Al finalizar un paseo en un dispositivo con sensor de pasos disponible, `paseos.pasos` queda guardado con un número coherente con la caminata real; en un dispositivo sin sensor, el paseo se completa igual sin ese dato.
