-- `pasos` nullable: dispositivos sin sensor de podómetro degradan a solo
-- tiempo (ver docs/producto.md §9). El conteo de pasos en sí (integración
-- con el podómetro del dispositivo) queda fuera de este cambio.
create table public.paseos (
  id uuid primary key default gen_random_uuid(),
  iniciado_en timestamptz not null default now(),
  finalizado_en timestamptz,
  pasos integer,
  created_at timestamptz not null default now()
);

-- Un paseo puede tener más de un perro (ver docs/modelo_datos.md).
create table public.paseos_mascotas (
  paseo_id uuid not null references public.paseos (id) on delete cascade,
  mascota_id uuid not null references public.mascotas (id) on delete cascade,
  primary key (paseo_id, mascota_id)
);

alter table public.paseos enable row level security;
alter table public.paseos_mascotas enable row level security;

-- Igual que mascotas: cualquier autenticado puede iniciar un paseo; el
-- vínculo con SU mascota se valida en paseos_mascotas, no acá.
create policy "insert_paseo"
  on public.paseos for insert
  to authenticated
  with check (true);

create policy "select_own_paseos"
  on public.paseos for select
  using (exists (
    select 1 from public.paseos_mascotas pm
    join public.mascotas_perfiles mp on mp.mascota_id = pm.mascota_id
    where pm.paseo_id = paseos.id and mp.perfil_id = auth.uid()
  ));

create policy "update_own_paseos"
  on public.paseos for update
  using (exists (
    select 1 from public.paseos_mascotas pm
    join public.mascotas_perfiles mp on mp.mascota_id = pm.mascota_id
    where pm.paseo_id = paseos.id and mp.perfil_id = auth.uid()
  ));

create policy "insert_own_paseo_mascota_link"
  on public.paseos_mascotas for insert
  to authenticated
  with check (exists (
    select 1 from public.mascotas_perfiles mp
    where mp.mascota_id = paseos_mascotas.mascota_id and mp.perfil_id = auth.uid()
  ));

create policy "select_own_paseo_mascota_link"
  on public.paseos_mascotas for select
  using (exists (
    select 1 from public.mascotas_perfiles mp
    where mp.mascota_id = paseos_mascotas.mascota_id and mp.perfil_id = auth.uid()
  ));

grant select, insert, update on public.paseos to authenticated;
grant select, insert on public.paseos_mascotas to authenticated;
