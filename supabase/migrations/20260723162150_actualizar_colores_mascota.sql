-- El catálogo original mezclaba colores sólidos (Negro, Blanco) con patrones
-- de pelaje (Atigrado, Bicolor, Tricolor, Manchado) -- los patrones no
-- ayudan a identificar una mascota perdida porque no dicen qué colores
-- tiene. Se reemplaza por colores sólidos únicamente; "Otro" cubre los
-- casos de pelaje mixto/patrón.
--
-- mascotas.color_id no tiene filas que referencien esta tabla todavía
-- (feature recién creada), por eso se puede reemplazar el contenido sin
-- riesgo de romper una FK existente.
delete from public.colores;

insert into public.colores (nombre) values
  ('Negro'),
  ('Blanco'),
  ('Gris'),
  ('Café claro'),
  ('Café oscuro'),
  ('Dorado'),
  ('Crema'),
  ('Rojizo'),
  ('Otro');
