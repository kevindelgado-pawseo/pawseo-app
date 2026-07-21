# Spec: Onboarding + login mock

**Estado:** Borrador → En implementación
**Fecha:** 2026-07-20
**Relacionado con:** `docs/producto.md` §3 (La solución), §7 (MVP)

---

## 1. Resumen

Primeras pantallas que ve un usuario al abrir la app por primera vez: un onboarding de 3 slides explicando la propuesta de Pawseo, seguido de una pantalla de login (mock, sin autenticación real).

## 2. Por qué (motivación)

Sentar los cimientos visuales y de navegación de la app. Es la primera pieza de código real del proyecto — establece patrones (theme, navegación, componentes reutilizables) que el resto de features va a seguir.

## 3. Qué incluye este spec

- 3 pantallas de onboarding (swipeable, con indicador de progreso, botón "Siguiente" y "Saltar").
- Pantalla de login mock al final del onboarding.
- Persistencia local de "ya vio el onboarding" — no se repite en aperturas futuras de la app.
- Theme base de la app (colores, tipografía) — placeholder hasta que exista identidad de marca definida.
- Componente de botón reutilizable (`core/widgets`), usado tanto en onboarding como en login.
- Pantalla stub de "Home" (placeholder) como destino después del login mock, solo para poder ver el flujo completo de principio a fin.

## 4. Fuera de este spec

- Login real (Supabase Auth, Google/Apple OAuth reales) — los botones existen visualmente pero no autentican.
- Cualquier pantalla más allá del stub de Home.
- Identidad de marca definitiva (colores/tipografía finales, ilustraciones custom) — se usan íconos y formas simples de Flutter como placeholder visual.

## 5. Flujo esperado

1. Usuario abre la app por primera vez → ve slide 1/3 del onboarding.
2. Desliza o toca "Siguiente" → slide 2/3 → slide 3/3.
3. En cualquier slide puede tocar "Saltar" → va directo a login mock.
4. En slide 3/3 el botón dice "Comenzar" en vez de "Siguiente" → toca → login mock.
5. En login mock, toca cualquier botón (Google/Apple/Email) → navega a Home (stub) — no hay autenticación real detrás.
6. Si el usuario cierra y vuelve a abrir la app habiendo ya visto el onboarding, entra directo a login mock (no repite el onboarding).

## 6. Casos borde y reglas de negocio

*Añadidos por Claude durante la revisión — no estaban en el spec original, marcados para que Kevin los confirme o ajuste:*

- Sin conexión a internet: no aplica, todo el flujo es local (sin llamadas a Supabase todavía).
- Pantallas muy chicas/grandes: el layout debe ser responsive, sin overflow de texto.
- Botón "atrás" del sistema (Android) durante el onboarding: no debería sacar al usuario de la app antes de terminar el slide 1 — se maneja dejando que retroceda entre slides pero no salga de la app hasta login.

## 7. Datos involucrados

- Un flag local `hasSeenOnboarding` (booleano), persistido en el dispositivo (no en Supabase — es puramente de UI, no de negocio).

## 8. Preguntas abiertas / ejemplos no definitivos

- El copy exacto de las 3 pantallas de onboarding es propuesto por Claude (ver implementación) — Kevin puede pedir ajustes de tono/texto libremente, no está cerrado.
- Colores/tipografía del theme son placeholder — no reflejan branding final de Pawseo.

## 9. Criterio de éxito

La app compila y corre; el usuario puede recorrer onboarding → login mock → home stub de principio a fin, y si vuelve a abrir la app tras verlo una vez, no vuelve a ver el onboarding.
