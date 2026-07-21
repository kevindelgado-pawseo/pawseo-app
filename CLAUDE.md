# Pawseo — CLAUDE.md

App Flutter que gamifica el paseo diario del perro (XP, niveles, rachas, logros, POIs pet). Ver specs completas en [`docs/producto.md`](docs/producto.md) y [`docs/tecnico.md`](docs/tecnico.md).

Specs de features individuales viven en `docs/specs/`, siguiendo el formato de [`docs/specs/_template.md`](docs/specs/_template.md). Al recibir una, revisar contra este documento y flaggear huecos/alternativas antes de implementar.

## Cómo trabajamos

- Kevin es dev senior mobile (background nativo), actúa como **generador de specs**: da contexto de qué quiere, por qué, y qué problema resuelve. Prácticamente no escribe código él mismo — lo audita de vez en cuando, no continuamente.
- Por eso: **la calidad no puede depender de revisión manual línea a línea**. Linter estricto, tests en lógica de negocio y una arquitectura que haga difícil equivocarse son el mecanismo real de control de calidad, no el ojo humano.
- **No ser complaciente.** Si un spec tiene un caso borde no contemplado, contradice la arquitectura existente, o hay una solución técnica mejor: decirlo *antes* de implementar, no implementar ciegamente. Proponer alternativas con su tradeoff cuando aplique.
- **Reutilización activa por defecto.** Antes de crear un widget, repository o provider nuevo, revisar si ya existe algo parecido en `core/` u otro feature. Regla práctica: al segundo uso casi-idéntico (no al tercero), extraer y parametrizar. Este proyecto ya tiene un historial de "botón duplicado / dos widgets que hacen casi lo mismo" como falla a evitar activamente.
- Sin abstracciones especulativas más allá del spec actual — salvo primitivas de UI (botones, cards, inputs) donde construir reutilizable desde el inicio sí se justifica, porque la duplicación de esas piezas es el error recurrente que este proyecto quiere evitar.

## Stack técnico

- **Flutter**, dev en Windows → iOS + Android.
- **Supabase**: Postgres + Auth (GoTrue, email/password + Google OAuth) + PostgREST + Edge Functions (Deno/TS) + Storage. RLS obligatoria en toda tabla, nada expuesto por defecto.
- **Riverpod** (`riverpod_generator`, sin `flutter_hooks`) para estado y DI. Motivo: menos boilerplate que Bloc vía code-gen, providers testeables por override, encaja natural con el patrón repository.
- **go_router** para navegación. Motivo: recomendación oficial del equipo Flutter, deep linking de primera clase — necesario para el flujo de invitación de perro compartido (código/enlace).
- **freezed + json_serializable** para modelos inmutables (evita bugs de `copyWith`/`==`/serialización escritos a mano). Postgres usa `snake_case`, Dart usa `camelCase` → mapeo vía `fieldRename: FieldRename.snake` en `build.yaml`, no anotaciones sueltas por campo.
- **flutter_dotenv** o `--dart-define-from-file` con JSON por ambiente (`dev.json`, gitignored) para URL/anon key de Supabase. La `service_role key` nunca va en el cliente Flutter, bajo ninguna circunstancia.

## Arquitectura de carpetas

Feature-first, no layer-first (evita el antipatrón de carpetas `screens/`, `widgets/`, `models/` con todo el proyecto mezclado):

```
lib/
  core/
    theme/
    widgets/        # design system: botones, cards, inputs reutilizables
    router/
    utils/
  features/
    auth/
      data/         # repositories, DTOs
      domain/       # entidades y lógica de negocio pura (sin Flutter/Supabase)
      presentation/ # screens, widgets, providers/controllers
    dogs/
    walks/
    gamification/   # XP, niveles, logros (rachas: diferido a v2, ver docs/producto.md §7)
    pois/
  app.dart
  main.dart
```

