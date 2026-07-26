# Spec: Tarjeta compartible

**Estado:** Borrador
**Fecha:** 2026-07-25
**Relacionado con:** `docs/producto.md` §3, §6 (propuesta de valor), §8 (Fase 1: crecimiento orgánico vía tarjetas compartidas, único canal de crecimiento antes de la capa social). `docs/producto.md` §7 (MVP).

---

## 1. Resumen

Imagen generada al terminar un paseo, con foto de la mascota, estadísticas del paseo y su nivel actual, lista para compartir por el share sheet nativo del teléfono.

## 2. Por qué (motivación)

En `producto.md` §8, Fase 1 depende explícitamente de "crecimiento orgánico (tarjetas compartibles)" — es el único canal de adquisición contemplado antes de que exista capa social o comercial. No es un nice-to-have visual, es la estrategia de crecimiento del lanzamiento.

## 3. Qué incluye este spec

- Generación de una imagen al finalizar un paseo: foto de la mascota (o su placeholder si no tiene), duración del paseo, nivel/XP actual.
- Botón "Compartir" que abre el share sheet nativo del sistema operativo con esa imagen.

## 4. Fuera de este spec

- Compartir directo a una red social específica (Instagram, etc.) — solo el share sheet genérico del OS.
- Múltiples plantillas o personalización visual de la tarjeta — un solo diseño por ahora.
- Generar/compartir la tarjeta de un paseo pasado desde el historial — solo inmediatamente al terminar un paseo nuevo (ver `historial_paseos.md` si se quiere extender más adelante).

## 5. Flujo esperado

1. Usuario toca "Detener paseo".
2. Se muestra la tarjeta generada (foto + duración + nivel/XP).
3. Botón "Compartir" → share sheet nativo del sistema.

## 6. Casos borde y reglas de negocio

- Mascota sin foto (`foto_url` nulo) — mismo patrón de fallback ya usado en otros lados de la app (inicial del nombre sobre un color).
- Paseo con más de una mascota — ¿una tarjeta por mascota, o una combinada con todas? (ver preguntas abiertas).
- Falla la generación de la imagen — el usuario igual debe poder cerrar el flujo sin quedar trabado.

## 7. Datos involucrados

Ninguno nuevo — se arma en el momento a partir del paseo recién finalizado, la mascota (nombre, foto) y sus stats (nivel/XP, si `xp_niveles.md` ya está implementado).

## 8. Preguntas abiertas / ejemplos no definitivos

- Diseño visual exacto de la tarjeta — mejor definirlo mirando mockups en vivo que describirlo a ciegas acá.
- Paseo con varias mascotas: ¿una tarjeta por perro, o una sola combinada mostrando a todas?
- Formato de salida (imagen estática vs. algo más elaborado tipo "story" con capas) — se asume imagen estática simple para el MVP.

## 9. Criterio de éxito

Al terminar un paseo, el usuario puede compartir una imagen generada con la información básica del paseo a través del share sheet del sistema, sin salir de la app para prepararla a mano.
