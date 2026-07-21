# Pawseo — Documento Técnico

**Versión:** 0.1 · Julio 2026
**Complementa a:** `producto.md` (visión, MVP y modelo de negocio)

---

## 1. Frontend

- **Flutter**, desarrollo en Windows, apuntando a iOS + Android nativos. **Sin soporte web** — se descartó explícitamente (era solo scaffold por defecto de `flutter create`, nunca un target real); las pruebas se hacen en emuladores Android / dispositivos reales.
- SDK `supabase_flutter` como puente al backend.
- Login social:
  - Google en ambas plataformas (`google_sign_in`) — en progreso, pendiente de credenciales OAuth (ver `docs/specs/auth.md`).
  - Sign in with Apple en iOS (`sign_in_with_apple`): **diferido**, no por decisión técnica sino porque requiere Apple Developer Program pagado (~USD 99/año) que aún no se justifica en esta etapa. Recordar que sigue siendo obligatorio por política de Apple el día que se ofrezca login social de terceros en iOS.
  - Botones de login: usar componentes/branding oficiales de cada proveedor cuando se implemente (Apple exige su componente nativo con estilos cerrados; Google tiene guías de marca propias). El resto de la pantalla de login es diseño custom.
- Detección de plataforma con `defaultTargetPlatform` (`flutter/foundation.dart`), no `dart:io Platform` — es testeable (override en tests) y no rompe compilación web si alguna vez se reconsidera ese target.

### 1.1 Ambientes (dev / prod)

- **Bundle ID real:** `cl.pawseo.app` (prod), `cl.pawseo.app.dev` (dev, vía `applicationIdSuffix`) — reemplaza el placeholder `com.example.pawseo` del scaffold.
- **Android**: flavors nativos (`productFlavors` en `android/app/build.gradle.kts`). Dev y prod quedan instalables simultáneamente en el mismo dispositivo con `applicationId` distinto — evita que compartan `SharedPreferences`/sesión de Supabase persistida (Android namespacea el storage por `applicationId`, no por ambiente lógico).
- **iOS**: diferido. Separar por Scheme/Build Configuration se hace bien solo con Xcode, y no hay Mac en el entorno de desarrollo actual — por ahora un solo target, ambiente seleccionado únicamente vía `--dart-define-from-file`.
- **Config por ambiente**: `dev.json` / `prod.json` (gitignored) vía `--dart-define-from-file`, mismo mecanismo ya usado para URL/key de Supabase.
- **Comando de desarrollo:** `flutter run --flavor dev -d <device> --dart-define-from-file=dev.json`.
- **`prod.json` todavía no existe** — el proyecto Supabase de producción se crea más adelante, cuando el MVP esté listo. `pawseo-dev` es, por ahora, el único ambiente real.
- El bundle `.dev` no necesita registrarse en App Store Connect/Play Console — mientras solo se instale vía `flutter run`/sideload directo a un dispositivo, nunca toca ninguna consola de tienda. Un tercer ambiente (staging/beta) se evalúa recién en la fase de beta cerrada (`producto.md` §5).

## 2. Backend — Supabase (BaaS sobre Postgres)

- Proyecto `pawseo-dev`, organización **Pawseo**, región **São Paulo**.
- Configuración de seguridad del proyecto:
  - "Automatically expose new tables" → **desactivado**.
  - "Enable automatic RLS" → **activado**.
  - Regla de fondo: nada se expone por defecto; cada tabla requiere política RLS explícita.

### Componentes

| Componente | Uso |
|---|---|
| **Postgres** | Base de datos real. PostGIS en el radar para features geo futuras (perros perdidos por zona, rutas GPS v1.1). |
| **Auth (GoTrue)** | Email/password + Google OAuth. `auth.users` solo guarda credenciales; los datos de negocio (nombre, foto, etc.) viven en una tabla propia `perfiles`, enlazada 1 a 1 por `id`, creada vía trigger automático tras el signup. |
| **API REST (PostgREST)** | Autogenerada sobre las tablas del schema `public`. Se usa para CRUD simple sin lógica de negocio (ej. registrar una mascota). Protegida con Row Level Security por tabla. |
| **Edge Functions** | TypeScript/Deno. Reservadas para lógica de negocio con contrato estable que no debe filtrarse al cliente: cálculo de XP, procesamiento de invitaciones de perro compartido, cualquier flujo que se quiera versionar con intención (equivalente a un endpoint propio tipo Express/NestJS). |
| **Storage** | Archivos: fotos de perfil, fotos tipo "story" en POIs (buckets con políticas RLS propias, ej. "solo el dueño sube/reemplaza su avatar"). |

