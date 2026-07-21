-- Perfiles de usuario, 1:1 con auth.users. auth.users solo guarda credenciales;
-- los datos de negocio (nombre, foto) viven acá.
create table public.perfiles (
  id uuid primary key references auth.users (id) on delete cascade,
  email text not null,
  nombre text not null,
  avatar_url text,
  created_at timestamptz not null default now()
);

alter table public.perfiles enable row level security;

create policy "select_own_profile"
  on public.perfiles for select
  using (auth.uid() = id);

create policy "update_own_profile"
  on public.perfiles for update
  using (auth.uid() = id);

-- Crea el perfil automáticamente al registrarse, sin importar el proveedor
-- (email, Google, etc.). security definer: corre con privilegios elevados
-- para poder insertar pese a que el usuario nuevo aún no tiene sesión.
create function public.handle_new_user()
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
      new.raw_user_meta_data ->> 'name',
      split_part(new.email, '@', 1)
    ),
    coalesce(new.raw_user_meta_data ->> 'avatar_url', new.raw_user_meta_data ->> 'picture')
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
