-- RLS filtra FILAS, pero primero requiere el GRANT de SQL a nivel de tabla
-- para el rol — sin esto, Postgres rechaza la consulta antes de siquiera
-- evaluar las policies (permission denied for table perfiles).
grant select, update on public.perfiles to authenticated;
