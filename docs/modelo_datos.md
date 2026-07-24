# Modelo de Datos

**Estado:** `razas`, `colores`, `mascotas`, `mascotas_perfiles`, `paseos`, `paseos_mascotas`, `tipos_poi`, `pois` y el bucket `mascota-fotos` están migrados y **aplicados en `pawseo-dev`** (`supabase/migrations/2026072301*`, más `20260723153244` — fix de RLS, ver Decisiones —, `20260723162150` — catálogo de colores final — y `20260724015629` — POIs, seed ilustrativo en Santiago). `logros`/`mascotas_logros` siguen solo en diseño, sin migración. `paseos_pois` (check-in con recompensa) también sigue sin migrar — ver nota en la sección `pois`.
**Fecha:** 2026-07-24 (última actualización)
**Relacionado con:** `docs/producto.md` §7 (alcance MVP), `docs/tecnico.md` §3 (esquema y control de versiones) y §6 (pendiente inmediato)

---

## Cómo leer este documento

No sigue el formato de `docs/specs/_template.md` porque no es un feature aislado, es el esquema de datos transversal a varios (mascotas, paseos, gamificación, POIs). Se va actualizando en vivo a medida que avanza la conversación de diseño — refleja el estado más reciente **acordado en la conversación**, no necesariamente lo que ya está migrado en Supabase (eso lo determina el contenido real de `supabase/migrations/`).

## Convención de nombres

Tablas en **plural**, consistente con `perfiles` (ya implementada, ver `docs/specs/auth.md`). Tablas intermedias: `<tabla_a>_<tabla_b>`.

---

## Tablas

### `perfiles` (ya implementada)

| Columna | Tipo | Notas |
|---|---|---|
| `id` | uuid, PK | = `auth.users.id` |
| `email` | text | |
| `nombre` | text | |
| `avatar_url` | text, nullable | |
| `created_at` | timestamptz | |

### `mascotas`

| Columna | Tipo | Notas |
|---|---|---|
| `id` | uuid, PK | |
| `nombre` | text, **not null** | único campo obligatorio al crear |
| `foto_url` | text, nullable | se completa después, en la ficha editable |
| `raza_id` | uuid, FK → `razas`, nullable | ídem |
| `fecha_nacimiento` | date, nullable | ídem |
| `fecha_nacimiento_aproximada` | boolean, default `false` | resuelve el caso de no saber la fecha exacta |
| `color_id` | uuid, FK → `colores`, nullable | se completa después, en la ficha editable |
| `caracteristicas` | varchar(50), nullable | matices que no entran en el catálogo de color |
| `sexo` | text, nullable | parte de la ficha clínica (`producto.md` §7), se completa después |
| `peso` | numeric, nullable | ídem |
| `created_at` | timestamptz | |
| `creado_por` | uuid, FK → `perfiles`, **not null**, default `auth.uid()` | agregado post-implementación — ver Decisiones |

### `razas` (catálogo)
`id` uuid PK, `nombre` text unique

### `colores` (catálogo)
`id` uuid PK, `nombre` text unique

### `mascotas_perfiles` (join — multi-dueño simétrico)

| Columna | Tipo | Notas |
|---|---|---|
| `mascota_id` | uuid, FK → `mascotas` | PK compuesta con `perfil_id` |
| `perfil_id` | uuid, FK → `perfiles` | |
| `created_at` | timestamptz | fecha en que ese dueño quedó vinculado |

Se puebla vía **trigger** al crear la mascota (análogo al de `perfiles` en el signup): el creador queda auto-vinculado usando `auth.uid()`, sin insert manual del cliente. El flujo de invitación por código/enlace para sumar un segundo dueño después sigue sin diseñar — ver Pendiente.

### `paseos`

| Columna | Tipo | Notas |
|---|---|---|
| `id` | uuid, PK | |
| `iniciado_en` | timestamptz | |
| `finalizado_en` | timestamptz, nullable | nullable deja espacio a un paseo "en curso" sin columna de estado aparte |
| `pasos` | integer, nullable | nullable por dispositivos sin sensor de podómetro (`producto.md` §9) |
| `creado_por` | uuid, FK → `perfiles`, **not null**, default `auth.uid()` | agregado post-implementación — ver Decisiones |

