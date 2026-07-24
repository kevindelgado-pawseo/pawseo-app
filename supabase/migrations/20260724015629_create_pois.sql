-- Puntos de interés pet (docs/modelo_datos.md, diseñado hace tiempo, recién
-- se migra ahora). Solo lectura desde el cliente -- se administran a mano
-- vía migración, no hay panel de administración todavía (docs/tecnico.md §4).
--
-- Explícitamente fuera de esta migración: check-in verificado por GPS,
-- entrega de recompensa_xp, cooldown anti-farming (tabla paseos_pois). Esa
-- lógica vive en una Edge Function aparte, no construida todavía -- la
-- columna recompensa_xp se migra tal como está diseñada, pero hoy no tiene
-- ningún consumidor.
create table public.tipos_poi (
  id uuid primary key default gen_random_uuid(),
  nombre text not null unique
);

create table public.pois (
  id uuid primary key default gen_random_uuid(),
  latitud double precision not null,
  longitud double precision not null,
  tipo_id uuid not null references public.tipos_poi (id),
  foto_url text,
  nombre text not null,
  descripcion text,
  comuna text not null,
  recompensa_xp integer not null default 0,
  created_at timestamptz not null default now()
);

alter table public.tipos_poi enable row level security;
alter table public.pois enable row level security;

create policy "select_tipos_poi"
  on public.tipos_poi for select
  to authenticated
  using (true);

create policy "select_pois"
  on public.pois for select
  to authenticated
  using (true);

grant select on public.tipos_poi to authenticated;
grant select on public.pois to authenticated;

insert into public.tipos_poi (nombre) values
  ('Plaza'),
  ('Canil'),
  ('Veterinaria'),
  ('Petshop');

-- Seed ilustrativo (Santiago Centro / Providencia / Ñuñoa / Las Condes) --
-- reemplazar/expandir con la curación real por comuna piloto cuando exista
-- (docs/producto.md §6).
insert into public.pois (latitud, longitud, tipo_id, nombre, descripcion, comuna, recompensa_xp)
select -33.4372, -70.6396, id, 'Parque Forestal', 'Parque a orillas del río Mapocho, ideal para paseos largos.', 'Santiago', 15
from public.tipos_poi where nombre = 'Plaza'
union all
select -33.4372, -70.6483, id, 'Cerro Santa Lucía', 'Cerro isla en pleno centro, senderos con sombra.', 'Santiago', 15
from public.tipos_poi where nombre = 'Plaza'
union all
select -33.4478, -70.6187, id, 'Parque Bustamante', 'Parque lineal con áreas verdes amplias.', 'Providencia', 15
from public.tipos_poi where nombre = 'Plaza'
union all
select -33.4558, -70.5990, id, 'Plaza Ñuñoa', 'Plaza central del barrio, siempre con perros paseando.', 'Ñuñoa', 10
from public.tipos_poi where nombre = 'Plaza'
union all
select -33.4090, -70.5896, id, 'Parque Araucano', 'Área de esparcimiento canino habilitada.', 'Las Condes', 20
from public.tipos_poi where nombre = 'Canil'
union all
select -33.3980, -70.5950, id, 'Canil Parque Bicentenario', 'Espacio cercado para soltar a tu perro.', 'Vitacura', 20
from public.tipos_poi where nombre = 'Canil'
union all
select -33.4260, -70.6110, id, 'Veterinaria Providencia', 'Atención general y urgencias.', 'Providencia', 10
from public.tipos_poi where nombre = 'Veterinaria'
union all
select -33.4103, -70.5722, id, 'Petshop Las Condes', 'Alimento, accesorios y peluquería canina.', 'Las Condes', 10
from public.tipos_poi where nombre = 'Petshop';
