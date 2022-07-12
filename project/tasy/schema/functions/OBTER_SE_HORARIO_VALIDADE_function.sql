-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_horario_validade ( nr_prescricao_p bigint, nr_seq_item_p bigint) RETURNS varchar AS $body$
DECLARE


ds_horarios_w		varchar(255);
ds_hora_w		varchar(255);
ds_horarios_retorno_w	varchar(255) := '';
dt_inicio_prescr_w	timestamp;
dt_validade_prescr_w	timestamp;
dt_prescricao_w		timestamp;
dt_horario_w		timestamp;
qt_dia_adic_w		bigint;
k			bigint;


BEGIN

select	padroniza_horario_prescr(b.ds_horarios, CASE WHEN coalesce(b.qt_dia_prim_hor,0)=0 THEN CASE WHEN substr(Obter_Se_horario_hoje(a.dt_prescricao,a.dt_primeiro_horario,b.hr_prim_horario),1,1)='N' THEN '01/01/2000 23:59:59'  ELSE to_char(coalesce(a.dt_primeiro_horario,a.dt_prescricao),'dd/mm/yyyy hh24:mi:ss') END   ELSE '01/01/2000 23:59:59' END ),
	a.dt_inicio_prescr,
	a.dt_validade_prescr,
	trunc(a.dt_inicio_prescr,'mi')
into STRICT	ds_horarios_w,
	dt_inicio_prescr_w,
	dt_validade_prescr_w,
	dt_prescricao_w
from	prescr_material b,
	prescr_medica a
where	a.nr_prescricao	= nr_prescricao_p
and	a.nr_prescricao	= b.nr_prescricao
and	b.nr_sequencia	= nr_seq_item_p;
qt_dia_adic_w:= 0;
if (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') then
	while(ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') LOOP
		select	position(' ' in ds_horarios_w)
		into STRICT	k
		;

		if (k > 1) and ((substr(ds_horarios_w, 1, k -1) IS NOT NULL AND (substr(ds_horarios_w, 1, k -1))::text <> '')) then
			ds_hora_w		:= substr(ds_horarios_w, 1, k-1);
			ds_hora_w		:= replace(ds_hora_w, ' ','');
			ds_horarios_w		:= substr(ds_horarios_w, k + 1, 2000);
		elsif (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') then
			ds_hora_w 		:= replace(ds_horarios_w,' ','');
			ds_horarios_w	:= '';
		end if;

		if (position('A' in ds_hora_w) > 0) then
			qt_dia_adic_w	:= 1;
		end if;
		if (position('AA' in ds_hora_w) > 0) then
			qt_dia_adic_w	:= qt_dia_adic_w + 1;
		end if;

		ds_hora_w	:= replace(ds_hora_w,'A','');
		ds_hora_w	:= replace(ds_hora_w,'A','');

		dt_horario_w	:= to_date(to_char(dt_prescricao_w + coalesce(qt_dia_adic_w,0),'dd/mm/yyyy')||' '||replace(ds_hora_w,'A','')||':00','dd/mm/yyyy hh24:mi:ss');

		if (dt_horario_w < dt_prescricao_w) then
			dt_horario_w	:= dt_horario_w + 1;
		end if;

		if (dt_horario_w		< dt_inicio_prescr_w) or (dt_horario_w		> dt_validade_prescr_w) then
			ds_horarios_retorno_w	:= ds_horarios_retorno_w || ' - ' ||ds_hora_w;
		end if;

	end loop;
end if;

return	ds_horarios_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_horario_validade ( nr_prescricao_p bigint, nr_seq_item_p bigint) FROM PUBLIC;

