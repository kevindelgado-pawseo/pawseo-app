-- El nombre ya no se pide en el formulario de registro por email (se pide
-- después, en una pantalla de "completar perfil"), así que puede llegar
-- null hasta que el usuario lo complete. Google sí lo entrega de inmediato
-- vía metadata, por lo que ese flujo nunca pasa por null en la práctica.
alter table public.perfiles alter column nombre drop not null;

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.perfiles (id, email, nombre, avatar_url)
  values (
    new.id,
    new.email,
    coalesce(
      new.raw_user_meta_data ->> 'nombre',
      new.raw_user_meta_data ->> 'full_name',
      new.raw_user_meta_data ->> 'name'
    ),
    coalesce(new.raw_user_meta_data ->> 'avatar_url', new.raw_user_meta_data ->> 'picture')
  );
  return new;
end;
$$;
