# Spec: Resumen de paseo

**Estado:** Borrador
**Fecha:** 2026-07-26
**Relacionado con:** `docs/producto.md` §2 (el problema: "una experiencia diaria sin memoria ni progreso"), §3 (loop de gamificación), §7 (MVP). Depende de [`specs/checkin_pois.md`](checkin_pois.md) y [`specs/xp_niveles.md`](xp_niveles.md); se superpone con [`specs/tarjeta_compartible.md`](tarjeta_compartible.md) y [`specs/historial_paseos.md`](historial_paseos.md) -- ver §4 y §8.

---

## 1. Resumen

Pantalla que aparece automáticamente al terminar un Pawseo, con el resumen de esa sesión: cuánto tiempo, cuántos pasos, qué lugares visitaste, y cuánta experiencia ganó cada mascota.

## 2. Por qué (motivación)

Hoy detener un paseo no muestra nada -- se vuelve directo al mapa, sin ningún cierre. Es exactamente el problema que describe `producto.md` §2 ("sin memoria ni progreso"): el usuario acaba de generar datos reales (tiempo, pasos, visitas, XP) y no ve ninguno antes de que la app siga adelante. Es el cierre natural del loop de feedback que ya empieza con el timer y el conteo de pasos en vivo durante el paseo (`docs/specs/podometro.md`, implementado).

## 3. Qué incluye este spec

- Pantalla (o modal a pantalla completa) que aparece automáticamente al tocar "Detener paseo", reemplazando el volver directo al mapa.
- Duración del paseo.
- Pasos caminados.
- Lista de los POI visitados durante ese paseo específico, con la recompensa de XP que otorgó cada uno.
- XP ganada por cada mascota que participó, y si corresponde, el nivel resultante.
- Acción para cerrar y volver al mapa.

## 4. Fuera de este spec

- La generación de la imagen compartible en sí -- eso es `tarjeta_compartible.md`. Ver pregunta abierta en §8: no se asume todavía si esta pantalla reemplaza esa spec, o si "Compartir" es una acción que vive dentro de este resumen.
- El historial de paseos pasados (listado cronológico de sesiones anteriores) -- eso es `historial_paseos.md`, una pantalla distinta a la que se accede después, no automáticamente al terminar.
- El check-in de POIs en sí (verificación GPS, cooldown anti-farming, entrega de XP) -- spec aparte, `checkin_pois.md`. Este spec solo consume el resultado, no lo calcula.
- El cálculo de XP y niveles en sí (curva, cuánta XP otorga un paseo) -- spec aparte, `xp_niveles.md`. Este spec solo muestra el resultado.

## 5. Flujo esperado

1. Usuario toca "Detener paseo".
2. El paseo se cierra (como ya ocurre hoy) y, en vez de volver directo al mapa, aparece esta pantalla de resumen.
3. Ve duración, pasos, POI visitados con su recompensa, y XP ganada por cada mascota (con su nivel resultante si subió).
4. Cierra la pantalla (o comparte, si esa acción termina viviendo acá) y vuelve al mapa.

## 6. Casos borde y reglas de negocio

- Paseo sin ningún POI visitado -> sección vacía con un mensaje explícito (ej. "no visitaste ningún lugar esta vez"), no un espacio en blanco sin explicación.
- Paseo con más de una mascota -> la XP se muestra por separado para cada una, no como un total mezclado (ver también la pregunta abierta de reparto de XP en `xp_niveles.md`).
- Paseo sin pasos medidos (sin sensor o permiso denegado, `paseos.pasos = null`) -> esa fila no se muestra, o se muestra como "no disponible" -- mismo criterio que ya se usa en el resto de la app para este caso.
- Si `finalizarPaseo` falla (`Failure`, ver `paseos_repository.dart`), el paseo no se cierra y este resumen no debería aparecer -- ya hoy ese caso muestra un error en el mapa en vez de cerrar el paseo, este spec no cambia eso.

## 7. Datos involucrados

- Lee `paseos` (duración vía `iniciado_en`/`finalizado_en`, `pasos`) -- ya existe, sin cambios.
- Lee `paseos_pois` del paseo recién finalizado -- necesita que `checkin_pois.md` esté implementado (tabla todavía sin migrar).
- Lee el delta de XP ganado por cada mascota del paseo -- necesita que `xp_niveles.md` esté implementado (tabla `stats` todavía sin migrar). Probablemente requiere que la Edge Function de XP devuelva explícitamente cuánto se ganó en esta sesión (no solo el `experiencia_total` acumulado) para poder mostrar algo como "+150 XP" -- a resolver en la conversación técnica de esa spec, no en esta.

## 8. Preguntas abiertas / ejemplos no definitivos

- **La más importante**: ¿esta pantalla reemplaza lo que ya proponía `tarjeta_compartible.md` (que también aparece al detener el paseo, con foto + duración + nivel), o son dos pantallas distintas -- este resumen primero, y "Compartir" como una acción/botón dentro de él que lleva a la tarjeta? No se asume ninguna de las dos -- se marca acá para resolverla antes de implementar cualquiera de las dos specs.
- ¿Se construye una versión reducida de este resumen ahora mismo (solo duración + pasos, que ya existen) y se completa más adelante con POI/XP cuando esas specs avancen, o se espera a tener las tres piezas completas para construirlo de una sola vez? No definido.
- Formato exacto de "subiste de nivel" dentro de este resumen (si corresponde) -- depende de cómo termine resolviéndose `xp_niveles.md`.

## 9. Criterio de éxito

Al finalizar un paseo, aparece automáticamente una pantalla que muestra duración, pasos, los POI visitados y la XP ganada por cada mascota, antes de volver al mapa -- sin que el usuario tenga que ir a buscar esa información a otro lado.

---

*Nota: al recibir este spec se revisa contra la arquitectura existente (`CLAUDE.md`) y se marcan preguntas, casos no contemplados o alternativas técnicas antes de implementar -- no se implementa a ciegas solo porque el spec lo pide.*
