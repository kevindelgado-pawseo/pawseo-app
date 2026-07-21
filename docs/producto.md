# Documento de Producto

**Producto:** Pawseo — app de paseos de perros gamificada
**Versión del documento:** 0.2 · Julio 2026
**Autor:** Kevin Delgado Jiménez
**Estado:** Borrador para revisión

---

## 1. Resumen ejecutivo

Pawseo es una aplicación móvil que convierte el paseo diario del perro en un juego: tu perro real sube de nivel, gana logros y mantiene rachas cada vez que sale a pasear. Los paseos se enriquecen con puntos de interés del mundo pet (caniles, plazas, veterinarias, tiendas de mascotas) que entregan recompensas al visitarlos caminando.

El producto ataca un hábito que ya existe — en promedio, los perros urbanos se pasean una o dos veces al día — y lo hace más entretenido, más constante y más social, sin exigirle al usuario ningún comportamiento nuevo.

El lanzamiento inicial es hiperlocal (comunas de Santiago de Chile), con un modelo de negocio de mediano plazo basado en comercios pet como puntos de interés patrocinados.

---

## 2. El problema

El paseo del perro es una obligación diaria que, con el tiempo, se vuelve monótona: las mismas cuadras, la misma plaza, el mismo horario. Esto produce dos efectos:

1. **Paseos más cortos y menos frecuentes de lo que el perro necesita.** La motivación del dueño decae, y el bienestar del perro depende directamente de esa motivación.
2. **Una experiencia diaria sin memoria ni progreso.** Cientos de horas caminadas junto a la mascota no dejan registro, historia ni sensación de logro.

Adicionalmente, en hogares con más de un dueño (parejas, familias), el paseo es una responsabilidad compartida sin ninguna herramienta de coordinación: nadie sabe cuánto ha caminado el perro esta semana en total.

Para los comercios del rubro mascotas (veterinarias, petshops, peluquerías caninas), el problema espejo es la dificultad de atraer clientes que pasan caminando por su puerta todos los días sin entrar.

## 3. La solución

Una app donde **el protagonista es el perro real del usuario**:

- Cada paseo suma **experiencia**: el perro sube de nivel y desbloquea **logros**. *(Rachas de días paseados: diferido a una versión posterior — ver §7 y §10.)*
- El mapa muestra **puntos de interés pet** cercanos; llegar caminando a un canil, plaza o veterinaria entrega recompensas y colecciona la insignia del lugar.
- El perfil del perro es **compartido**: todos los miembros del hogar pasean al mismo perro desde sus propios teléfonos y contribuyen al mismo progreso, con los mismos permisos entre todos los dueños vinculados.
- Cada paseo genera una **tarjeta compartible** (foto del perro, estadísticas, nivel) para redes sociales.

El principio de diseño central: el paseo deja de ser una tarea repetitiva que se cumple por obligación y pasa a sentirse como una aventura junto al perro. No se trata de automatizar el paseo de siempre agregándole un botón de inicio — durante la sesión el usuario explora activamente lugares cercanos, descubre puntos de interés que entregan EXP, y ve avanzar el progreso de su perro en tiempo real. La app gamifica lo que hoy puede dar flojera, para que salir con el perro se vuelva algo que dan ganas de hacer.

## 4. Para quién es

**Segmento principal:** dueños de perros urbanos, 20 a 45 años, que pasean a su perro regularmente y usan el teléfono como parte de su vida cotidiana. Dentro de este grupo, los adoptantes tempranos más probables son los usuarios afines a apps de hábitos y bienestar gamificado (perfil tipo usuarios de Finch, Duolingo, apps cozy), un público mayoritariamente femenino y de alta disposición a compartir contenido de sus mascotas.

**Subsegmento clave:** hogares multi-dueño (parejas y familias que se turnan los paseos) y hogares multi-perro. El modelo de perfil compartido está diseñado específicamente para ellos.

**Cliente comercial (fase posterior):** veterinarias, petshops, peluquerías y comercios pet de barrio, que pagarán por convertirse en puntos de interés destacados con ofertas canjeables por visita presencial.

**Contexto de mercado (supuesto a validar con cifras):** Chile presenta una de las tasas de tenencia de mascotas más altas de la región, con fuerte cultura de perro urbano y un rubro comercial pet en crecimiento sostenido. *[Pendiente: respaldar con datos de fuentes oficiales/gremiales antes de usar este documento comercialmente.]*

## 5. Objetivo del producto

**Objetivo de la versión 1:** validar el loop central — *pasear → progresar → querer volver a pasear* — con usuarios reales de comunas piloto de Santiago, alcanzando retención de hábito medible antes de invertir en capa social y comercial.

