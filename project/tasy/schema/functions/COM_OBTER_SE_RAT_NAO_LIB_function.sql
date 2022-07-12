-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION com_obter_se_rat_nao_lib ( cd_consultor_p bigint, dt_mes_referencia_p timestamp, ie_semana_p bigint ) RETURNS varchar AS $body$
DECLARE



cont_w				bigint	:= 1;
ds_retorno_w			varchar(100);
dt_dia_aux_w			timestamp;
dt_inicio_semana_w		timestamp;
dt_fim_semana_w			timestamp;
qt_registros_w			bigint;

C01 CURSOR FOR
	SELECT	dt_dia
	from	dia_v
	where	pkg_date_utils.get_WeekDay(dt_dia) = 2
	and	trunc(dt_dia,'month') = dt_mes_referencia_p;


BEGIN

if (coalesce(ie_semana_p, 0) <> 0) then
	open C01;
	loop
	fetch C01 into
		dt_dia_aux_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (cont_w	= ie_semana_p) then
			dt_inicio_semana_w	:= dt_dia_aux_w;
			dt_fim_semana_w		:= dt_dia_aux_w + 6;
		end if;
		cont_w	:= cont_w + 1;
		end;
	end loop;
	close C01;
else
	open C01;
	loop
	fetch C01 into
		dt_dia_aux_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (cont_w = 1) then
			dt_inicio_semana_w	:= dt_dia_aux_w;
			dt_fim_semana_w		:= dt_dia_aux_w + 6;
		else
			dt_fim_semana_w	:= dt_dia_aux_w + 6;
		end if;
		cont_w := cont_w + 1;
		end;
	end loop;
	close C01;
end if;

if (dt_inicio_semana_w IS NOT NULL AND dt_inicio_semana_w::text <> '') and (dt_fim_semana_w IS NOT NULL AND dt_fim_semana_w::text <> '') then
	select	count(*)
	into STRICT	qt_registros_w
	from	proj_rat
	where (dt_final between dt_inicio_semana_w and dt_fim_semana_w)
	and	cd_executor	= cd_consultor_p;
end if;

select 	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END     --N = não precisava liberar / S = era para liberar e não liberou
into STRICT 	ds_retorno_w
FROM proj_agenda a
LEFT OUTER JOIN proj_projeto b ON (a.nr_seq_proj = b.nr_sequencia)
LEFT OUTER JOIN proj_rat c ON (b.nr_sequencia = c.nr_seq_proj)
WHERE qt_registros_w = 0 and (	SELECT	a.dt_agenda
		
		where 	a.cd_consultor = cd_consultor_p
		and 	a.ie_status <> wheb_mensagem_pck.get_texto(800054)) >= dt_inicio_semana_w and (	select	a.dt_agenda
		
		where 	a.cd_consultor = cd_consultor_p
		and 	a.ie_status <> wheb_mensagem_pck.get_texto(800054)) <= dt_fim_semana_w and a.cd_consultor = cd_consultor_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION com_obter_se_rat_nao_lib ( cd_consultor_p bigint, dt_mes_referencia_p timestamp, ie_semana_p bigint ) FROM PUBLIC;

