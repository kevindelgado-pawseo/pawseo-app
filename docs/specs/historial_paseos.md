# Spec: Historial de paseos

**Estado:** Borrador
**Fecha:** 2026-07-25
**Relacionado con:** `docs/producto.md` §2 (el problema: "una experiencia diaria sin memoria ni progreso"), §7 (MVP).

---

## 1. Resumen

Pantalla que lista los paseos pasados de una mascota: fecha, duración y (si existen) pasos.

## 2. Por qué (motivación)

Los paseos ya se guardan en `paseos`/`paseos_mascotas` desde que existe el tab Paseo, pero hoy esa información no se ve en ningún lado más allá del paseo activo del momento — no hay memoria ni sensación de progreso, justo el problema que `producto.md` §2 describe.

## 3. Qué incluye este spec

- Pantalla de listado cronológico de paseos pasados de una mascota (fecha, duración, pasos si existen).
- Punto de entrada desde algún lugar de la app (a definir, ver preguntas abiertas — probablemente Mi Mascota).

## 4. Fuera de este spec

- Tarjeta compartible — spec aparte (`tarjeta_compartible.md`).
- Tracking de la ruta caminada (mapa del recorrido) — explícitamente fuera del MVP (`producto.md` §7).
- Filtros, búsqueda o estadísticas agregadas (total de km del mes, etc.) — solo el listado simple por ahora.

## 5. Flujo esperado

1. Desde Mi Mascota (o el punto de entrada que se defina), el usuario toca "Historial" de una mascota.
2. Ve una lista ordenada del más reciente al más antiguo, con fecha y duración de cada paseo.

## 6. Casos borde y reglas de negocio

- Mascota sin ningún paseo todavía → empty state (mismo espíritu que `MascotasEmptyState`, pero para el historial vacío de una mascota puntual).
- Un paseo que quedó "colgado" (se cerró la app a mitad de un paseo, sin `finalizado_en`) — ¿se muestra igual, se filtra, o se marca de forma distinta?

## 7. Datos involucrados

Ninguno nuevo — se lee de `paseos`/`paseos_mascotas`, ya migradas. Esto es una pantalla de solo lectura.

## 8. Preguntas abiertas / ejemplos no definitivos

- ¿Dónde vive el punto de entrada — dentro de Mi Mascota, o en Perfil?
- ¿Se pagina la lista o se carga completa? (relevante recién cuando haya muchos paseos acumulados).
- ¿El paseo actualmente en curso se muestra también acá (como "en curso" arriba de la lista), o el historial es solo de paseos ya finalizados y el activo se ve únicamente en el tab Paseo?

## 9. Criterio de éxito

El usuario puede ver, para una mascota puntual, la lista completa de sus paseos pasados con fecha y duración, sin tener que recordar cuándo salió a caminar.
