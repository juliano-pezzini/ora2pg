-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION com_obter_se_rat_lib ( cd_consultor_p bigint, dt_mes_referencia_p timestamp, ie_semana_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/* ie_opcao_p
	L = Liberado
	R = Recebido
*/
cont_w				bigint	:= 1;
ds_retorno_w			varchar(10);
dt_dia_aux_w			timestamp;
dt_inicio_semana_w		timestamp;
dt_fim_semana_w			timestamp;
qt_liberados_w			bigint;
qt_recebidos_w			bigint;
qt_registros_w			bigint;

C01 CURSOR FOR
	SELECT	dt_dia
	from	dia_v
	where	pkg_date_utils.get_WeekDay(dt_dia) = 2
	and	trunc(dt_dia,'month') = dt_mes_referencia_p;


BEGIN

if (coalesce(ie_semana_p,'0') <> '0') then
	open C01;
	loop
	fetch C01 into
		dt_dia_aux_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (cont_w	= ie_semana_p) then
			dt_inicio_semana_w	:= dt_dia_aux_w - 7;
			dt_fim_semana_w		:= dt_dia_aux_w - 1;
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
			dt_inicio_semana_w	:= dt_dia_aux_w - 7;
			dt_fim_semana_w		:= dt_dia_aux_w - 1;
		else
			dt_fim_semana_w		:= dt_dia_aux_w - 1;
		end if;
		cont_w	:= cont_w + 1;
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

	if (qt_registros_w > 0) then
		if (ie_opcao_p	= 'L') then
			select	count(*)
			into STRICT	qt_liberados_w
			from	proj_rat
			where (dt_final between dt_inicio_semana_w and dt_fim_semana_w)
			and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
			and	cd_executor	= cd_consultor_p;

			if (qt_liberados_w > 0) and (qt_registros_w	= qt_liberados_w) then
				ds_retorno_w	:= 'OK';
			else
				ds_retorno_w	:= 'X';
			end if;
		elsif (ie_opcao_p	= 'R') then
			select	count(*)
			into STRICT	qt_recebidos_w
			from	proj_rat
			where (dt_final between dt_inicio_semana_w and dt_fim_semana_w)
			and	(dt_receb_rat IS NOT NULL AND dt_receb_rat::text <> '')
			and	cd_executor	= cd_consultor_p;

			if (qt_recebidos_w > 0) and (qt_registros_w	= qt_recebidos_w) then
				ds_retorno_w	:= 'OK';
			else
				ds_retorno_w	:= 'X';
			end if;
		elsif (coalesce(ie_opcao_p,'X')	= 'X') then
			if (qt_registros_w > 0) then
				ds_retorno_w	:= 'OK';
			end if;
		end if;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION com_obter_se_rat_lib ( cd_consultor_p bigint, dt_mes_referencia_p timestamp, ie_semana_p text, ie_opcao_p text) FROM PUBLIC;

