# Spec: Registro e inicio de sesión (auth real)

**Estado:** Borrador → En implementación
**Fecha:** 2026-07-20
**Relacionado con:** `docs/producto.md` §7 (MVP), `docs/tecnico.md` §1-§3. Reemplaza el login mock de `docs/specs/onboarding.md`.

---

## 1. Resumen

Reemplaza el login mock por autenticación real vía Supabase Auth: email/contraseña (registro, login, recuperar contraseña) y OAuth (Google en ambas plataformas, Apple solo iOS).

## 2. Por qué

El mock cumplió su propósito (sentir el flujo de la app). Ahora se necesitan cuentas reales — el progreso del perro (XP, perfil compartido entre dueños) necesita a quién pertenecer.

## 3. Qué incluye este spec

- Registro con email + contraseña, sin verificación de correo.
- Login con email + contraseña.
- Recuperar contraseña (correo con link de reset).
- Login con Google (Android + iOS).
- Login con Apple (solo iOS).
- Creación automática de fila en `perfiles` (trigger de Postgres) al registrarse, por cualquier método.
- Persistencia de sesión — no pedir login de nuevo si ya inició sesión antes.
- Entrada "Cerrar sesión" en Debug Settings, para poder re-probar el flujo repetidamente.

## 4. Fuera de este spec

- Pantalla de "completar perfil" (foto, editar nombre después de creado) — spec aparte.
- Cualquier pantalla más allá del stub de Home como destino post-login (mismo destino que el mock).
- Modelo de datos de perros/paseos/XP — esta migración solo crea `perfiles`, nada más.

## 5. Flujo esperado

**Registro con email:**
1. Usuario toca "Continuar con email" → pantalla con email, contraseña, nombre + link "¿Ya tienes cuenta? Inicia sesión".
2. Envía → cuenta creada, fila en `perfiles` creada automáticamente, sesión iniciada → Home.

**Login con email:**
1. Mismo formulario, con el toggle en modo "Iniciar sesión" (sin campo nombre) → Home.

**Recuperar contraseña:**
1. Link "¿Olvidaste tu contraseña?" en el formulario de login → pide email → Supabase envía correo con link de reset.
2. Usuario abre el link desde su correo (en el dispositivo con la app instalada) → pantalla para ingresar nueva contraseña → Home.

**Google / Apple:**
1. Usuario toca el botón del proveedor → flujo OAuth nativo → si es la primera vez, se crea cuenta + `perfiles` automáticamente → Home. Si ya existía, va directo a Home.

## 6. Casos borde y reglas de negocio

- Contraseña incorrecta → mensaje de error genérico ("Email o contraseña incorrectos"), sin revelar si el email existe (seguridad).
- Email ya registrado al crear cuenta → mensaje claro, sugiere iniciar sesión.
- Usuario cancela el selector de cuenta de Google/Apple → vuelve al login sin mostrar error.
- Sin conexión a internet → mensaje de error, reintento manual (sin retry automático).
- El link de recuperación de contraseña expira según la config default de Supabase.

## 7. Datos involucrados

- Tabla `perfiles`: `id` (= `auth.users.id`), `email`, `nombre`, `avatar_url` (nullable, se completa después), `created_at`.
- Trigger en Postgres que crea la fila en `perfiles` automáticamente tras cada signup (cualquier proveedor).
- RLS: cada usuario solo puede leer/editar su propia fila de `perfiles`.

## 8. Preguntas abiertas / decisiones ya tomadas por Claude

- Nombre en signup por email: se pide en el mismo formulario — no hay otra fuente para obtenerlo (a diferencia de Google, que sí entrega nombre).
- Redirect del link de recuperar contraseña: uso un **custom URL scheme** (`pawseo://reset-password`) en vez de Universal/App Links — más simple para MVP, no depende de tener una landing en `pawseo.cl` sirviendo el archivo de verificación de dominio todavía.

## 9. Criterio de éxito

Un usuario puede crear cuenta con email, cerrar y reabrir la app sin perder sesión, cerrar sesión, volver a entrar, y recuperar su contraseña si la olvida. Login con Google/Apple funciona en un dispositivo de prueba una vez configuradas las credenciales OAuth correspondientes.
