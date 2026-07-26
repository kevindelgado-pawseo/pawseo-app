# Spec: Recordatorio de paseo configurable

**Estado:** Borrador
**Fecha:** 2026-07-25
**Relacionado con:** `docs/producto.md` §2 (el problema: paseos más cortos/menos frecuentes de lo que el perro necesita), §7 (MVP).

---

## 1. Resumen

Notificación configurable que le recuerda al usuario salir a pasear si todavía no ha registrado un paseo en el día.

## 2. Por qué (motivación)

Ataca directamente el problema descrito en `producto.md` §2: la motivación decae con el tiempo y el bienestar del perro depende de ella. Un recordatorio simple sostiene el hábito sin depender de que el usuario se acuerde solo.

## 3. Qué incluye este spec

- Configuración de una hora de recordatorio (activar/desactivar, elegir hora).
- Notificación local que se dispara a esa hora **solo si** no se registró ningún paseo ese día.
- Pantalla de configuración (probablemente dentro de Perfil, a confirmar).

## 4. Fuera de este spec

- Rachas — explícitamente diferidas (`producto.md` §7).
- Recordatorios "inteligentes" basados en patrón de uso — solo horario fijo configurable por ahora.
- Notificaciones push remotas (FCM) — a definir si este spec usa notificaciones locales del dispositivo o el canal de FCM ya listado en `tecnico.md` §5 (ver preguntas abiertas).

## 5. Flujo esperado

1. Usuario entra a la configuración de recordatorio → activa, elige una hora.
2. Si llega esa hora y no se ha registrado ningún paseo ese día (para ninguna de sus mascotas, o por mascota — ver preguntas abiertas) → llega una notificación.
3. Si el usuario ya paseó antes de esa hora, no se dispara nada.

## 6. Casos borde y reglas de negocio

- Usuario con más de una mascota: ¿un recordatorio general, o uno por mascota?
- Permiso de notificaciones denegado por el usuario — la app debe seguir funcionando igual, sin el recordatorio.
- Cambio de zona horaria / horario de verano.
- Usuario pasea justo antes de la hora configurada — no debería notificar de todas formas.

## 7. Datos involucrados

- Configuración del recordatorio: hora, activo/inactivo, y posiblemente días de la semana. Falta decidir si vive en `perfiles` o en `mascotas` (ver preguntas abiertas, ya marcado como pendiente en `modelo_datos.md`).

## 8. Preguntas abiertas / ejemplos no definitivos

- ¿La configuración es por `perfil` (una hora para todas sus mascotas) o por `mascota`?
- ¿Notificación local (simple, sin infraestructura extra) o vía FCM (ya está en el radar de infraestructura, `tecnico.md` §5, pero agrega complejidad)?
- ¿Se puede configurar solo una hora fija diaria, o distintos días de la semana con distinta hora?
- ¿Qué pasa si el usuario tiene varias mascotas y pasea a una pero no a otra ese día?

## 9. Criterio de éxito

Activar el recordatorio a una hora determinada dispara una notificación ese día si no se registró ningún paseo antes de esa hora, y no dispara nada si ya se paseó.