### `paseos_mascotas` (join — un paseo puede tener más de un perro)

`paseo_id` FK → `paseos`, `mascota_id` FK → `mascotas`, PK compuesta.

### `paseos_pois` (check-ins durante el paseo)

| Columna | Tipo | Notas |
|---|---|---|
| `paseo_id` | uuid, FK → `paseos` | PK compuesta con `poi_id` |
| `poi_id` | uuid, FK → `pois` | |
| `visitado_en` | timestamptz | |

**Solo se inserta vía Edge Function**, nunca por PostgREST directo — necesita validar proximidad GPS real y el cooldown anti-farming server-side (ver Decisiones).

### `stats` (1:1 con `mascotas`)

| Columna | Tipo | Notas |
|---|---|---|
| `mascota_id` | uuid, PK, FK → `mascotas` | |
| `nivel` | integer, default 1 | cacheado, no derivado en cada lectura |
| `experiencia_total` | integer, default 0 | acumulado histórico, nunca resetea |
| `updated_at` | timestamptz | |

`experiencia_siguiente_nivel` **no existe como columna** — se calcula en `domain/` a partir de `experiencia_total` vía una fórmula/curva testeada (ver Decisiones).

### `logros` (catálogo)

`id` uuid PK, `nombre` text, `descripcion` text, `criterio` — **estructura aún sin definir** (ver Pendiente).

Ejemplo concreto ya acordado (aunque el `criterio` estructurado siga pendiente): logro por **completar la ficha de la mascota** (llenar raza, nacimiento, color, sexo, peso — todo lo que quedó opcional en la creación).

### `mascotas_logros` (join)

`mascota_id` FK, `logro_id` FK, `obtenido_en` timestamptz, PK compuesta.

### `tipos_poi` (catálogo, migrado)

`id` uuid PK, `nombre` text — separa lugares públicos (plaza, canil) de comerciales (vet, petshop).

### `pois` (migrado, `20260724015629_create_pois.sql`)

| Columna | Tipo | Notas |
|---|---|---|
| `id` | uuid, PK | |
| `latitud` | double precision | |
| `longitud` | double precision | |
| `tipo_id` | uuid, FK → `tipos_poi` | |
| `foto_url` | text, nullable | |
| `nombre` | text | |
| `descripcion` | text, nullable | |
| `comuna` | text | filtrado/curación por comuna piloto (`producto.md` §6) |
| `recompensa_xp` | integer | |
| `created_at` | timestamptz | |

RLS de solo lectura (`for select to authenticated using (true)`), sin policy de escritura — se administra a mano vía SQL, no hay panel de administración todavía (`tecnico.md` §4).

**`recompensa_xp` se migró tal como estaba diseñada, pero hoy no tiene ningún consumidor**: el tab Paseo (`paseo_screen.dart`) solo pinta los POIs como marcadores en el mapa — no hay check-in, no se entrega XP, no hay verificación de proximidad GPS. Esa lógica sigue viviendo en la tabla `paseos_pois` (más abajo), que **no se migró** en este cambio a propósito: necesita una Edge Function con verificación GPS real y cooldown anti-farming, es una feature aparte.

Radio de check-in: **fijo, 50m** — constante en código (Edge Function/`domain/`), no columna. No varía por POI todavía. Sigue sin implementar (ver nota de `paseos_pois` arriba).

---

## Decisiones de diseño (el porqué)

