-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_prox_medicao_prot_glic (cd_intervalo_p text, dt_prev_ant_p timestamp, dt_prev_controle_p timestamp, dt_controle_atual_p timestamp, dt_proximo_controle_p INOUT timestamp, qt_min_proximo_p INOUT bigint) AS $body$
DECLARE


ie_operacao_w			varchar(1);
qt_operacao_w			intervalo_prescricao.qt_operacao%type;
ds_horarios_w			varchar(255);
ds_horarios_ww		varchar(255);
ds_horarios_www		varchar(255);
ds_horario_w			varchar(7);
i				integer;
dt_horario_w			timestamp;
dt_proximo_controle_w	timestamp;
qt_min_proximo_w		smallint;


BEGIN
/* obter dados intervalo */

select	max(ie_operacao),
	max(qt_operacao),
	max(ds_horarios)
into STRICT	ie_operacao_w,
	qt_operacao_w,
	ds_horarios_w
from	intervalo_prescricao
where	cd_intervalo = cd_intervalo_p;

/* calcular proximo controle */

if (ie_operacao_w = 'H') and (qt_operacao_w IS NOT NULL AND qt_operacao_w::text <> '') then
	dt_proximo_controle_w	:= dt_controle_atual_p + qt_operacao_w / 24;
	qt_min_proximo_w		:= (qt_operacao_w / 24) * 1440;

elsif (ie_operacao_w = 'X') and (qt_operacao_w IS NOT NULL AND qt_operacao_w::text <> '') then
	dt_proximo_controle_w	:= dt_controle_atual_p + (24 / qt_operacao_w) / 24;
	qt_min_proximo_w		:= ((24 / qt_operacao_w) / 24) * 1440;

elsif (ie_operacao_w in ('F','V')) and (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') then
	if (dt_prev_controle_p IS NOT NULL AND dt_prev_controle_p::text <> '') and (dt_controle_atual_p >= dt_prev_controle_p - 30/1440) and (position(to_char(dt_prev_controle_p,'hh24') in ds_horarios_w) > 0) then
		ds_horarios_ww := replace(substr(ds_horarios_w, position(to_char(dt_prev_controle_p,'hh24') in ds_horarios_w)+3, length(ds_horarios_w)), to_char(dt_prev_controle_p,'hh24'), '');
	elsif (dt_prev_controle_p IS NOT NULL AND dt_prev_controle_p::text <> '') and (dt_prev_ant_p IS NOT NULL AND dt_prev_ant_p::text <> '') and (dt_controle_atual_p >= dt_prev_ant_p - 30/1440) and (position(to_char(dt_prev_ant_p,'hh24') in ds_horarios_w) > 0) then
		ds_horarios_ww := replace(substr(ds_horarios_w, position(to_char(dt_prev_ant_p,'hh24') in ds_horarios_w)+3, length(ds_horarios_w)), to_char(dt_prev_ant_p,'hh24'), '');
	end if;

	if (ds_horarios_ww IS NOT NULL AND ds_horarios_ww::text <> '') then
		ds_horarios_w := ds_horarios_ww;
	end if;

	/*
	select	padroniza_horario_prescr(ds_horarios_w, null) || ' '
	into	ds_horarios_www
	from	dual;
	*/
	ds_horarios_www := ds_horarios_w || ' ';

	while(ds_horarios_www IS NOT NULL AND ds_horarios_www::text <> '') loop
		begin
		select	position(' ' in ds_horarios_www)
		into STRICT	i
		;

		if (i > 1) and ((substr(ds_horarios_www, 1, i-1) IS NOT NULL AND (substr(ds_horarios_www, 1, i-1))::text <> '')) then
			ds_horario_w		:= substr(ds_horarios_www, 1, i-1);
			ds_horario_w		:= replace(ds_horario_w, ' ', '');
			ds_horarios_www	:= substr(ds_horarios_www, i+1, length(ds_horarios_www));

			/*
			if	(instr(ds_horario_w, 'A') > 0) then
				ds_horario_w := replace(ds_horario_w, 'A', '');
				dt_horario_w := to_date(to_char(dt_controle_atual_p+1,'dd/mm/yyyy') || ' ' || ds_horario_w || ':00', 'dd/mm/yyyy hh24:mi:ss');
			else
				dt_horario_w := to_date(to_char(dt_controle_atual_p,'dd/mm/yyyy') || ' ' || ds_horario_w || ':00', 'dd/mm/yyyy hh24:mi:ss');
			end if;
			*/
			if (ds_horario_w < to_char(dt_controle_atual_p,'hh24')) then
				dt_horario_w := to_date(to_char(dt_controle_atual_p+1,'dd/mm/yyyy') || ' ' || ds_horario_w || ':00', 'dd/mm/yyyy hh24:mi:ss');
			else
				begin
					dt_horario_w := to_date(to_char(dt_controle_atual_p,'dd/mm/yyyy') || ' ' || ds_horario_w || ':00', 'dd/mm/yyyy hh24:mi:ss');
				exception when others then
					dt_horario_w := to_date(to_char(dt_controle_atual_p,'dd/mm/yyyy') || ' ' || to_char(clock_timestamp(),'hh24:mi') || ':00', 'dd/mm/yyyy hh24:mi:ss');
				end;
			end if;

			if (dt_horario_w IS NOT NULL AND dt_horario_w::text <> '') and (dt_horario_w > dt_controle_atual_p) and
				((dt_horario_w >= dt_prev_controle_p) or (coalesce(dt_prev_controle_p::text, '') = '')) and (coalesce(dt_proximo_controle_w::text, '') = '') then
				dt_proximo_controle_w	:= dt_horario_w;
				ds_horarios_www		:= null;
			end if;
		else
			ds_horarios_www := null;
		end if;
		end;
	end loop;
end if;

dt_proximo_controle_p	:= dt_proximo_controle_w;
qt_min_proximo_p		:= qt_min_proximo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_prox_medicao_prot_glic (cd_intervalo_p text, dt_prev_ant_p timestamp, dt_prev_controle_p timestamp, dt_controle_atual_p timestamp, dt_proximo_controle_p INOUT timestamp, qt_min_proximo_p INOUT bigint) FROM PUBLIC;