- **Patrón repository obligatorio**: la UI y el `domain/` nunca llaman a `supabase.from(...)` directo. Una clase por agregado (`DogsRepository`, `WalksRepository`) decide internamente si usa PostgREST o una Edge Function.
- **Manejo de errores**: los repositories nunca dejan escapar `PostgrestException`/`AuthException` crudas hacia la UI. Envolver en un `Result<T>` sellado (sealed class con Dart 3, sin librería FP externa — no se justifica para este tamaño de proyecto) con casos `Success`/`Failure`.
- **Herramientas de desarrollo (checks de dispositivo, feature flags, resets)**: viven todas en `features/debug_settings/` como entradas de una sola pantalla (`DebugSettingsScreen`), no dispersas como botones sueltos en pantallas reales. La ruta se registra solo con `kDebugMode` (`core/router/app_router.dart`) — no existe ni es alcanzable en un build de release.

## Convenciones de código

- **Comentarios: casi ninguno.** Solo cuando el *por qué* no es obvio (una restricción oculta, un workaround puntual). Nunca explicar el *qué* — el nombre de la variable/función ya lo dice.
- Nombres de identificadores y código en **inglés**; strings de UI en **español** (mercado objetivo).
- **Ningún string de UI directo en un widget.** Todo texto visible para el usuario vive en una clase `abstract final class <Feature>Strings` dentro de `presentation/` del feature correspondiente (ej. `onboarding_strings.dart`) — `static const` para texto fijo, método estático para texto con interpolación (ej. `levelUp(int level) => 'Subiste a nivel $level'`). No se usa `intl`/`.arb` todavía (no hay necesidad de multi-idioma en el MVP), pero como los widgets solo referencian símbolos (`OnboardingStrings.title1`, no el string literal), migrar a `intl` más adelante es un reemplazo mecánico, no un rediseño. Strings realmente transversales entre features recién se extraen a `core/strings/` la segunda vez que se repiten — no antes (misma regla de reutilización de siempre).
- Lint estricto: extender `flutter_lints` con reglas adicionales (o adoptar `very_good_analysis`) — es el sustituto de la revisión manual continua.
- Sin barrel files (`export` acumulativos) salvo que se vuelvan realmente necesarios — imports explícitos siguen el estilo oficial de Dart y evitan ciclos de import silenciosos.

## Testing

Dado que la auditoría es periódica, no continua, los tests son la red de seguridad real:

- **Obligatorio**: unit tests en todo `domain/` con lógica no trivial — cálculo de XP, curva de niveles, lógica de rachas. Es la lógica más fácil de romper sin notarlo y la más cara de romper en producción (afecta percepción de "justicia" del juego).
- **Obligatorio**: tests de repository con mock del cliente Supabase.
- **Recomendado, no bloqueante para MVP**: widget tests de componentes en `core/widgets`.
- Screens completas: sin test obligatorio en esta etapa (velocidad > cobertura total en MVP).

## Supabase — reglas de esquema

- Migraciones **solo** vía `supabase migration new` + `.sql` versionado en `supabase/migrations/`. Nunca editar producción desde el Table Editor.
- RLS explícita en cada tabla nueva, sin excepción.
- **Nota sobre versionamiento de contrato** (matiz sobre `tecnico.md` §2): el riesgo real de mantener vistas `api_v1`/`api_v2` desde el día uno es que aún no existe una v1 en producción — es infraestructura para un problema que todavía no ocurre. Sí es un riesgo real en mobile (a diferencia de web, versiones viejas de la app quedan vivas post-release porque el usuario no actualiza al instante). Regla pragmática: migraciones de tabla vía PostgREST deben ser aditivas (agregar columnas, no renombrar/eliminar) por defecto; introducir vistas versionadas o un nuevo path de Edge Function solo cuando exista un cambio realmente breaking *después* de que haya versiones de la app en la calle — no antes.
- Rol admin (pendiente en `tecnico.md` §4): preferir tabla `admins` + función `is_admin()` consultada desde políticas RLS, no `service_role key` — mantiene todo bajo el mismo modelo de auth y evita el riesgo de una key con bypass total de RLS.

## Pendiente

Ver §6 de `docs/tecnico.md` para el diseño de modelo de datos y setup de Supabase CLI — ese es el próximo bloque de trabajo real, esto es solo la base de convenciones.