- **`mascotas_perfiles` y `paseos_mascotas` como tablas intermedias explícitas**: multi-dueño y multi-perro son muchos-a-muchos reales, no un FK simple — evita duplicar filas de `paseos` por cada mascota participante.
- **`experiencia_siguiente_nivel` no se persiste**: es lógica de negocio (curva de niveles) que CLAUDE.md exige testear en `domain/`; guardarla arriesga desincronizarse si la curva cambia. `nivel` sí se cachea, pero se actualiza únicamente cuando la Edge Function agrega XP nueva — así un cambio futuro de curva no le sube el nivel retroactivamente a perros existentes sin que ganen XP nueva.
- **Check-ins (`paseos_pois`) solo vía Edge Function**: si el cliente pudiera insertar la fila directo, se salta tanto la verificación real de proximidad GPS como el cooldown anti-farming.
- **Cooldown anti-farming se valida contra (mascota, poi)**, no contra (paseo, poi) — el XP es por perro, así que la pregunta relevante es "¿esta mascota ya reclamó este POI en las últimas X horas, en cualquier paseo?", no solo dentro del paseo actual.
- **Radio de check-in fijo (50m)** como constante, no columna — simplifica, se revisita si en el futuro un tipo de POI necesita un radio distinto.
- **`color` como catálogo de selección única** + `caracteristicas` como texto libre corto (≤50) para matices que no entran en una lista cerrada (ej. "negro y blanco").
- **Se descartó agregar quién registró el paseo** (dueño específico dentro del hogar) — decisión de producto: el protagonista es la mascota, no hay competencia entre dueños. Es aditivo y barato agregarlo después si cambia el criterio; no se justifica ahora.
- **Nombres de tabla en plural**, consistente con `perfiles` (ya implementada).
- **Solo `nombre` es obligatorio al crear una mascota** — el resto (foto, raza, nacimiento, color, características, sexo, peso) se completa después en una ficha editable. Esto además es la base de un logro ("completar la ficha").
- **`mascotas_perfiles` se llena vía trigger**, mismo patrón que `perfiles` en el signup — evita depender de que el cliente haga bien el segundo insert, y deja la vinculación inicial fuera de alcance de RLS manual.
- **`creado_por` en `mascotas` y `paseos` (agregado post-implementación, `20260723153244`)**: el cliente crea con `.insert().select().single()` (`INSERT ... RETURNING`) para tener de vuelta la fila recién creada en una sola ida y vuelta. Postgres exige que la fila del `RETURNING` también pase la policy de `SELECT` de la tabla — pero esa policy dependía únicamente de `mascotas_perfiles`/`paseos_mascotas`, pobladas por un trigger `AFTER INSERT` (mascotas) o por un segundo insert del cliente (paseos, ver `PaseosRepository.iniciarPaseo`). El `RETURNING` se evalúa sin ver todavía ese efecto posterior, así que el INSERT se ejecutaba pero el cliente recibía `new row violates row-level security policy for table "mascotas"` (reproducido corriendo la query real de PostgREST contra `pawseo-dev`). Fix: columna `creado_por` en la propia fila (no depende de que otro statement haya corrido) + policy de SELECT `creado_por = auth.uid() OR EXISTS (...)`. Cualquier tabla nueva que use el patrón "crear y vincular a un dueño vía trigger/insert aparte" **y** quiera `RETURNING` en el mismo request necesita este mismo `creado_por`, no solo el vínculo en la tabla intermedia.

## Pendiente / no resuelto todavía

- **Invitación de mascota compartida** (código/enlace, `producto.md` §7 / `tecnico.md` §3) — el mecanismo que llena `mascotas_perfiles` no está diseñado.
- **Estructura de `criterio` en `logros`** — cómo la Edge Function determina automáticamente qué logro desbloquear (¿tipo + valor umbral genérico? ¿lógica específica por logro?).
- **Recordatorio de paseo configurable** (ítem de alcance del MVP, `producto.md` §7) — sin tabla todavía; falta decidir si es config por `perfil` o por `mascota`, y qué parámetros guarda (hora, días de la semana).
- **RLS de `razas`, `colores`, `mascotas`, `mascotas_perfiles`, `paseos`, `paseos_mascotas`, `tipos_poi`, `pois`**: ya implementada. Sigue pendiente para `logros`, `mascotas_logros` — no existen todavía.
- **Rol admin** (`tecnico.md` §4: tabla `admins` + `is_admin()`) — mismo dominio de datos, no evaluado en esta conversación todavía.
- **POI patrocinado** (fase 3 de negocio, `producto.md` §8) — no bloqueante para MVP; cuando se active, probablemente un flag en `pois` + relación con el comercio dueño.
- **XP y `stats`**: al detener un paseo hoy no se otorga experiencia -- la tabla `stats` y la curva de niveles siguen sin implementar. El paseo se guarda con su duración, pero no impacta nivel/XP todavía. El tab "Mi Mascota" (`mi_mascota_screen.dart`) ya tiene un placeholder visual de nivel/XP con valores fijos -- pendiente reemplazar por datos reales cuando se diseñe la curva.
- ~~Selección de con qué perro(s) salir a pasear~~ **Resuelto** (2026-07-24): con 2+ mascotas, el botón "¡Vamos a pawsear!" pregunta con cuáles ir (todas premarcadas por defecto) vía `paseo_mascotas_selector.dart` / `debeMostrarSelectorMascotas` (`paseo_mascota_selection.dart`). Con 1 sola mascota no pregunta, pasea directo con ella.
- **Conteo de pasos (podómetro)**: `paseos.pasos` queda siempre `null` por ahora -- la integración con el sensor de pasos del dispositivo no está implementada (requiere permisos de Android 10+ y un paquete de pedómetro, se dejó fuera de esta iteración).
- **Paseo en curso no persiste entre reinicios de la app**: el estado de "hay un paseo activo" vive en memoria (Riverpod), no se recupera si se cierra la app a mitad de un paseo.

