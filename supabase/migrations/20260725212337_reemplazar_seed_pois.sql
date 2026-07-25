-- Reemplaza el seed ilustrativo de POIs (Santiago Centro/Providencia/etc.,
-- ver 20260724015629_create_pois.sql) por 3 lugares reales cerca de Mall
-- Plaza Egaña, provistos por Kevin -- primer paso de la curación real que
-- docs/producto.md §6 describe (comuna piloto), reemplazando la ilustrativa.
delete from public.pois;

insert into public.pois (latitud, longitud, tipo_id, nombre, descripcion, comuna, recompensa_xp)
select -33.4554, -70.5808, id, 'Parque Ramón Cruz', 'Parque de barrio con áreas verdes.', 'Ñuñoa', 15
from public.tipos_poi where nombre = 'Plaza'
union all
select -33.4526, -70.5784, id, 'Plaza Pedro Montt', 'Plaza de barrio cerca de Mall Plaza Egaña.', 'Ñuñoa', 15
from public.tipos_poi where nombre = 'Plaza'
union all
select -33.4529, -70.5713, id, 'Plaza Egaña', 'Plaza frente a Mall Plaza Egaña.', 'Ñuñoa', 15
from public.tipos_poi where nombre = 'Plaza';
