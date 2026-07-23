-- Solo `nombre` es obligatorio al crear -- el resto se completa después en
-- una ficha editable (ver docs/modelo_datos.md).
create table public.mascotas (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  foto_url text,
  raza_id uuid references public.razas (id),
  fecha_nacimiento date,
  fecha_nacimiento_aproximada boolean not null default false,
  color_id uuid references public.colores (id),
  caracteristicas varchar(50),
  sexo text,
  peso numeric,
  created_at timestamptz not null default now()
);

alter table public.mascotas enable row level security;

-- Cualquier autenticado puede crear una mascota; la vinculación al dueño
-- ocurre después, vía trigger sobre mascotas_perfiles (siguiente migración)
-- -- acá todavía no hay ningún owner que verificar.
create policy "insert_mascota"
  on public.mascotas for insert
  to authenticated
  with check (true);

grant insert on public.mascotas to authenticated;