---

## Data semilla (aplicada en `pawseo-dev`)

### `razas`

Incluye **Mestizo** primero a propósito — en Chile el perro mestizo/quiltro es, si acaso, más común que cualquier raza pura, así que no puede quedar como una opción más al final de la lista. `Otra` cierra la lista para lo que no calce (texto libre en `caracteristicas` si hace falta precisar).

Mestizo, Labrador Retriever, Golden Retriever, Caniche (Poodle), Bulldog Francés, Chihuahua, Yorkshire Terrier, Pug, Schnauzer, Beagle, Cocker Spaniel, Husky Siberiano, Pastor Alemán, Bulldog Inglés, Shih Tzu, Salchicha (Teckel), Boxer, Rottweiler, Border Collie, Dálmata, Pitbull, Doberman, Chow Chow, Maltés, Basset Hound, Fox Terrier, Akita, Otra.

### `colores`

Revisado 2026-07-23 — la primera versión (`20260723010000`) mezclaba colores sólidos con patrones de pelaje (Atigrado, Bicolor, Tricolor, Manchado). Los patrones no ayudan a identificar una mascota perdida porque no dicen qué colores tiene realmente. Reemplazada por colores sólidos únicamente (`20260723162150_actualizar_colores_mascota.sql`):

Negro, Blanco, Gris, Café claro, Café oscuro, Dorado, Crema, Rojizo, Otro.

*(`Otro` cubre pelaje mixto/patrón — el detalle fino, si importa, va en `caracteristicas`.)*

### `tipos_poi` / `pois`

Seed **ilustrativo**, no la curación real por comuna piloto que describe `producto.md` §6 — 4 tipos (Plaza, Canil, Veterinaria, Petshop) y 8 POIs de ejemplo en Santiago Centro/Providencia/Ñuñoa/Las Condes/Vitacura (`20260724015629_create_pois.sql`). Reemplazar/expandir cuando exista curación real.

## Storage buckets — cómo funcionan (para cuando se implemente)

Un **bucket** en Supabase Storage es básicamente una carpeta raíz de un object storage (compatible con S3) — un contenedor con su propio nombre (ej. `mascotas`) donde se suben archivos a rutas tipo `mascotas/<mascota_id>/foto.jpg`. Cada bucket puede ser público (URL directa sin auth) o privado.

Las reglas de quién puede subir/leer/borrar **no son las políticas RLS de Postgres** — son políticas RLS aparte, sobre la tabla interna `storage.objects`, pero se escriben igual (SQL con `auth.uid()`). Ejemplo de la idea (a definir en detalle cuando se implemente): permitir INSERT solo si el `mascota_id` en la ruta del archivo corresponde a una fila de `mascotas_perfiles` donde `perfil_id = auth.uid()` — mismo patrón de "solo el dueño" que ya usan con el avatar de `perfiles` (`tecnico.md` §2, tabla Storage).

**Ya resuelto**: bucket `mascota-fotos`, **público** (evita lógica de signed URLs en el cliente para el MVP -- la foto no es información sensible), con políticas de INSERT/UPDATE restringidas al dueño vía `mascotas_perfiles` sobre la ruta `mascota-fotos/<mascota_id>/...` (ver migración `20260723010300_create_mascota_fotos_bucket.sql`). La UI para subir la foto en sí todavía no existe -- la creación de mascota solo pide `nombre`.
