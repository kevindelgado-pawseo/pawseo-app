# Spec: Check-in de POIs verificado por GPS

**Estado:** Borrador
**Fecha:** 2026-07-25
**Relacionado con:** `docs/producto.md` §3, §7 (MVP). `docs/modelo_datos.md` (tabla `paseos_pois`, ya diseñada, sin migrar a propósito — ver Decisiones de diseño ahí). Reemplaza el estado actual de `poi_detalle_sheet.dart`, donde "última visita" siempre muestra "nunca has visitado este lugar" porque no existe ningún registro de visitas.

---

## 1. Resumen

Verifica por GPS que el usuario efectivamente llegó a un POI durante un paseo activo, entrega la recompensa de XP (`pois.recompensa_xp`) y registra la visita, con protección anti-farming.

## 2. Por qué (motivación)

Es la pieza central que falta del sistema de POIs. Hoy el mapa del tab Paseo ya muestra los lugares como pines interactivos con foto/nombre y un modal de detalle (`docs/modelo_datos.md`, `docs/progreso_mvp.md`), pero visitarlos no hace nada — es decoración, no juego.

## 3. Qué incluye este spec

- Verificación de proximidad GPS a un POI durante un paseo activo, con el radio ya decidido (fijo, 50m — constante en código, no columna, ver `modelo_datos.md`).
- Edge Function que valida la proximidad y registra el check-in — **nunca vía insert directo del cliente** (decisión ya tomada en `modelo_datos.md`: si el cliente pudiera insertar la fila directo, se salta tanto la verificación de proximidad como el cooldown anti-farming).
- Cooldown anti-farming evaluado contra (mascota, poi) — no contra (paseo, poi) — ya decidido en `modelo_datos.md`: la pregunta relevante es si esa mascota ya reclamó ese POI en las últimas X horas, en cualquier paseo.
- Entrega de `recompensa_xp` al mascota(s) del paseo cuando el check-in se confirma.
- El modal de detalle del POI (`poi_detalle_sheet.dart`) deja de mostrar siempre "nunca has visitado este lugar" y refleja la última visita real cuando exista.

## 4. Fuera de este spec

- Insignias/badges coleccionables como concepto visual — este spec deja el check-in y la entrega de XP funcionando, pero si "insignia" es un sistema separado de `logros.md` o el mismo, queda como pregunta abierta (ver más abajo). No se diseña acá.
- POIs patrocinados / recompensas canjeables en comercios — fase 3 de negocio (`producto.md` §8), no bloqueante para MVP.
- Curación completa del catálogo de POIs por comuna — segue siendo un proceso manual aparte, no técnico.

## 5. Flujo esperado

1. Usuario tiene un paseo activo (ver `paseo_screen.dart`).
2. Mientras camina, si se acerca a menos de 50m de un POI que esa mascota no visitó recientemente, se dispara el check-in.
3. La Edge Function valida proximidad real + cooldown → si pasa, inserta en `paseos_pois` y entrega `recompensa_xp` a la(s) mascota(s) del paseo.
4. El usuario ve alguna confirmación visual (a definir, ver preguntas abiertas) y, si vuelve a abrir el modal de ese POI, ve la fecha de la visita en vez de "nunca visitado".

## 6. Casos borde y reglas de negocio

- El usuario pasa cerca de un POI **sin** tener un paseo activo — no debe contar como visita.
- GPS impreciso justo en el límite de los 50m — se acepta el margen de error del sensor, sin lógica especial adicional.
- Cooldown ya activo (esa mascota ya visitó ese POI hace poco, en cualquier paseo) — no se entrega XP de nuevo, pero probablemente sí se debería poder "ver" el lugar igual (sin cobrar de nuevo).
- Dos mascotas del mismo paseo pasan por el mismo POI — ¿ambas ganan la recompensa por separado, o se reparte? (ver preguntas abiertas).
- Sin señal GPS en el momento exacto en que se pasa cerca del POI — la visita simplemente no se detecta esa vez.

## 7. Datos involucrados

- `paseos_pois`: `paseo_id` (FK), `poi_id` (FK), `visitado_en` — PK compuesta, ya diseñada en `modelo_datos.md`. Solo se inserta desde la Edge Function.
- Lee `pois.recompensa_xp` para saber cuánta XP entregar (requiere que `xp_niveles.md` esté implementado para que la entrega tenga efecto real).

## 8. Preguntas abiertas / ejemplos no definitivos

- ~~Tracking continuo de ubicación durante el paseo~~ **Parcialmente resuelto** (2026-07-26): ya existe un stream continuo de posición mientras el paseo está activo (`_iniciarSeguimientoCamara`, `paseo_screen.dart`, vía `Geolocator.getPositionStream`) — se construyó para que la cámara siga al usuario en el mapa, no para check-in, pero es la misma pieza de arquitectura que este spec necesitaba y que se marcaba como "cambio no trivial". Sigue pendiente acá: la lógica de comparar cada posición contra los POI a 50m, el llamado a la Edge Function, y el cooldown — nada de eso existe todavía. Importante: el stream de hoy es **solo foreground** (no se pidió permiso de ubicación en segundo plano ni hay foreground service) — si se decide que el check-in debe seguir funcionando con la app en background/pantalla bloqueada, eso sí sigue siendo un cambio de arquitectura no resuelto.
- Mecanismo de insignia coleccionable: ¿reutiliza el sistema de `logros`/`mascotas_logros` (`logros.md`), o es un concepto visual aparte específico de POIs?
- Cómo se reparte la recompensa cuando el paseo tiene varias mascotas: ¿todas ganan la XP completa, o se divide?
- Confirmación visual del check-in en el momento (¿notificación in-app, animación, nada hasta volver a abrir el POI?).
- Duración exacta del cooldown anti-farming (cuántas horas).

## 9. Criterio de éxito

Caminar hasta menos de 50m de un POI durante un paseo activo, sin que esa mascota lo haya visitado recientemente, entrega la XP correspondiente y queda registrado — el modal de detalle de ese POI refleja la visita real la próxima vez que se abre.
