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

- Registro con email + contraseña, **con verificación de correo obligatoria** (Supabase envía un link de confirmación; sin hacer click en él no se puede iniciar sesión).
- Login con email + contraseña.
- Recuperar contraseña (correo con link de reset).
- Login con Google (Android + iOS).
- Login con Apple (solo iOS).
- Creación automática de fila en `perfiles` (trigger de Postgres) al registrarse, por cualquier método.
- **Pantalla de "¿cómo te llamamos?"** obligatoria justo después del primer login, solo si `perfiles.nombre` llegó vacío (email) — Google la salta porque ya entrega el nombre.
- Persistencia de sesión — no pedir login de nuevo si ya inició sesión antes.
- Entradas "Cerrar sesión" y "Borrar nombre de perfil" en Debug Settings, para poder re-probar los flujos repetidamente.

## 4. Fuera de este spec

- Resto de la ficha de perfil (foto, editar nombre después de creado) — spec aparte. Esta iteración solo cubre el nombre, como paso obligatorio único post-registro.
- Cualquier pantalla más allá del stub de Home como destino final.
- Modelo de datos de perros/paseos/XP — esta migración solo crea `perfiles`, nada más.

## 5. Flujo esperado

**Registro con email:**
1. Usuario toca "Crear cuenta" (tab del mismo formulario que login — mismos campos: correo + contraseña) → envía.
2. Supabase crea la cuenta (sin sesión todavía) y manda un correo de confirmación → pantalla "Revisa tu correo".
3. Usuario abre el link desde su correo, en el mismo dispositivo → se crea la sesión → como `perfiles.nombre` está vacío, va a "¿Cómo te llamamos?" → completa → Home.

**Login con email:**
1. Mismo formulario, tab "Iniciar sesión" (mismos campos que registro: correo + contraseña) → Home directo (perfil ya completo de una sesión anterior).

**Recuperar contraseña:**
1. Link "¿Olvidaste tu contraseña?" (solo visible en modo login) → pide email → Supabase envía correo con link de reset.
2. Usuario abre el link desde su correo (en el dispositivo con la app instalada) → pantalla para ingresar nueva contraseña → Home.

**Google / Apple:**
1. Usuario toca el botón del proveedor → flujo OAuth nativo → si es la primera vez, se crea cuenta + `perfiles` automáticamente (con nombre ya incluido, vía metadata del proveedor) → Home directo, sin pasar por "¿Cómo te llamamos?". Si ya existía, también Home directo.

## 6. Casos borde y reglas de negocio

- Contraseña incorrecta → mensaje de error genérico ("Email o contraseña incorrectos"), sin revelar si el email existe (seguridad).
- Email ya registrado al crear cuenta → mensaje claro, sugiere iniciar sesión.
- Usuario cancela el selector de cuenta de Google/Apple → vuelve al login sin mostrar error.
- Sin conexión a internet → mensaje de error, reintento manual (sin retry automático).
- El link de recuperación de contraseña expira según la config default de Supabase.

## 7. Datos involucrados

- Tabla `perfiles`: `id` (= `auth.users.id`), `email`, `nombre` (**nullable** — vacío hasta completar perfil en signups por email), `avatar_url` (nullable), `created_at`.
- Trigger en Postgres que crea la fila en `perfiles` automáticamente tras cada signup (cualquier proveedor); toma `nombre` de la metadata del proveedor si existe (Google), o lo deja vacío (email).
- RLS: cada usuario solo puede leer/editar su propia fila de `perfiles`.

## 8. Preguntas abiertas / decisiones ya tomadas por Claude

- Nombre en signup por email: **ya no se pide en el formulario** (decisión de Kevin, corrige el spec original) — se pide después en una pantalla dedicada, porque así login y registro comparten exactamente los mismos campos y el formulario no cambia de forma al alternar entre modos.
- El switch entre "Iniciar sesión"/"Crear cuenta" es un `SegmentedButton` (tabs) en una sola pantalla/ruta, no pantallas separadas ni un link de texto.
- Redirect del link de recuperar contraseña y de confirmación de email: uso un **custom URL scheme** (`pawseo://...`) en vez de Universal/App Links — más simple para MVP, no depende de tener una landing en `pawseo.cl` sirviendo el archivo de verificación de dominio todavía.

## 9. Criterio de éxito

Un usuario puede crear cuenta con email, confirmar su correo, completar su nombre, cerrar y reabrir la app sin perder sesión, cerrar sesión, volver a entrar (directo a Home, sin repetir el nombre), y recuperar su contraseña si la olvida. Login con Google/Apple funciona en un dispositivo de prueba una vez configuradas las credenciales OAuth correspondientes.
