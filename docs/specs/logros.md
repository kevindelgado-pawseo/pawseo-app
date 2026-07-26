# Spec: Logros

**Estado:** Borrador
**Fecha:** 2026-07-25
**Relacionado con:** `docs/producto.md` §3, §7 (MVP). `docs/modelo_datos.md` (tablas `logros`/`mascotas_logros`, ya diseñadas, sin migrar).

---

## 1. Resumen

Catálogo de logros que una mascota puede desbloquear (ej. completar su ficha), visibles en su perfil, desbloqueados automáticamente al cumplirse la condición.

## 2. Por qué (motivación)

`producto.md` §3 menciona los logros como parte del loop central junto a la experiencia. Ya existe un ejemplo concreto acordado (completar la ficha de la mascota), pero ni el catálogo ni el mecanismo de desbloqueo están implementados.

## 3. Qué incluye este spec

- Catálogo `logros` (nombre, descripción).
- `mascotas_logros` (join: qué mascota obtuvo qué logro y cuándo).
- Desbloqueo automático: al cumplirse la condición de un logro, se marca como obtenido sin acción manual del usuario.
- Sección en Mi Mascota que muestra los logros obtenidos (y, probablemente, los pendientes como "por desbloquear").
- Al menos el logro ya acordado: completar todos los campos opcionales de la ficha (raza, nacimiento, color, sexo, peso).

## 4. Fuera de este spec

- Experiencia y niveles — spec aparte (`xp_niveles.md`), aunque un logro podría otorgar XP bonus (pregunta abierta más abajo).
- Insignias por visitar POIs — spec aparte (`checkin_pois.md`); a definir ahí si comparten sistema con logros o son conceptos separados.
- Catálogo completo de logros más allá del de la ficha — se define incrementalmente.

## 5. Flujo esperado

1. Se cumple la condición de un logro (ej. el usuario termina de llenar raza/nacimiento/color/sexo/peso en la ficha).
2. El logro se marca automáticamente como obtenido (inserta en `mascotas_logros`).
3. Aparece destacado en Mi Mascota (badge, notificación en pantalla, o similar — a definir visualmente).

## 6. Casos borde y reglas de negocio

- La condición se cumple y luego se deshace (ej. el usuario borra un campo de la ficha después de haberla completado) — ¿se pierde el logro ya obtenido, o queda permanente una vez ganado?
- La condición se cumple mientras la app está cerrada o en otro dispositivo — necesita revisarse en el próximo momento relevante (abrir la app, o vía trigger de Postgres si el criterio se puede evaluar del lado del servidor).

## 7. Datos involucrados

- `logros`: `id`, `nombre`, `descripcion`, `criterio` (estructura sin definir, ver preguntas abiertas).
- `mascotas_logros`: `mascota_id` (FK), `logro_id` (FK), `obtenido_en`, PK compuesta.

## 8. Preguntas abiertas / ejemplos no definitivos

- Estructura de `criterio`: ¿un formato genérico (tipo + valor umbral, ej. `{"tipo": "ficha_completa"}`) evaluable por una sola Edge Function, o lógica específica hardcodeada por cada logro?
- Catálogo completo de logros más allá de "completar la ficha" — ideas: primer paseo, cierta cantidad de paseos acumulados, etc. (ninguna cerrada todavía).
- Si un logro obtenido también otorga XP como bonus, o es puramente cosmético/de colección.
- Si un logro, una vez obtenido, se puede perder (ver casos borde).

## 9. Criterio de éxito

Al completar todos los campos opcionales de la ficha de una mascota, el logro correspondiente queda marcado como obtenido automáticamente y visible en Mi Mascota, sin que el usuario tenga que hacer nada explícito para "reclamarlo".
