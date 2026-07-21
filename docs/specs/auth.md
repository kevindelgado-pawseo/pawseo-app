# Spec: Registro e inicio de sesión (auth real)

**Estado:** Implementado (email/contraseña) — Google pausado
**Fecha:** 2026-07-20 (última revisión 2026-07-21)
**Relacionado con:** `docs/producto.md` §7 (MVP), `docs/tecnico.md` §1-§3. Reemplaza el login mock de `docs/specs/onboarding.md`.

> **Nota de estado (2026-07-21):**
> - **Google**: pausado — se decidió avanzar solo con email/contraseña por ahora. Runbook completo para retomarlo en `docs/tecnico.md` ("Runbook: retomar Google Sign-In"), no hay que repetir la investigación.
> - **Verificación de email**: el código está completo (OTP de 6 dígitos: `AuthRepository.verifySignUpOtp`/`resendSignUpOtp`, pantalla de código en `RegisterScreen`), pero Kevin desactivó "Confirm email" en Supabase hasta una etapa más avanzada — no vale la pena resolver SMTP propio solo para probar el MVP. No requiere cambios de código cuando se reactive; `signUpWithEmail` ya maneja ambos casos (`SignUpOutcome.signedIn` / `.confirmationEmailSent`).

---

## 1. Resumen

Reemplaza el login mock por autenticación real vía Supabase Auth: pantallas separadas de login y registro con email/contraseña, más recuperar contraseña. Google queda listo en el backlog (ver nota de estado).

## 2. Por qué

El mock cumplió su propósito (sentir el flujo de la app). Ahora se necesitan cuentas reales — el progreso del perro (XP, perfil compartido entre dueños) necesita a quién pertenecer.

## 3. Qué incluye este spec

- **Pantallas separadas** para login y registro (no una sola con toggle) — cada una con sus propios campos fijos, sin lógica condicional de mostrar/ocultar.
- Registro: nombre, correo, contraseña, repetir contraseña.
- Login: correo, contraseña.
- Recuperar contraseña (correo con link de reset).
- Creación automática de fila en `perfiles` (trigger de Postgres) al registrarse, con el nombre ya incluido desde el formulario.
- Persistencia de sesión — no pedir login de nuevo si ya inició sesión antes.
- Entradas "Cerrar sesión" y "Reiniciar onboarding" en Debug Settings, para poder re-probar los flujos repetidamente.

## 4. Fuera de este spec

- Google/Apple — ver nota de estado.
- Ficha de perfil editable (foto, editar nombre después de creado) — spec aparte.
- Cualquier pantalla más allá del stub de Home como destino final.
- Modelo de datos de perros/paseos/XP — esta migración solo crea `perfiles`, nada más.

## 5. Flujo esperado

**Registro:**
1. Desde `LoginScreen`, usuario toca "Registrarse" → `RegisterScreen` (ruta separada, `context.push`).
2. Completa nombre, correo, contraseña, repetir contraseña → envía.
3. Con verificación de correo desactivada (estado actual): sesión se crea de inmediato → Home directo.
4. Con verificación activada (estado futuro, código ya listo): pantalla "Revisa tu correo" → usuario ingresa el código de 6 dígitos → Home.

**Login:**
1. `LoginScreen`: correo + contraseña → Home directo.

**Recuperar contraseña:**
1. Link "¿Olvidaste tu contraseña?" (en `LoginScreen`) → pide email → Supabase envía correo con link de reset.
2. Usuario abre el link desde su correo (en el dispositivo con la app instalada) → pantalla para ingresar nueva contraseña → Home.

## 6. Casos borde y reglas de negocio

- Contraseña incorrecta → mensaje de error genérico ("Email o contraseña incorrectos"), sin revelar si el email existe (seguridad).
- Email ya registrado al crear cuenta → mensaje claro, sugiere iniciar sesión.
- Contraseña y repetir contraseña no coinciden → error de validación local, no llega a pegarle a Supabase.
- Sin conexión a internet → mensaje de error, reintento manual (sin retry automático).
- El link de recuperación de contraseña expira según la config default de Supabase.

## 7. Datos involucrados

- Tabla `perfiles`: `id` (= `auth.users.id`), `email`, `nombre` (nullable a nivel de columna, pero siempre poblado en la práctica — el formulario de registro lo exige), `avatar_url` (nullable), `created_at`.
- Trigger en Postgres que crea la fila en `perfiles` automáticamente tras cada signup; toma `nombre` de `raw_user_meta_data`, poblado por el `data: {'nombre': ...}` que manda `signUp()`.
- RLS: cada usuario solo puede leer/editar su propia fila de `perfiles`.

## 8. Decisiones tomadas en el camino

- **Pantallas separadas, no un formulario con toggle**: la primera versión compartía una sola pantalla con `SegmentedButton` para no repetir campos — se descartó porque Kevin prefirió separar los flujos del todo. Como consecuencia, el nombre volvió a pedirse directo en el registro (ya no hace falta que login/registro tengan los mismos campos), y se eliminó la pantalla de "completar perfil" que existía solo para rellenarlo después.
- Redirect del link de recuperar contraseña y de confirmación de email: **custom URL scheme** (`pawseo://...`), no Universal/App Links — más simple para MVP, no depende de tener landing en `pawseo.cl` sirviendo el archivo de verificación de dominio.
- `FormSubmissionMixin` (`core/utils/`) extrae el ceremonial de loading/error/manejo de `Result` compartido entre pantallas de auth — evita repetir el patrón por quinta vez.

## 9. Criterio de éxito

Un usuario puede crear cuenta con nombre/correo/contraseña, cerrar y reabrir la app sin perder sesión, cerrar sesión, volver a entrar, y recuperar su contraseña si la olvida.
