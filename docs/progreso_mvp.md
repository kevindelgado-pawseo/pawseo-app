# Progreso del MVP

**Fecha:** 2026-07-25
**Fuente:** snapshot derivado de `docs/producto.md` §7-8 y `docs/modelo_datos.md`/`docs/tecnico.md` — no es un documento de decisiones, es una foto del avance real. Se desactualiza apenas se implemente algo nuevo; pedir que se regenere después de cada bloque de trabajo grande.

---

## Resumen

De los **8 puntos de alcance del MVP** (`producto.md` §7):

- ✅ **Hecho:** 2
- 🟡 **Parcial:** 2
- ⬜ **Pendiente:** 4

---

## Alcance MVP, ítem por ítem

### ✅ Cuenta de persona con una o más mascotas asociadas
Login email/contraseña funcional. Crear mascota (solo `nombre` obligatorio), editar ficha completa, soporte multi-mascota real (`mascotas_perfiles`, `misMascotasProvider`). Login con Google queda **pausado** (no bloqueante — ya hay email/contraseña), Apple Sign In **diferido** por costo (Apple Developer Program, ver `tecnico.md` §1).

### ⬜ Perfil de perro compartible entre cuentas mediante invitación (código/enlace)
La base de datos ya soporta multi-dueño (`mascotas_perfiles` es una tabla muchos-a-muchos, poblada vía trigger para quien crea la mascota), pero **el mecanismo de invitación en sí — generar un código/enlace y que otra cuenta se sume como segundo dueño — no está diseñado ni construido.**

### 🟡 Sesión de paseo por tiempo y pasos, con soporte para pasear varios perros a la vez
- Tiempo: hecho — iniciar/detener paseo, timer en vivo, se guarda en `paseos`.
- Multi-perro: hecho — con 2+ mascotas pregunta con cuáles ir (todas premarcadas por defecto), con 1 arranca directo.
- **Pasos (podómetro): pendiente** — `paseos.pasos` siempre queda `null`, no hay integración con el sensor del dispositivo.

### ⬜ Sistema de experiencia, niveles y logros (por perro)
El tab Mi Mascota muestra nivel/XP, pero es un **placeholder visual con valores fijos** — no existe la tabla `stats`, no se calcula ninguna curva de niveles, y terminar un paseo no otorga experiencia todavía. `logros`/`mascotas_logros` tampoco están migrados; falta incluso definir la estructura de `criterio` (cómo se determina automáticamente qué logro desbloquear).

### ⬜ Recordatorio de paseo configurable
No iniciado — sin tabla, sin UI, sin placeholder siquiera.

### 🟡 Puntos de interés con check-in verificado por GPS e insignias coleccionables
- Hecho: `pois`/`tipos_poi` migrados y con RLS, mapa del tab Paseo con estilo cozy propio, marcadores circulares personalizados (foto o inicial), modal de detalle (descripción + XP que otorgaría). Seed real (no ilustrativo) de 3 lugares cerca de Mall Plaza Egaña — falta expandir a la curación completa por comuna piloto.
- **Pendiente: el check-in en sí.** Hoy el modal siempre dice "nunca has visitado este lugar" porque no existe ningún registro de visitas — ni verificación de proximidad GPS, ni Edge Function, ni cooldown anti-farming (`paseos_pois` no está migrada, a propósito).
- **Pendiente: insignias coleccionables** — no hay ningún concepto de insignia/badge implementado todavía.

### ⬜ Historial de paseos y tarjeta compartible
Cada paseo queda guardado en la base (`paseos`, con duración e inicio/fin), pero **no hay ninguna pantalla que muestre ese historial** — solo se ve el paseo activo mientras está en curso. La tarjeta compartible (foto + estadísticas + nivel para redes sociales) no está iniciada.

### ✅ Ficha clínica del perro
Raza, sexo, peso, color, características, fecha de nacimiento (con opción de aproximada) — todo implementado, con catálogos de razas/colores reales migrados y editable desde `EditarMascotaScreen`.

---

## Infraestructura / no-features, pero bloqueantes para lanzar

- **Proyecto Supabase de producción**: no existe todavía (`pawseo-dev` es el único ambiente real hoy). Se crea deliberadamente recién cuando el MVP esté listo.
- **Rol admin** (para el futuro panel de administración de POIs/contenido): mecanismo sin definir.
- **Signing de release real**: el build "release" hoy sigue firmado con el keystore de debug (placeholder, ver `android/app/build.gradle.kts`).
- **Ownership de la cuenta Cloudflare** (DNS de `pawseo.cl`): sin resolver.
- **Landing estática**: plataforma de hosting sin definir.
- **Google OAuth**: credenciales de Cloud Console pendientes para retomar (hay runbook completo en `tecnico.md` §1 para cuando se retome).

---

## Explícitamente fuera del MVP (backlog v2+)

Ítems que **no** cuentan como pendiente del MVP — están fuera de alcance a propósito (`producto.md` §7):

- Registro y calendario de vacunas.
- Rachas (streaks) de días paseados — diferidas deliberadamente (castigar con dureza un día sin paseo no refleja situaciones reales de la vida; se retoma con soporte de pausas/"freezes").
- Tracking GPS de la ruta caminada.
- Amigos y notificaciones sociales.
- Stories y actividad en puntos de interés.
- Alertas de perro perdido y reportes de peligro.
- Resumen semanal.
- Alerta de calor para patas.
- Live Activity / widget.
- Cupones de comercios.
- Modo paseador profesional.

## Modelo de negocio — fase actual

**Fase 1 (actual): gratuita, sin monetización**, foco en retención y crecimiento orgánico. Confirmado y respetado explícitamente — la idea de cobrar por slot de mascota adicional se evaluó y se descartó por ahora (contradice esta fase). Fase 2 (capa social) y Fase 3 (monetización con POIs patrocinados) son posteriores al MVP, sin trabajo iniciado.
