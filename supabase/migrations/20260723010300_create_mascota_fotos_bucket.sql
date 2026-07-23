-- Bucket público: la foto de mascota no es información sensible y evita
-- lógica de signed URLs en el cliente para el MVP. Convención de ruta:
-- mascota-fotos/<mascota_id>/<archivo>.
insert into storage.buckets (id, name, public)
values ('mascota-fotos', 'mascota-fotos', true)
on conflict (id) do nothing;

create policy "select_mascota_fotos"
  on storage.objects for select
  to public
  using (bucket_id = 'mascota-fotos');

create policy "insert_own_mascota_foto"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id = 'mascota-fotos'
    and exists (
      select 1 from public.mascotas_perfiles mp
      where mp.perfil_id = auth.uid()
        and mp.mascota_id::text = (storage.foldername(name))[1]
    )
  );

create policy "update_own_mascota_foto"
  on storage.objects for update
  to authenticated
  using (
    bucket_id = 'mascota-fotos'
    and exists (
      select 1 from public.mascotas_perfiles mp
      where mp.perfil_id = auth.uid()
        and mp.mascota_id::text = (storage.foldername(name))[1]
    )
  );