### Patrón de acceso a datos

- Tablas simples y estables (perfiles, mascotas) → acceso directo vía PostgREST desde Flutter, protegido por RLS.
- Lógica de negocio o alta probabilidad de evolucionar (XP, logros, invitaciones, rachas) → Edge Function con contrato fijo, para no romper al cliente si cambia la implementación interna.
- Versionamiento de contrato (equivalente a `v1/`, `v2/`): se resuelve a nivel de schema de Postgres con vistas (`api_v1.mascotas`, `api_v2.mascotas`) o, más simple, con Edge Functions cuyo path y payload no cambian aunque la lógica interna sí.

## 3. Esquema de datos y control de versiones

- **Monorepo**: el repo de Flutter incluye la carpeta `supabase/` (generada con `supabase init`), con:
  - `config.toml`
  - `migrations/*.sql` (versionadas en git, nombradas por timestamp)
- **Flujo de cambios de esquema:**
  1. `supabase migration new <nombre>` genera el archivo `.sql`.
  2. Se escribe el cambio (DDL + políticas RLS).
  3. Push a GitHub (rama principal) → webhook de Supabase detecta migraciones nuevas → las aplica automáticamente contra el proyecto, en orden de timestamp.
  4. Alternativa manual: `supabase db push` desde el CLI.
- **Nunca** editar el esquema de producción desde el Table Editor (UI) — no queda versionado. Si se usa para prototipar, generar el `.sql` equivalente después con `supabase db diff`.
- **Capa de repositorio en Flutter**: los nombres de tabla no se escriben sueltos en el código (`supabase.from('mascotas')` disperso). Se centralizan en clases tipo `MascotasRepository`, para que un rename de tabla implique cambiar una sola constante.

## 4. Panel de administración (POIs, contenido)

- **Repo separado** del repo de Flutter (cliente distinto, mismo backend).
- Consume el mismo proyecto Supabase vía `@supabase/supabase-js`.
- Las migraciones de esquema siguen viviendo **solo** en el repo de Flutter — el panel no define tablas, solo las consume.
- Pendiente de definir: mecanismo de rol admin (tabla `admins` consultada por las políticas RLS, o uso acotado de `service_role key` server-side, nunca expuesta en cliente).

## 5. Infraestructura y dominio

- **Dominio:** `pawseo.cl`, comprado en NIC Chile.
- **DNS:** administrado en Cloudflare (plan Free). Pendiente resolver a qué cuenta de Cloudflare queda asociado de forma definitiva.
- **Correo corporativo:** Google Workspace, cuenta `kevin.delgado@pawseo.cl` (una sola licencia por ahora).
- **Landing estática:** plataforma de hosting por definir (candidatas: Cloudflare Pages, Vercel).
- **Push notifications:** Firebase Cloud Messaging (FCM), independiente del resto de Firebase.
- **Analytics/Crashlytics:** Firebase, opcional, independiente de Firestore.

## 6. Pendiente inmediato

- Diseño completo del modelo de datos: mascotas (multi-dueño simétrico), sesiones de paseo, XP/niveles, logros, POIs. (`perfiles` ya existe — ver `docs/specs/auth.md`. Rachas y amistades: diferidas, ver `producto.md` §7.)
- Credenciales OAuth de Google (Cloud Console) para completar el login social.
- Crear el proyecto Supabase de producción cuando el MVP esté listo, y su `prod.json` correspondiente.
- Definir mecanismo de rol admin para el panel.
- Resolver ownership definitivo de la cuenta Cloudflare.

~~`supabase init` + `supabase link` en el repo de Flutter~~ — hecho, proyecto `pawseo-dev` linkeado.
