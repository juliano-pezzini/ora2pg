-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dias_horas_min_uteis ( dt_inicial_p timestamp, dt_final_p timestamp, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w 		varchar(40) := '0';
dia_util_w			timestamp;
qt_minutos_w		bigint := 0;
qt_dia_w			varchar(40) := '0';
qt_horas_w		bigint := 0;
qt_minutos_mod_w		bigint := 0;
qt_minutos_dia_inicial_w	bigint := 0;
qt_minutos_dia_final_w	bigint := 0;
qt_minutos_total_w		bigint := 0;

C01 CURSOR FOR
	SELECT *
	from (SELECT *
		 from (WITH RECURSIVE cte AS (
select datas_mes + 1 - 1 data_
			from (select trunc(dt_inicial_p, 'MM' ) datas_mes
				 )
			datas_mes + level - 1 <= last_day(datas_mes)
			  UNION ALL
select datas_mes + (c.level+1) - 1 data_
			from (select trunc(dt_inicial_p, 'MM' ) datas_mes
				 )
			datas_mes + level - 1 <= last_day(datas_mes)
			 JOIN cte c ON ()

) SELECT * FROM cte;
) alias3
		
union

		select *
		from (WITH RECURSIVE cte AS (
(select datas_mes + 1 - 1 data_
			from (select trunc(dt_final_p, 'MM') datas_mes
				 )
			datas_mes + level - 1 <= last_day(datas_mes)
			)  UNION ALL
(select datas_mes + (c.level+1) - 1 data_
			from (select trunc(dt_final_p, 'MM') datas_mes
				 )
			datas_mes + level - 1 <= last_day(datas_mes) JOIN cte c ON ()

) SELECT * FROM cte;
)
		) alias8
	where 	trunc(data_) between trunc(dt_inicial_p) and trunc(dt_final_p)
	and	obter_se_dia_util(trunc(data_), cd_estabelecimento_p) = 'S';


BEGIN

open C01;
loop
fetch C01 into
	dia_util_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (trunc(dia_util_w) = trunc(dt_inicial_p)) then
		if (to_char(dt_inicial_p, 'hh24:mi:ss') = '00:00:00') then
			qt_minutos_dia_inicial_w := 1440;
		else
			qt_minutos_dia_inicial_w := obter_dif_data(dt_inicial_p, trunc(dt_inicial_p + 86399/86400), 'TM');
		end if;

	elsif (trunc(dia_util_w) = trunc(dt_final_p)) then
		qt_minutos_dia_final_w := obter_dif_data(inicio_dia(dt_final_p), dt_final_p, 'TM');

	elsif (trunc(dia_util_w) <> trunc(dt_inicial_p)
		and	trunc(dia_util_w) <> trunc(dt_final_p)) then
		qt_minutos_w := qt_minutos_w + 1440;
	end if;

	end;
end loop;
close C01;

qt_minutos_total_w := qt_minutos_dia_inicial_w + qt_minutos_w + qt_minutos_dia_final_w;

select 	trim(both replace(to_char(floor(dividir(qt_minutos_total_w,1440)),'999,999,900'),',','.')),
	mod(qt_minutos_total_w,1440)
into STRICT	qt_dia_w,
	qt_minutos_mod_w
;

select	trunc(qt_minutos_mod_w/60)
into STRICT	qt_horas_w
;

ds_retorno_w := qt_dia_w || 'd ' || substr(to_char(qt_horas_w,'00'),2,2) || 'h ' || substr(to_char(mod(qt_minutos_total_w,60),'00'),2,2) || 'm';

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dias_horas_min_uteis ( dt_inicial_p timestamp, dt_final_p timestamp, cd_estabelecimento_p bigint) FROM PUBLIC;