**Métrica norte propuesta:** paseos registrados por perro por semana (proxy directo de valor entregado al usuario y al perro).

**Métricas secundarias:** retención a 4 semanas, tarjetas compartidas por usuario, perfiles de perro con más de un dueño vinculado.

**Objetivo de mediano plazo:** construida la base de usuarios, activar el lado comercial (puntos patrocinados con canje presencial) y evolucionar hacia la capa social (amigos, actividad en puntos de interés, alertas comunitarias).

## 6. Propuesta de valor y diferenciación

| Para | El valor |
|---|---|
| El dueño | El paseo obligatorio se vuelve entretenido; el tiempo con su perro deja registro, historia y logros. |
| El perro | Más paseos, más largos y más constantes (la racha protege su rutina). |
| El hogar | Coordinación natural del paseo compartido y un objetivo cooperativo común. |
| El comercio pet | Clientes que llegan caminando hasta su puerta, pagando solo por visitas reales. |

**Diferenciación frente a lo existente:**
- Las apps de tracking de mascotas registran datos pero no motivan (sin juego).
- Las apps sociales caninas (mapas en tiempo real, matchmaking) dependen de tener masa de usuarios desde el día uno y fallan en el arranque. Nuestro loop central funciona con un solo usuario; lo social se agrega cuando hay comunidad.
- Las apps de pasos gamificadas (mascota virtual) usan un personaje genérico; aquí el personaje es tu propio perro, un vínculo emocional que ninguna mascota virtual iguala.
- Ninguna app del género tiene presencia relevante en Chile: la estrategia hiperlocal (curación de puntos de interés comuna por comuna) crea una ventaja difícil de copiar a distancia.

## 7. Alcance de la versión 1 (MVP)

- Cuenta de persona con una o más mascotas asociadas.
- Perfil de perro compartible entre cuentas mediante invitación (código/enlace).
- Sesión de paseo por tiempo y pasos (podómetro del dispositivo), con soporte para pasear varios perros a la vez.
- Sistema de experiencia, niveles y logros (por perro).
- Recordatorio de paseo configurable.
- Puntos de interés con check-in **verificado por GPS** (proximidad al lugar) e insignias coleccionables (seed inicial: comunas piloto de Santiago).
- Historial de paseos y tarjeta compartible.
- **Ficha clínica del perro**: raza, sexo, peso, color, características. Pensada para poder mostrarse directamente en una visita al veterinario.

**Explícitamente fuera del MVP** (fases posteriores): registro y calendario de vacunas, rachas (streaks) de días paseados, tracking GPS de la ruta, amigos y notificaciones sociales, stories y actividad en puntos de interés, alertas de perro perdido y reportes de peligro, resumen semanal, alerta de calor para patas, Live Activity/widget, cupones de comercios, modo paseador profesional.

> **Nota (Julio 2026):** las rachas se diferieron deliberadamente — castigar con dureza un día sin paseo no refleja situaciones reales (viaje de fin de semana, cuidador temporal sin la app, no querer ceder ownership del perro por unos días). Se retomará con una versión que contemple estos casos (ej. pausas o "freezes").

## 8. Modelo de negocio

- **Fase 1 (lanzamiento):** app gratuita, sin monetización. Foco total en retención y crecimiento orgánico (tarjetas compartibles).
- **Fase 2 (comunidad):** capa social; la app se vuelve más valiosa con cada usuario del barrio.
- **Fase 3 (monetización):** puntos de interés patrocinados — comercios pet pagan por destacar su ubicación con recompensas canjeables en persona. El comercio paga por visitas físicas verificadas, no por impresiones. Posible complemento: suscripción premium cosmética (personalización de perfil, insignias especiales), nunca bloqueando el loop central.

## 9. Riesgos y supuestos principales

| Riesgo / supuesto | Mitigación |
|---|---|
| El loop de juego no basta para cambiar el hábito de paseo. | MVP barato y medible; la métrica norte lo valida o descarta rápido. |
| Fundador sin perro propio: distancia con el usuario. | Investigación con dueños reales antes del spec; beta cerrada con 5+ hogares perridueños; acompañamiento de paseos reales. |
| Dispositivos Android de gama baja sin sensor de pasos. | Degradación por capacidades: la sesión funciona solo con tiempo. |
| Comercios no dispuestos a pagar (fase 3). | La monetización no se asume en v1; se valida con pitch presencial cuando exista base de usuarios que mostrar. |
| Copia por parte de un actor grande. | Velocidad + curación hiperlocal + comunidad de barrio como foso defensivo. |

## 10. Pendientes de este documento

- Cifras de mercado con fuente verificable.
- Definición de comunas piloto exactas.
- Criterios numéricos de éxito/fracaso del MVP (umbral de la métrica norte).
