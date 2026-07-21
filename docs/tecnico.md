# Pawseo — Documento Técnico

**Versión:** 0.1 · Julio 2026
**Complementa a:** `producto.md` (visión, MVP y modelo de negocio)

---

## 1. Frontend

- **Flutter**, desarrollo en Windows, apuntando a iOS + Android nativos. **Sin soporte web** — se descartó explícitamente (era solo scaffold por defecto de `flutter create`, nunca un target real); las pruebas se hacen en emuladores Android / dispositivos reales.
- SDK `supabase_flutter` como puente al backend.
- Login social:
  - Google en ambas plataformas (`google_sign_in`).
  - Sign in with Apple en iOS (`sign_in_with_apple`) — obligatorio por política de Apple al ofrecer login social de terceros.
  - Botones de login: usar componentes/branding oficiales de cada proveedor (Apple exige su componente nativo con estilos cerrados; Google tiene guías de marca propias). El resto de la pantalla de login es diseño custom.
- Detección de plataforma con `Platform.isIOS` / `Platform.isAndroid` (paquete `dart:io`) para mostrar u ocultar el botón de Apple.

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

- Diseño completo del modelo de datos: perfiles, mascotas (multi-dueño simétrico), sesiones de paseo, XP/niveles, logros, POIs. (Rachas y amistades: diferidas, ver `producto.md` §7.)
- `supabase init` + `supabase link` en el repo de Flutter.
- Definir mecanismo de rol admin para el panel.
- Resolver ownership definitivo de la cuenta Cloudflare.
