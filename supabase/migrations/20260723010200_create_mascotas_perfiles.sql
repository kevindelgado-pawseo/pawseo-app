-- Join multi-dueño simétrico: una mascota puede tener más de un perfil
-- vinculado (ver docs/modelo_datos.md).
create table public.mascotas_perfiles (
  mascota_id uuid not null references public.mascotas (id) on delete cascade,
  perfil_id uuid not null references public.perfiles (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (mascota_id, perfil_id)
);

alter table public.mascotas_perfiles enable row level security;

create policy "select_own_links"
  on public.mascotas_perfiles for select
  using (auth.uid() = perfil_id);

grant select on public.mascotas_perfiles to authenticated;
-- Sin policy ni grant de insert para authenticated: el único camino para
-- crear un vínculo es el trigger de abajo (security definer). Evita que un
-- usuario se autovincule a una mascota ajena saltándose la invitación
-- (el flujo de invitación en sí todavía no está diseñado).

-- Vincula automáticamente al creador de la mascota -- mismo patrón que
-- on_auth_user_created para perfiles.
create function public.handle_new_mascota()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.mascotas_perfiles (mascota_id, perfil_id)
  values (new.id, auth.uid());
  return new;
end;
$$;

create trigger on_mascota_created
  after insert on public.mascotas
  for each row execute procedure public.handle_new_mascota();

-- Ahora que mascotas_perfiles existe, se completan las policies de
-- mascotas que dependían de ella.
create policy "select_own_mascotas"
  on public.mascotas for select
  using (exists (
    select 1 from public.mascotas_perfiles mp
    where mp.mascota_id = mascotas.id and mp.perfil_id = auth.uid()
  ));

create policy "update_own_mascotas"
  on public.mascotas for update
  using (exists (
    select 1 from public.mascotas_perfiles mp
    where mp.mascota_id = mascotas.id and mp.perfil_id = auth.uid()
  ));

grant select, update on public.mascotas to authenticated;
