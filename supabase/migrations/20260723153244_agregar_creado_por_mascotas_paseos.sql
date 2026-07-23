-- Bug: crear_mascota_screen e iniciarPaseo hacen INSERT ... RETURNING (vía
-- `.insert().select()` del cliente). Postgres exige que la fila devuelta por
-- RETURNING pase también la policy de SELECT de la tabla -- y esa policy
-- dependía únicamente de `mascotas_perfiles`/`paseos_mascotas`, un vínculo
-- que recién se crea en un statement/trigger posterior (AFTER INSERT o un
-- segundo insert desde el cliente). Resultado: el INSERT en sí se ejecuta,
-- pero el RETURNING falla con "new row violates row-level security policy",
-- y el repository lo traduce al mensaje genérico "No se pudo crear...".
--
-- Fix: columna `creado_por` en la propia fila, poblada al momento del
-- insert -- no depende de que otro statement haya corrido todavía.
alter table public.mascotas
  add column creado_por uuid not null default auth.uid() references public.perfiles (id);

drop policy "insert_mascota" on public.mascotas;
create policy "insert_mascota"
  on public.mascotas for insert
  to authenticated
  with check (creado_por = auth.uid());

drop policy "select_own_mascotas" on public.mascotas;
create policy "select_own_mascotas"
  on public.mascotas for select
  using (
    creado_por = auth.uid()
    or exists (
      select 1 from public.mascotas_perfiles mp
      where mp.mascota_id = mascotas.id and mp.perfil_id = auth.uid()
    )
  );

alter table public.paseos
  add column creado_por uuid not null default auth.uid() references public.perfiles (id);

drop policy "insert_paseo" on public.paseos;
create policy "insert_paseo"
  on public.paseos for insert
  to authenticated
  with check (creado_por = auth.uid());

drop policy "select_own_paseos" on public.paseos;
create policy "select_own_paseos"
  on public.paseos for select
  using (
    creado_por = auth.uid()
    or exists (
      select 1 from public.paseos_mascotas pm
      join public.mascotas_perfiles mp on mp.mascota_id = pm.mascota_id
      where pm.paseo_id = paseos.id and mp.perfil_id = auth.uid()
    )
  );
