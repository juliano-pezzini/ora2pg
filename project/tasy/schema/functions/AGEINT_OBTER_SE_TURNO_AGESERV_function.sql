-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_se_turno_ageserv ( dt_agenda_p timestamp, cd_agenda_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);
ie_dia_semana_w	smallint;
			

BEGIN

ie_dia_semana_w	:= obter_cod_dia_semana(dt_agenda_p);


select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
into STRICT	ds_retorno_w
from	agenda_turno
where	cd_agenda	= cd_agenda_p
and	((dt_agenda_p	>= dt_inicio_vigencia) or (coalesce(dt_inicio_vigencia::text, '') = ''))
and	((dt_agenda_p	<= dt_final_vigencia) or (coalesce(dt_final_vigencia::text, '') = ''))
and	((ie_dia_semana	= ie_dia_semana_w) or (ie_dia_semana = 9 and ie_dia_semana_w not in (1,7)))
and	dt_agenda_p <= to_date(to_char(dt_agenda_p, 'dd/mm/yyyy') || to_char(hr_inicial, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss');

ds_retorno_w := 'S';

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_se_turno_ageserv ( dt_agenda_p timestamp, cd_agenda_p bigint) FROM PUBLIC;
