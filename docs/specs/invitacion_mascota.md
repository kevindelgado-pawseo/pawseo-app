# Spec: Invitación de mascota compartida

**Estado:** Borrador
**Fecha:** 2026-07-25
**Relacionado con:** `docs/producto.md` §4 (subsegmento clave: hogares multi-dueño), §7 (MVP). `docs/modelo_datos.md` (tabla `mascotas_perfiles`, ya migrada).

---

## 1. Resumen

Un código o enlace que le permite a un segundo dueño (pareja, familiar) sumarse al perfil de una mascota que ya existe, compartiendo el mismo progreso.

## 2. Por qué (motivación)

`mascotas_perfiles` ya es una tabla muchos-a-muchos y hoy se puebla automáticamente vía trigger para quien crea la mascota — pero no existe ningún mecanismo para que **otra** cuenta se sume. Sin esto, "perfil de perro compartible" es una promesa de `producto.md` que la base de datos soporta pero que nadie puede usar todavía.

## 3. Qué incluye este spec

- Generar un código de invitación desde la ficha de una mascota (cualquier dueño actual puede generarlo, no solo quien la creó).
- Pantalla para "unirme a una mascota" donde otra cuenta ingresa el código.
- Al validarse, se inserta una fila nueva en `mascotas_perfiles` vinculando la mascota a la cuenta que se unió.
- La mascota aparece de inmediato en la lista de mascotas (`misMascotasProvider`) de la cuenta recién vinculada, con el mismo progreso/historial que ya tenía.

## 4. Fuera de este spec

- Roles o permisos diferenciados entre dueños — todos quedan con los mismos permisos, tal como ya lo dice `producto.md` §3.
- Quitar/desvincular a un dueño de una mascota (unlink).
- Límite máximo de dueños por mascota (queda como pregunta abierta más abajo, no resuelto acá).

## 5. Flujo esperado

1. Dueño existente entra a la ficha de su mascota → botón "Invitar a otro dueño" → se genera un código.
2. Lo comparte por el medio que quiera (WhatsApp, de palabra, etc. — no hay integración especial de envío).
3. La otra persona, con su propia cuenta ya creada en la app, va a una pantalla "Unirme con código" → ingresa el código → la mascota aparece en su lista, con el mismo nivel/XP/historial que ya tenía con el otro dueño.

## 6. Casos borde y reglas de negocio

- Código inválido o expirado → mensaje de error claro.
- Usuario intenta unirse a una mascota a la que ya está vinculado → mensaje ("ya eres dueño de esta mascota"), sin duplicar la fila.
- Código de un solo uso vs. reutilizable — ver preguntas abiertas.

## 7. Datos involucrados

- Tabla nueva para los códigos de invitación (nombre y columnas exactas a definir en la conversación técnica) — como mínimo necesita: a qué mascota pertenece, el código en sí, y si ya fue usado o cuándo expira.
- Al canjearse un código válido: insert en `mascotas_perfiles` (`mascota_id`, `perfil_id` de quien se une).

## 8. Preguntas abiertas / ejemplos no definitivos

- ¿El código expira (ej. 24-48h) o queda vigente indefinidamente hasta usarse?
- ¿Es de un solo uso, o el mismo código puede sumar a varias personas (útil para familias numerosas)?
- ¿Además del código alfanumérico (para dictar/tipear) conviene un enlace tipo deep link que abra la app directo en la pantalla de "unirme"?
- ¿Hay un límite de cuántos dueños puede tener una mascota, o es abierto?
- ¿Se puede revocar un código generado antes de que alguien lo use?

## 9. Criterio de éxito

Dos cuentas distintas pueden ver, editar y pasear a la misma mascota, viendo ambas el mismo nivel/XP/historial — sin que ninguna haya tenido que crear la mascota de nuevo.
