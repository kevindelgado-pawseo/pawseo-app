# Spec: Experiencia y niveles

**Estado:** Borrador
**Fecha:** 2026-07-25
**Relacionado con:** `docs/producto.md` §3, §5 (métrica norte), §7 (MVP). `docs/modelo_datos.md` (tabla `stats`, ya diseñada, sin migrar).

---

## 1. Resumen

Reemplaza el placeholder visual de nivel/XP del tab Mi Mascota por datos reales: cada paseo completado suma experiencia, y la mascota sube de nivel según una curva definida.

## 2. Por qué (motivación)

Es el corazón del loop de gamificación (`producto.md` §3: "cada paseo suma experiencia"). Hoy `mi_mascota_screen.dart` muestra "Nivel 1" y "120/500 XP" fijos, con un comentario explícito de que es placeholder — nada de eso viene de datos reales todavía.

## 3. Qué incluye este spec

- Tabla `stats` (1:1 con `mascotas`): `nivel`, `experiencia_total`, `updated_at`.
- Cálculo de XP ganada al finalizar un paseo, vía Edge Function (patrón ya establecido en `tecnico.md` §2 para lógica de negocio con contrato estable).
- Curva de niveles (fórmula de "cuánta XP se necesita para el siguiente nivel"), calculada en `domain/` y testeada — **no persistida**, se deriva de `experiencia_total` (decisión ya tomada, ver `modelo_datos.md` "Decisiones de diseño").
- Reemplazo del placeholder en Mi Mascota por los valores reales.
- Iconos con el nivel de cada mascota que participa, en el lado derecho de la pantalla del tab Paseo, al iniciar el paseo (pedido explícito de Kevin, 2026-07-26) -- **depende de que este spec exista primero**: hoy no hay ningún nivel real que mostrar, y se decidió explícitamente no construir esos iconos con el placeholder de Mi Mascota mientras tanto, esperar a tener XP real.

## 4. Fuera de este spec

- Logros — spec aparte (`logros.md`), aunque puedan otorgar XP bonus (queda como pregunta abierta ahí).
- Insignias por visitar POIs — spec aparte (`checkin_pois.md`).
- Rachas — explícitamente diferidas (`producto.md` §7).

## 5. Flujo esperado

1. Usuario finaliza un paseo (`PaseosRepository.finalizarPaseo`).
2. La Edge Function calcula la XP ganada según la duración (y/o pasos, si `podometro.md` ya está implementado) del paseo.
3. Actualiza `stats.experiencia_total` de cada mascota que participó en el paseo, y recalcula `nivel` si corresponde.
4. La próxima vez que el usuario entra al tab Mi Mascota, ve el nivel/XP actualizado.

## 6. Casos borde y reglas de negocio

- Paseo muy corto (unos segundos, por error del usuario) — ¿hay un piso mínimo de duración para que otorgue XP?
- Paseo con varias mascotas a la vez — ¿cada una gana la XP completa del paseo, o se reparte entre todas?
- Un cambio futuro en la curva de niveles no debe subir de nivel retroactivamente a mascotas existentes que no ganaron XP nueva (ya decidido en `modelo_datos.md`).

## 7. Datos involucrados

- `stats`: `mascota_id` (PK, FK → `mascotas`), `nivel` (default 1), `experiencia_total` (default 0), `updated_at`.
- RLS: mismo criterio de ownership que `mascotas` (vía `mascotas_perfiles`).

## 8. Preguntas abiertas / ejemplos no definitivos

- Fórmula exacta de la curva de niveles (¿lineal, exponencial, tabla fija por nivel?) — no definida todavía.
- Cuánta XP otorga un paseo: ¿fija por completarlo, proporcional a la duración, proporcional a los pasos (si existen), o una combinación?
- Cómo se reparte (o no) la XP cuando el paseo incluye varias mascotas.
- Si existe algún tope de XP diario/por paseo para evitar que paseos artificialmente largos rompan el balance del juego.

## 9. Criterio de éxito

Completar un paseo cambia visiblemente el nivel/XP mostrado en Mi Mascota, con un cálculo consistente, testeado en `domain/`, y sin depender de un valor hardcodeado en la UI.
