-- Catálogos de referencia para la ficha de mascota. Solo lectura desde el
-- cliente -- se administran a mano vía migración, no hay UI de escritura.
create table public.razas (
  id uuid primary key default gen_random_uuid(),
  nombre text not null unique
);

create table public.colores (
  id uuid primary key default gen_random_uuid(),
  nombre text not null unique
);

alter table public.razas enable row level security;
alter table public.colores enable row level security;

create policy "select_razas"
  on public.razas for select
  to authenticated
  using (true);

create policy "select_colores"
  on public.colores for select
  to authenticated
  using (true);

grant select on public.razas to authenticated;
grant select on public.colores to authenticated;

-- Mestizo primero a propósito: en Chile el perro mestizo/quiltro es más
-- común que cualquier raza pura, no es "una opción más" al final de la lista.
insert into public.razas (nombre) values
  ('Mestizo'),
  ('Labrador Retriever'),
  ('Golden Retriever'),
  ('Caniche (Poodle)'),
  ('Bulldog Francés'),
  ('Chihuahua'),
  ('Yorkshire Terrier'),
  ('Pug'),
  ('Schnauzer'),
  ('Beagle'),
  ('Cocker Spaniel'),
  ('Husky Siberiano'),
  ('Pastor Alemán'),
  ('Bulldog Inglés'),
  ('Shih Tzu'),
  ('Salchicha (Teckel)'),
  ('Boxer'),
  ('Rottweiler'),
  ('Border Collie'),
  ('Dálmata'),
  ('Pitbull'),
  ('Doberman'),
  ('Chow Chow'),
  ('Maltés'),
  ('Basset Hound'),
  ('Fox Terrier'),
  ('Akita'),
  ('Otra');

insert into public.colores (nombre) values
  ('Negro'),
  ('Blanco'),
  ('Café'),
  ('Dorado'),
  ('Gris'),
  ('Atigrado'),
  ('Bicolor'),
  ('Tricolor'),
  ('Manchado'),
  ('Otro');
