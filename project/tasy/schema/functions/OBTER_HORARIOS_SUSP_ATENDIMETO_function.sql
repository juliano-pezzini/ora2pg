-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_horarios_susp_atendimeto (nr_atendimento_p bigint, qt_minutos_anterior_p bigint) RETURNS varchar AS $body$
DECLARE

				
hr_atual_w	varchar(5);
ds_retorno_w	varchar(2000) := null;

c01 CURSOR FOR
SELECT	to_char(b.DT_HORARIO, 'HH24:mi')
from 	prescr_medica a,
	Prescr_mat_hor b
where 	a.nr_prescricao = b.nr_prescricao
and	coalesce(b.ie_adep, 'N') <> 'N'
and	a.nr_atendimento = nr_atendimento_p
and 	(b.dt_suspensao IS NOT NULL AND b.dt_suspensao::text <> '')
and 	b.dt_suspensao >= clock_timestamp() - qt_minutos_anterior_p/1440
order by DT_HORARIO;


BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (qt_minutos_anterior_p IS NOT NULL AND qt_minutos_anterior_p::text <> '') then
	open C01;
	loop
	fetch C01 into	
		hr_atual_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (coalesce(ds_retorno_w::text, '') = '') then
			ds_retorno_w := hr_atual_w;
		else
			ds_retorno_w := substr(ds_retorno_w || ',' || hr_atual_w,1,2000);
		end if;
		end;
	end loop;
	close C01;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_horarios_susp_atendimeto (nr_atendimento_p bigint, qt_minutos_anterior_p bigint) FROM PUBLIC;
